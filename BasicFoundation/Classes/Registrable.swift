//
//  Registrable.swift
//  Basic
//
//  Created by jie.xing on 2020/2/24.
//  Copyright © 2022 jie.xing. All rights reserved.
//

import UIKit

public protocol Registrable {

}

public extension Registrable {

    static var identifier: String {
        return String(describing: "\(self)")
    }

    static var nib: UINib? {
        return UINib(nibName: "\(self)", bundle: nil)
    }
}
extension UITableViewCell: Registrable {}
extension UICollectionViewCell: Registrable {}
extension UITableViewHeaderFooterView: Registrable {}
