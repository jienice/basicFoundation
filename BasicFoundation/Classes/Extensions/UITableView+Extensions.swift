//
//  UITableView+Extensions.swift
//  Basic
//
//  Created by jie.xing on 2022/2/16.
//  Copyright © 2022 jie.xing. All rights reserved.
//

import Foundation
import UIKit
import Action
import MJRefresh

public extension UITableView {
    
    var headerAction: CocoaAction? {
        return (mj_header as? HeaderRefresh)?.action
    }
    
    var footerAction: CocoaAction? {
        return (mj_footer as? FooterRefresh)?.action
    }
}
