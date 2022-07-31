//
//  ViewModelTemplate.swift
//  Basic
//
// Created by jie.xing on 2022/2/11.
// Copyright (c) 2022 jie.xing. All rights reserved.
//

import Foundation

public protocol ViewModelTemplate: ErrorEmitable {

    /// 传入的订阅
    associatedtype Input

    /// 传到UI层的订阅
    associatedtype Output

    func transform(input: Input) -> Output
}
