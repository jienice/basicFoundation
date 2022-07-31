//
//  XLFormRowDescriptor+Extensions.swift
//  Basic
//
//  Created by jie.xing on 2022/2/24.
//  Copyright © 2022 jie.xing. All rights reserved.
//

import XLForm
import UIKit

/* Example Code
 此文件主要用来展示如何自定义XLForm中Cell属性
public struct FormConfig {

    public struct Font {
        public static let text = UIFont.systemFont(ofSize: 14)
        public static let detailText = UIFont.systemFont(ofSize: 14)
        public static let textView = UIFont.systemFont(ofSize: 14)
        public static let textViewPlaceholder = UIFont.systemFont(ofSize: 14)
    }

    public struct Color {
        public static let text = UIColor.text()
        public static let detailText = UIColor.textSecondary()
        public static let placeholder = UIColor.textGray()
        public static let textView = UIColor.textSecondary()
        public static let background = UIColor.Material.white
        public static let tint = UIColor.primary()
    }
}

public extension XLFormRowDescriptor {

    func typeTextCellConfig(title: String, placeholder: String? = nil) {
        self.title = title
        if let placeholder = placeholder {
            // swiftlint:disable:next line_length
            let attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: FormConfig.Color.placeholder])
            cellConfig["textField.attributedPlaceholder"] = attributedPlaceholder
        }
        cellConfig["textLabel.textColor"] = FormConfig.Color.text
        cellConfig["textField.textColor"] = FormConfig.Color.detailText
        cellConfig["textLabel.font"] = FormConfig.Font.text
        cellConfig["textField.font"] = FormConfig.Font.detailText
        cellConfig["backgroundColor"] = FormConfig.Color.background
        cellConfig["textField.textAlignment"] = NSTextAlignment.right.rawValue
        cellConfig["selectionStyle"] = UITableViewCell.SelectionStyle.none.rawValue
    }

    func typeDateCellConfig(title: String, placeholder: String? = nil) {
        self.title = title
        self.noValueDisplayText = placeholder
        cellConfig["maximumDate"] = Date()
        cellConfig["textLabel.textColor"] = FormConfig.Color.text
        cellConfig["textLabel.font"] = FormConfig.Font.text
        cellConfig["detailTextLabel.font"] = FormConfig.Font.detailText
        cellConfig["detailTextLabel.textColor"] = FormConfig.Color.detailText
        cellConfig["backgroundColor"] = FormConfig.Color.background
        cellConfig["selectionStyle"] = UITableViewCell.SelectionStyle.none.rawValue
         // swiftlint:disable:next line_length
        cellConfig["accessoryView"] = UIImageView(image: UIImage(named: "Icon_AccessoryView", from: BasicFrameworkSet.self)?.template)
        cellConfig["accessoryView.tintColor"] = UIColor.init(hex: 0xBFBFBF)
        if #available(iOS 13.4, *) {
            cellConfig["datePicker.preferredDatePickerStyle"] = UIDatePickerStyle.wheels.rawValue
        }
    }

    func typeSelectorCellConfig(title: String, noValueDisplayText: String? = nil) {
        self.title = title
        self.noValueDisplayText = noValueDisplayText
        cellConfig["textLabel.textColor"] = FormConfig.Color.text
        cellConfig["detailTextLabel.textColor"] = FormConfig.Color.detailText
        cellConfig["textLabel.font"] = FormConfig.Font.text
        cellConfig["detailTextLabel.font"] = FormConfig.Font.detailText
        cellConfig["backgroundColor"] = FormConfig.Color.background
        cellConfig["detailTextLabel.textAlignment"] = NSTextAlignment.right.rawValue
        cellConfig["selectionStyle"] = UITableViewCell.SelectionStyle.none.rawValue
        // swiftlint:disable:next line_length
        cellConfig["accessoryView"] = UIImageView(image: UIImage(named: "Icon_AccessoryView", from: BasicFrameworkSet.self)?.template)
        cellConfig["accessoryView.tintColor"] = UIColor.init(hex: 0xBFBFBF)
    }
}
*/
