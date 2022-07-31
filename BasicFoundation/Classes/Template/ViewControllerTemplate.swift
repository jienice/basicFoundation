//
//  ViewControllerTemplate.swift
//  Basic
//
// Created by jie.xing on 2022/2/11.
// Copyright (c) 2022 jie.xing. All rights reserved.
//

import Foundation

public protocol ViewControllerTemplate {

    /// 绑定ViewModel
    func bindViewModel()

    /// 配置ui属性
    func configUI()
}
