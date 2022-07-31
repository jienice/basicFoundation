//
//  List.swift
//  Basic
//
//  Created by jie.xing on 2022/2/24.
//  Copyright © 2022 jie.xing. All rights reserved.
//

import Foundation

public protocol ListType: Codable {
    
    associatedtype Element: Codable

    /// 当前页
    var page: Int {get}
    
    /// 总页
    var totalPages: Int {get}
    
    /// 总数
    var totalSize: Int {get}
    
    /// 数据
    var list: [Element] {get}
    
}

extension ListType {
    
    /// 数据刷新状态
    var refreshStatus: RefreshStatus {
        if page == 1, totalPages == 0, totalSize == 0 {
            return .error(error: RefreshStatus.EmptyDataSet.empty)
        } else if page == 1, totalPages == 1, totalSize > 0 {
            return .onlyOnePage
        } else if page < totalPages, totalSize > 0 {
            return .canLoadMore
        } else if page == totalPages, page > 0, totalSize != 0 {
            return .noMore
        } else {
            return .error(error: RefreshStatus.EmptyDataSet.networkError)
        }
    }
}
