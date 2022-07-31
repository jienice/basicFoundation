//
//  ReuseDisposable.swift
//  Basic
//
//  Created by jie.xing on 2022/2/24.
//  Copyright © 2022 jie.xing. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

private var reuseDisposeBagKey: UInt8 = 0
public protocol ReuseDisposable: Object {

    var reuseDisposeBag: DisposeBag {get set}
}

public extension ReuseDisposable {

    var reuseDisposeBag: DisposeBag {
        get {
            if let lookUp = objc_getAssociatedObject(self, &reuseDisposeBagKey) as? DisposeBag {
                return lookUp
            }
            let value = DisposeBag()
            objc_setAssociatedObject(self, &reuseDisposeBagKey, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return value
        }
        set {
            objc_setAssociatedObject(self, &reuseDisposeBagKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension UICollectionViewCell: ReuseDisposable {}
extension UITableViewCell: ReuseDisposable {}
extension UITableViewHeaderFooterView: ReuseDisposable {}
