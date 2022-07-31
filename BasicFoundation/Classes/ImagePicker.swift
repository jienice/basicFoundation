//
//  Photo.swift
//  Basic
//
//  Created by jie.xing on 2022/2/24.
//  Copyright © 2022 jie.xing. All rights reserved.
//

import Foundation
import UIKit
import Photos
import AVFoundation
import TZImagePickerController
import SwifterSwift

public protocol ImagePickerDelegate: Object {

    func imagePickerDidCancel(_ imagePicker: ImagePicker)

    func imagePicker(_ imagePicker: ImagePicker, didFinishSelected result: ImagePicker.Result)

    func imagePicker(_ imagePicker: ImagePicker, exportingAssets assets: [PHAsset])

    func imagePicker(_ imagePicker: ImagePicker, didFinishExportAssets assets: [PHAsset])

    func imagePicker(_ imagePicker: ImagePicker, didGetError error: Error)

    func imagePicker(_ imagePicker: ImagePicker, didFinishSaveImage image: UIImage)
}

public class ImagePicker: NSObject {

    public struct Result {
        public let photos: [String]
        public let videos: [String]
    }

    public enum Error: Swift.Error {
        case deviceNotSupport
        case export
        case fileTypeNotSupport
        case cameraAuthorize
        case albumAuthorize
    }

    public weak var delegate: ImagePickerDelegate?

}

// MARK: - Export Video/Images to SandBox
private extension ImagePicker {

    func exportVideo(with videoAsset: AVURLAsset, preset: String, complete: ((String?) -> Void)? = nil) {
        guard AVAssetExportSession.exportPresets(compatibleWith: videoAsset).contains(preset) else {
            delegate?.imagePicker(self, didGetError: Error.deviceNotSupport)
            complete?(nil)
            return
        }
        guard let session = AVAssetExportSession(asset: videoAsset, presetName: preset) else {
            delegate?.imagePicker(self, didGetError: Error.export)
            complete?(nil)
            return
        }
        guard !session.supportedFileTypes.isEmpty else {
            delegate?.imagePicker(self, didGetError: Error.fileTypeNotSupport)
            complete?(nil)
            return
        }
        let outputPath = FileManager.default.videoFilePath
        session.outputFileType = session.supportedFileTypes.first
        session.outputURL = URL(fileURLWithPath: outputPath)
        session.shouldOptimizeForNetworkUse = true
        session.exportAsynchronously { [weak self] in
            DispatchQueue.main.async {
                guard let weakSelf = self else { return }
                switch session.status {
                case .cancelled:
                    weakSelf.delegate?.imagePickerDidCancel(weakSelf)
                case .failed:
                    weakSelf.delegate?.imagePicker(weakSelf, didGetError: Error.export)
                    complete?(nil)
                case .completed:
                    complete?(outputPath)
                case .exporting, .unknown, .waiting:
                    break
                @unknown default:
                    break
                }
            }
        }
    }

    // swiftlint:disable:next line_length
    func getVideoOutPut(with asset: PHAsset, preset: String = AVAssetExportPreset640x480, complete: @escaping (String?) -> Void) {
        let options = PHVideoRequestOptions()
        options.version = .original
        options.deliveryMode = .automatic
        options.isNetworkAccessAllowed = true
        PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { [weak self] (videoAsset, _, _) in
            guard let asset = videoAsset as? AVURLAsset else { return }
            self?.exportVideo(with: asset, preset: preset, complete: {
                complete($0)
            })
        }
    }

    func getImageOutput(with asset: PHAsset, complete: @escaping (String?) -> Void) {
        TZImageManager.default().getOriginalPhotoData(with: asset) { (data, _, _) in
            let fileManager = FileManager.default
            let path = fileManager.imageFilePath
            if let data = data, let imgData = UIImage.init(data: data)?.fixOrientation().compressedData(quality: 0.3) {
                complete(fileManager.createFile(atPath: path, contents: imgData, attributes: nil) ? path: nil)
            } else {
                complete(nil)
            }
        }
    }

    func getImagesOutput(with assets: [PHAsset], complete: @escaping ([String]) -> Void) {
//        FileManager.default.checkFileIsExistsIfNotCreate(at: FileManager.default.images)
        let group = DispatchGroup()
        var photoPaths = [String?]()
        assets.forEach { [weak self] in
            group.enter()
            self?.getImageOutput(with: $0, complete: {
                photoPaths.append($0)
                group.leave()
            })
        }
        group.notify(queue: DispatchQueue.main) {
            complete(photoPaths.compactMap {$0})
        }
    }

}

// MARK: - TZImagePickerControllerDelegate
extension ImagePicker: TZImagePickerControllerDelegate {

    // swiftlint:disable:next line_length
    public func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool, infos: [[AnyHashable: Any]]!) {
        guard let input = assets as? [PHAsset] else { return }
        let photoAssets = input.filter { $0.mediaType == .image }.compactMap {$0}
        delegate?.imagePicker(self, exportingAssets: photoAssets)
        getImagesOutput(with: photoAssets) { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.delegate?.imagePicker(weakSelf, didFinishExportAssets: photoAssets)
            weakSelf.delegate?.imagePicker(weakSelf, didFinishSelected: Result(photos: $0, videos: [String]()))
        }
    }

    public func tz_imagePickerControllerDidCancel(_ picker: TZImagePickerController!) {
        delegate?.imagePickerDidCancel(self)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

//    // swiftlint:disable:next line_length
//    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        picker.delegate = nil
//        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
//        guard let data = image.fixOrientation().jpegData(compressionQuality: 0.75) else { return }
//        // todo
//        // FileManager.default.createDirectory(at: URL(string: FileManager.default.images)!, withIntermediateDirectories: true, attributes: nil)
//        let filePath = FileManager.default.imageFilePath
//        FileManager.default.createFile(atPath: filePath, contents: data, attributes: nil)
//        delegate?.imagePicker(self, didFinishSelected: Result(photos: [filePath], videos: []))
//        picker.dismiss(animated: true, completion: nil)
//    }
//
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        delegate?.imagePickerDidCancel(self)
    }

    public func takePhoto() {
        DeviceAuthorize.authorizeStatus(mediaType: .video, complete: { [weak self] in
            switch $0 {
            case .authorized, .notDetermined:
                self?.createTakePhotoPickerAndShow()
            case .limited, .notAuthorized:
                self?.sendCameraAuthorizeError()
            }
        })
    }

    @discardableResult
    private func createTakePhotoPickerAndShow() -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.cameraCaptureMode = .photo
        imagePicker.delegate = self
        UIApplication.topViewController().present(imagePicker, animated: true, completion: nil)
        return imagePicker
    }

    private func sendCameraAuthorizeError() {
        delegate?.imagePicker(self, didGetError: Error.cameraAuthorize)
    }

}

extension ImagePicker {

    public func selectPhoto(maxCount: Int = 1) {
        DeviceAuthorize.authorizeStatus(mediaType: .album, complete: { [weak self] in
            switch $0 {
            case .authorized:
                let picker = TZImagePickerController.imagePicker(maxCount: maxCount, delegate: self)
                UIApplication.topViewController().present(picker, animated: true, completion: nil)
            case .notAuthorized:
                self?.sendPhotoAlbumAuthorizeError()
            default:
                break
            }
        })
    }

    public func saveImage(image: UIImage) {
        DeviceAuthorize.authorizeStatus(mediaType: .album, complete: { [weak self] in
            switch $0 {
            case .authorized:
                PHPhotoLibrary.shared().performChanges({
                    PHAssetCreationRequest.creationRequestForAsset(from: image)
                }, completionHandler: {
                    guard let weakSelf = self else { return }
                    if let error = $1 {
                        weakSelf.delegate?.imagePicker(weakSelf, didGetError: error)
                    } else {
                        DispatchQueue.main.async {
                            weakSelf.delegate?.imagePicker(weakSelf, didFinishSaveImage: image)
                        }
                    }
                })
            case .notAuthorized:
                self?.sendPhotoAlbumAuthorizeError()
            default:
                break
            }
        })
    }

    private func sendPhotoAlbumAuthorizeError() {
        delegate?.imagePicker(self, didGetError: Error.albumAuthorize)
    }
}

extension TZImagePickerController {

    static func imagePicker(maxCount: Int, delegate: TZImagePickerControllerDelegate?) -> TZImagePickerController {
        let picker = TZImagePickerController(maxImagesCount: maxCount, delegate: delegate)!
        picker.allowPickingOriginalPhoto = false
        picker.allowPickingImage = true
        picker.allowTakePicture = false
        picker.allowTakeVideo = false
        picker.allowPickingVideo = false
        picker.allowPickingMultipleVideo = false
        picker.navigationBar.isTranslucent = false
        picker.modalPresentationStyle = .fullScreen
        picker.allowPreview = true
        picker.allowPickingGif = false
        return picker
    }
}
