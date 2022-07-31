//
//  UIApplication+Extensions.swift
//  Basic
//
//  Created by jie.xing on 2021/8/11.
//  Copyright © 2021 jie.xing. All rights reserved.
//

import UIKit

public extension UIApplication {

    /// 获取最上层的控制器
    /// - Parameter base: 查找范围
    /// - Returns:
    static func topViewController(base: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController) -> UIViewController { // swiftlint:disable:this line_length
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base!
   }
}
