//
//  UINavigationBar+Extensions.swift
//  Basic
//
//  Created by jie.xing on 2022/2/24.
//  Copyright © 2022 jie.xing. All rights reserved.
//

import UIKit

public extension UINavigationBar {

    func setHairlineImageViewColor(_ color: UIColor) {
        if let img = hairlineImageView {
            let sepLine = UIView()
            sepLine.frame = img.frame
            sepLine.y = 44
            if #available(iOS 10, *) {
                img.isHidden = true
            }
            sepLine.height = 0.5
            sepLine.backgroundColor = color
            addSubview(sepLine)
        }
    }

    var hairlineImageView: UIImageView? {
        for item in allSubviews() {
            if item.isKind(of: UIImageView.self) {
                return item as? UIImageView
            }
        }
        return nil
    }

}
