//
//  UIViewController+Extensions.swift
//  Basic
//
//  Created by jie.xing on 2022/2/24.
//  Copyright © 2022 jie.xing. All rights reserved.
//

import UIKit

private var clearKey: UInt8 = 0
public extension UIViewController {

    private(set) var navigationBarClear: Bool {
        get {
            if let lookup = objc_getAssociatedObject(self, &clearKey) as? Bool {
                return lookup
            }
            let value = false
            objc_setAssociatedObject(self, &clearKey, value, .OBJC_ASSOCIATION_ASSIGN)
            return value
        }
        set {
            objc_setAssociatedObject(self, &clearKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
//
//    /// 设置导航栏颜色
//    /// - Parameter color: 颜色统一在主题中进行配置，此处传入值
//    func setupNavigationBar(_ color: KeyPath<Theme, UIColor>) {
//        navigationController?.navigationBar.isTranslucent = false
//        if #available(iOS 15.0, *) {
//            let barAppearance = UINavigationBarAppearance()
//            barAppearance.configureWithTransparentBackground()
//            barAppearance.backgroundColor = UIColor.color(by: color)
//            navigationController?.navigationBar.scrollEdgeAppearance = barAppearance
//            navigationController?.navigationBar.standardAppearance = barAppearance
//        } else {
//            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//            navigationController?.navigationBar.shadowImage = UIImage()
//            navigationController?.navigationBar.backgroundColor = UIColor.color(by: color)
//        }
//        setupNavigationBarTheme()
//    }
//
    
    /// 设置导航栏透明
    func setupNavigationBarClear() {
        navigationController?.navigationBar.isTranslucent = true
        if #available(iOS 15.0, *) {
            let barAppearance = UINavigationBarAppearance()
            barAppearance.configureWithTransparentBackground()
            barAppearance.backgroundColor = UIColor.clear
            navigationController?.navigationBar.scrollEdgeAppearance = barAppearance
            navigationController?.navigationBar.standardAppearance = barAppearance
        } else {
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.backgroundColor = UIColor.clear
        }
//        setupNavigationBarTheme()
    }
    
    
    /// 设置导航栏透明，并且控制器中的UIScrollView置顶布局
    /// - Parameter adjustsScrollView: Controller中的UIScrollView，一般为UITableView
    func setupNavigationBarClearShould(adjustsScrollView: UIScrollView? = nil) {
        navigationBarClear = true
        if #available(iOS 11, *) {
            adjustsScrollView?.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }
}
