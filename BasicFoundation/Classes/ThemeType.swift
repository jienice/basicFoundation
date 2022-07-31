//
//  ThemeManager.swift
//  BasicFoundation
//
//  Created by jie.xing on 2022/2/24.
//  Copyright © 2022 jie.xing. All rights reserved.
//

import UIKit
import RxRelay
import Swinject

public protocol Theme {

}

public final class ThemeType {
    
    public static let `default` = ThemeType()

    public var theme: BehaviorRelay<Theme?> = BehaviorRelay(value: nil)
    
}

//public extension UIColor {
//    
//    static func color<T>(with keyPath: KeyPath<T, UIColor>) -> UIColor {
//        return ThemeType.default.theme.value?[keyPath: keyPath] ?? .red
//    }
//    
//}
