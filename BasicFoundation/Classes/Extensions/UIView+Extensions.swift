//
//  UIView+Extensions.swift
//  Basic
//
//  Created by jie.xing on 2022/2/23.
//  Copyright © 2022 jie.xing. All rights reserved.
//

import UIKit

public extension UIView {

    /// 递归获取view下所有子view
    /// - Returns:
    func allSubviews() -> [UIView] {
        var subViews = [UIView]()
        for item in subviews {
            subViews.append(item)
            subViews.append(contentsOf: item.allSubviews())
        }
        return subViews
    }

    /// 设置圆角
    /// - Parameter radius: 圆角大小
    func makeRoundedCorners(_ radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }

    /// 添加渐变色
    /// - Parameters:
    ///   - colors:
    ///   - locations:
    ///   - startPoint:
    ///   - endPoint:
    func addGradientLayer(colors: [CGColor], locations: [NSNumber] = [0, 1], startPoint: CGPoint, endPoint: CGPoint) {
        let bgLayer = CAGradientLayer()
        bgLayer.colors = colors
        bgLayer.locations = locations
        bgLayer.startPoint = startPoint
        bgLayer.endPoint = endPoint
        layer.addSublayer(bgLayer)
        rx.methodInvoked(#selector(UIView.layoutSubviews))
            .subscribe(onNext: { [weak self] _ in
                if let bounds = self?.bounds {
                    bgLayer.frame = bounds
                }
            }).disposed(by: rx.disposeBag)
    }

}
