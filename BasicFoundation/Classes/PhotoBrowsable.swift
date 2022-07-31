//
//  PhotoBrowsable.swift
//  Basic
//
//  Created by jie.xing on 2022/2/24.
//  Copyright © 2022 jie.xing. All rights reserved.
//

import Foundation
import SKPhotoBrowser

public protocol PhotoBrowsable {

}

extension PhotoBrowsable {

    private func SKPhotoBrowserDefaultSet() {
        SKPhotoBrowserOptions.displayAction = false
        SKPhotoBrowserOptions.displayCounterLabel = true
        SKPhotoBrowserOptions.displayBackAndForwardButton = false
        SKPhotoBrowserOptions.enableSingleTapDismiss = true
        SKPhotoBrowserOptions.displayHorizontalScrollIndicator = false
        SKPhotoBrowserOptions.displayVerticalScrollIndicator = false
    }

    public func browsePhotos(urls: [URL], initialPageIndex: Int = 0) {
        SKPhotoBrowserDefaultSet()
        let photos = urls.map { resource -> SKPhotoProtocol in
            if resource.isFileURL {
                return SKLocalPhoto.photoWithImageURL(resource.path)
            } else {
                return SKPhoto.photoWithImageURL(resource.absoluteString)
            }
        }
        let browser = SKPhotoBrowser(photos: photos, initialPageIndex: initialPageIndex)
        UIApplication.topViewController()
            .present(browser, animated: false, completion: nil)
    }

    public func browsePhoto(path: String) {
        SKPhotoBrowserDefaultSet()
        let photo = SKPhoto.photoWithImageURL(path)
        let browser = SKPhotoBrowser(photos: [photo])
        UIApplication.topViewController()
            .present(browser, animated: false, completion: nil)
    }

    public func browsePhotosWithoutLocal(paths: [String], initialPageIndex: Int = 0) {
        SKPhotoBrowserDefaultSet()
        let photos = paths.map { SKLocalPhoto.photoWithImageURL($0) }
        let browser = SKPhotoBrowser(photos: photos, initialPageIndex: initialPageIndex)
        UIApplication.topViewController()
            .present(browser, animated: false, completion: nil)
    }

}
