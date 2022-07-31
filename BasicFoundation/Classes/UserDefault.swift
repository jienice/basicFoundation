//
//  UserDefault.swift
//  Basic
//
//  Created by jie.xing on 2020/5/29.
//  Copyright © 2020 jie.xing. All rights reserved.
//

import Foundation

public protocol KeyNamespaceable {

    static func namespaced<T: RawRepresentable>(_ key: T) -> String
}

public extension KeyNamespaceable {

    static func namespaced<T: RawRepresentable>(_ key: T) -> String {
        return "\(Self.self).\(key.rawValue)"
    }
}

public protocol BoolDefaultSettable: KeyNamespaceable {

    associatedtype BoolKey: RawRepresentable
}

public extension BoolDefaultSettable where BoolKey.RawValue == String {

    static func set(_ value: Bool, forKey key: BoolKey) {
        let key = namespaced(key)
        UserDefaults.standard.set(value, forKey: key)
    }
    static func bool(forKey key: BoolKey) -> Bool {
        let key = namespaced(key)
        return UserDefaults.standard.bool(forKey: key)
    }
    static func remove(forkKey key: BoolKey) {
        let key = namespaced(key)
        UserDefaults.standard.removeObject(forKey: key)
    }
}

public protocol StringDefaultSettable: KeyNamespaceable {

    associatedtype StringKey: RawRepresentable
}

public extension StringDefaultSettable where StringKey.RawValue == String {

    static func set(_ value: String, forKey key: StringKey) {
        let key = namespaced(key)
        UserDefaults.standard.set(value, forKey: key)
    }

    static func string(forKey key: StringKey) -> String? {
        let key = namespaced(key)
        return UserDefaults.standard.string(forKey: key)
    }

    static func remove(forkKey key: StringKey) {
        let key = namespaced(key)
        UserDefaults.standard.removeObject(forKey: key)
    }
}

public protocol IntDefaultSettable: KeyNamespaceable {

    associatedtype IntKey: RawRepresentable
}

public extension IntDefaultSettable where IntKey.RawValue == String {

    static func set(_ value: Int, forKey key: IntKey) {
        let key = namespaced(key)
        UserDefaults.standard.set(value, forKey: key)
    }

    static func int(forKey key: IntKey) -> Int {
        let key = namespaced(key)
        return UserDefaults.standard.integer(forKey: key)
    }
    static func remove(forkKey key: IntKey) {
        let key = namespaced(key)
        UserDefaults.standard.removeObject(forKey: key)
    }
}
