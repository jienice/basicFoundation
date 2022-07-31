//
//  UIBarButtonItem+Extensions.swift
//  Basic
//
//  Created by jie.xing on 2021/8/11.
//  Copyright © 2022 jie.xing. All rights reserved.
//

import UIKit
import Action

public extension UIBarButtonItem {

    /// 通过Image创建
    /// - Parameters:
    ///   - image:
    ///   - action: 点击操作
    /// - Returns:
    static func create(with image: UIImage, action: CocoaAction? = nil) -> UIBarButtonItem {
        var item = UIBarButtonItem(image: image.template, style: .plain, target: nil, action: nil)
        item.rx.action = action
        return item
    }

    /// 通过String创建
    /// - Parameters:
    ///   - image:
    ///   - action: 点击操作
    /// - Returns:
    static func create(with title: String, action: CocoaAction? = nil) -> UIBarButtonItem {
        var item = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
        item.rx.action = action
        return item
    }

}
