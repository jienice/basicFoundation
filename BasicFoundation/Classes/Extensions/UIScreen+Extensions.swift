//
//  UIScreen+Extensions.swift
//  Basic
//
//  Created by jie.xing on 2022/2/24.
//  Copyright © 2022 jie.xing. All rights reserved.
//

import UIKit

public extension UIScreen {

    /// width
    static var width: CGFloat {
        return size.width
    }

    /// height
    static var height: CGFloat {
        return size.height
    }

    /// size
    static var size: CGSize {
        return UIScreen.main.bounds.size
    }
}
