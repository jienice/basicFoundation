//
//  DeviceAuthorize.swift
//  Basic
//
//  Created by jie.xing on 2022/2/24.
//  Copyright © 2022 jie.xing. All rights reserved.
//

import Foundation
import Photos
import RxSwift
import RxCocoa
import CoreLocation
// https://developer.aliyun.com/article/768114
public struct DeviceAuthorize {
    
    /// 权限状态枚举
    public enum Status {
        case notDetermined
        case notAuthorized
        case authorized
        case limited
    }
    
    /// 权限类型枚举
    public enum MediaType {
        case album
        case video
        case audio
    }
    
    /// 获取授权状态
    /// - Parameters:
    ///   - mediaType: 权限类型
    ///   - complete: 授权状态
    public static func authorizeStatus(mediaType: MediaType, complete: @escaping (Status) -> Void) {
        switch mediaType {
        case .album:
            photoAlbumAuthorizeStatus(complete: complete)
        case .video:
            complete(avMediaAuthorizeStatus(for: .video))
        case .audio:
            complete(avMediaAuthorizeStatus(for: .audio))
        }
    }
    
    /// 请求用户相册授权
    /// - Parameter complete: 回调
    private static func requestPhotoAlbumAuthorize(complete: @escaping (Status) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            var output: Status = .notAuthorized
            switch status {
            case .notDetermined:
                break
            case .restricted, .denied:
                break
            case .authorized, .limited:
                output = .authorized
            }
            DispatchQueue.main.async {
                complete(output)
            }
        }
    }
    
    /// 获取相册权限状态
    /// - Parameter complete:
    private static func photoAlbumAuthorizeStatus(complete: @escaping (Status) -> Void) {
        let granted = PHPhotoLibrary.authorizationStatus()
        switch granted {
        case .authorized:
            complete(.authorized)
        case .denied, .restricted:
            complete(.notAuthorized)
        case .notDetermined:
            requestPhotoAlbumAuthorize {
                complete($0)
            }
        case .limited:
            complete(.authorized)
        }
    }

    /// 获取设备权限状态
    /// - Parameter mediaType:
    /// - Returns:
    private static func avMediaAuthorizeStatus(for mediaType: AVMediaType) -> Status {
        let setStatus = AVCaptureDevice.authorizationStatus(for: mediaType)
        var status: Status = .notDetermined
        switch setStatus {
        case .denied, .restricted:
            status = .notAuthorized
        case .authorized:
            status = .authorized
        case .notDetermined:
            break
        }
        return status
    }

}

extension Reactive where Base == DeviceAuthorize {

    static func authorizeStatus(for mediaType: DeviceAuthorize.MediaType) -> Observable<DeviceAuthorize.Status> {
        return Observable.create { observer -> Disposable in
            Base.authorizeStatus(mediaType: mediaType, complete: {
                observer.onNext($0)
                observer.onCompleted()
            })
            return Disposables.create()
        }
    }
}
