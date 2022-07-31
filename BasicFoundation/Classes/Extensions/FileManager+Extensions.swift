//
//  FileManager+Extensions.swift
//  Basic
//
//  Created by jie.xing on 2022/2/24.
//  Copyright © 2021 jie.xing. All rights reserved.
//

import Foundation

public extension FileManager {

    // MARK: PATH
    var library: String {
        return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first!
    }

    var caches: String {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
    }

    var document: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    }

    var images: String {
        return document + "/" + "Images"
    }

    var imageFilePath: String {
        return images + "/" + UUID().uuidString + ".jpeg"
    }

    var videos: String {
        return document + "/" + "Videos"
    }

    var videoFilePath: String {
        return videos + "/" + UUID().uuidString + ".mp4"
    }

    /// 获取文件夹大小
    /// - Parameter path:
    /// - Returns:
    func folderSize(at path: String) -> UInt {
        return (try? contentsOfDirectory(atPath: path).reduce(into: UInt(0), {
            $0 += fileSize(at: path + "/" + $1)
        })) ?? 0
    }

    /// 获取文件大小
    /// - Parameter path:
    /// - Returns:
    func fileSize(at path: String) -> UInt {
        return ((try? attributesOfItem(atPath: path)[.size]) as? UInt) ?? 0
    }
}
