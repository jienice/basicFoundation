//
//  NetworkConfiguration.swift
//  Basic
//
// Created by jie.xing on 2022/2/21.
//  Copyright © 2022 jie.xing. All rights reserved.
//

import Foundation
import Moya

public protocol NetworkConfiguration: Configuration {

    /// 添加moya的插件
    var plugins: [PluginType] {get}

    /// 请求基础url
    var baseUrl: String {get}

    /// 默认的请求header
    var defaultHeaders: [String: String]? {get}
}
