//
//  Refresh.swift
//  Basic
//
//  Created by jie.xing on 2022/2/24.
//  Copyright © 2022 jie.xing. All rights reserved.
//

import Foundation
import MJRefresh
import RxSwift
import Action

private var headerActionKey: UInt8 = 0
public final class HeaderRefresh: MJRefreshNormalHeader {
    
    public var action: CocoaAction {
        if let lookup = objc_getAssociatedObject(self, &headerActionKey) as? CocoaAction {
            return lookup
        }
        let action = CocoaAction(workFactory: {
            return Observable.just(())
        })
        objc_setAssociatedObject(self, &headerActionKey, action, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return action
    }
    
    public init() {
        super.init(frame: CGRect.zero)
        self.lastUpdatedTimeLabel?.isHidden = true
        self.stateLabel?.isHidden = true
        self.refreshingBlock = { [weak self] in
            self?.action.execute()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private var footerRefreshKey: UInt8 = 0
public final class FooterRefresh: MJRefreshAutoNormalFooter {
    
    public var action: CocoaAction {
        if let lookup = objc_getAssociatedObject(self, &footerRefreshKey) as? CocoaAction {
            return lookup
        }
        let action = CocoaAction(workFactory: {
            return Observable.just(())
        })
        objc_setAssociatedObject(self, &footerRefreshKey, action, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return action
    }

    public init() {
        super.init(frame: CGRect.zero)
        self.isHidden = true
        self.refreshingBlock = { [weak self] in
            self?.action.execute()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
