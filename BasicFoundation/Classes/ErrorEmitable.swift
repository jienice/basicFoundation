//
//  ErrorEmitable.swift
//  Basic
//
//  Created by jie.xing on 2022/2/24.
//  Copyright © 2022 jie.xing. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxOptional

private var errorKey: UInt8 = 0
public protocol ErrorEmitable: Object {

    var error: BehaviorRelay<Error?> {get}
}

public extension ErrorEmitable {

    var error: BehaviorRelay<Error?> {
        if let lookUp = objc_getAssociatedObject(self, &errorKey) as? BehaviorRelay<Error?> {
            return lookUp
        }
        let value = BehaviorRelay<Error?>(value: nil)
        objc_setAssociatedObject(self, &errorKey, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return value
    }
}
