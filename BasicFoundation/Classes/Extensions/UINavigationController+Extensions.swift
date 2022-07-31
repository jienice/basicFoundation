//
//  UINavigationController+Extensions.swift
//  Basic
//
//  Created by jie.xing on 2022/2/24.
//  Copyright © 2022 jie.xing. All rights reserved.
//

import UIKit

public extension UINavigationController {

    /// 获取控制器栈中特定类型的控制器
    /// - Returns:
    func viewControllerInStack<T: UIViewController>(_ type: T.Type) -> T? {
        return viewControllers
                .map { $0 as? T }
                .compactMap { $0 }
                .first
    }

}
