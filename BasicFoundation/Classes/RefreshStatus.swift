//
//  RefreshStatus.swift
//  Basic
//
//  Created by jie.xing on 2022/2/24.
//  Copyright © 2022 jie.xing. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DZNEmptyDataSet
import MJRefresh

/// ScrollView 刷新状态枚举
/// 影响header、footer状态
public enum RefreshStatus {
    
    /// 空界面状态枚举
    public enum EmptyDataSet: Error {
        case empty
        case noNetWork
        case networkError
    }
    case noMore
    case onlyOnePage
    case canLoadMore
    case error(error: Error)
}

// MARK: RefreshStatusSettable
private var refreshStatusKey: UInt8 = 0
public protocol RefreshStatusSettable: UIScrollView {

    /// 刷新状态值，设置新值后会更新header、footer ui
    var refreshStatus: RefreshStatus? {get set}
}

public extension RefreshStatusSettable {

    var refreshStatus: RefreshStatus? {
        get {
            objc_getAssociatedObject(self, &refreshStatusKey) as? RefreshStatus
        }
        set {
            objc_setAssociatedObject(self, &refreshStatusKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            handleRefreshStatus()
        }
    }

    func handleRefreshStatus() {
        guard let refreshStatus = refreshStatus else { return }
        switch refreshStatus {
        case .canLoadMore:
            mj_header?.endRefreshing()
            mj_footer?.endRefreshing()
            mj_footer?.resetNoMoreData()
            mj_footer?.isHidden = false
        case .noMore:
            mj_header?.endRefreshing()
            mj_footer?.endRefreshingWithNoMoreData()
            mj_footer?.isHidden = false
        case .onlyOnePage:
            mj_header?.endRefreshing()
            mj_footer?.endRefreshingWithNoMoreData()
            mj_footer?.isHidden = true
        case let .error(error):
            mj_header?.endRefreshing()
            mj_footer?.endRefreshing()
            if error is RefreshStatus.EmptyDataSet {
                mj_footer?.isHidden = true
                reloadEmptyDataSet()
            }
        }
    }
}


// MARK: RefreshStatusCreatable
private var refreshStatusSendKey: UInt8 = 0
public protocol RefreshStatusCreatable: Object {

    /// 数据状态值，从ViewModel传到Controller
    var refreshStatus: BehaviorRelay<RefreshStatus?> { get }
}

public extension RefreshStatusCreatable {

    var refreshStatus: BehaviorRelay<RefreshStatus?> {
        if let lookUp = objc_getAssociatedObject(self, &refreshStatusSendKey) as? BehaviorRelay<RefreshStatus?> {
            return lookUp
        }
        let value = BehaviorRelay<RefreshStatus?>(value: nil)
        objc_setAssociatedObject(self, &refreshStatusSendKey, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return value
    }

}


// MARK: Rx
public extension Reactive where Base: RefreshStatusSettable {

    var refreshStatus: Binder<RefreshStatus?> {
        return Binder(self.base) { target, status in
            guard let status = status else { return }
            target.refreshStatus = status
        }
    }

}

extension UITableView: RefreshStatusSettable {}
