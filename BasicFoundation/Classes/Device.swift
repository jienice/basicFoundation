//
//  Device.swift
//  Basic
//
//  Created by jie.xing on 2022/2/24.
//  Copyright © 2022 jie.xing. All rights reserved.
//

import Foundation
import DeviceKit

public extension Device {

    static var statusBar: CGFloat {
        if #available(iOS 13, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            let statusBarSize = window?.windowScene?.statusBarManager?.statusBarFrame.size ?? CGSize.zero
            return min(statusBarSize.width, statusBarSize.height)
        } else {
            let statusBarSize = UIApplication.shared.statusBarFrame.size
            return min(statusBarSize.width, statusBarSize.height)
        }
    }

    static var tabBarPadding: CGFloat {
        if current.isFaceIDCapable {
            return 34
        } else if current.isSimulator {
            return 34
        } else {
            return 20
        }
    }

    static var navigationBar: CGFloat {
        return 44
    }

    static var tabBarHeight: CGFloat {
        return tabBarPadding + 49
    }

}
