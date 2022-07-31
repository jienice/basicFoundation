//
//  ViewElementConfigurable.swift
//  Basic
//
//  Created by jie.xing on 2022/2/11.
//  Copyright © 2022 jie.xing. All rights reserved.
//

import Foundation

public protocol ViewElementConfigurable {

    associatedtype Element

    func config(with element: Element)
}
