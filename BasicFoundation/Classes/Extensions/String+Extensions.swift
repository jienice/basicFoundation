//
//  String+Extensions.swift
//  Basic
//
//  Created by jie.xing on 2022/2/24.
//  Copyright © 2021 jie.xing. All rights reserved.
//
import Foundation

public extension String {

    /// 转换为字典
    /// - Returns:
    func toDictionary() -> [String: Any]? {
        return toElement(type: [String: Any].self)
    }

    /// 转换为指定类型
    /// - Parameter type:
    /// - Returns:
    func toElement<E>(type: E.Type) -> E? {
        guard let data = data(using: .utf8) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: [])) as? E
    }
}
