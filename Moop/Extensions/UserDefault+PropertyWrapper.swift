//
//  UserDefault+PropertyWrapper.swift
//  Moop
//
//  Created by kor45cw on 2019/11/11.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: UserDefaultsKey
    let defaultValue: T

    init(_ key: UserDefaultsKey, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

@propertyWrapper
struct UserDefaultCodable<T: Codable> {
    let key: UserDefaultsKey
    let defaultValue: T
    
    init(_ key: UserDefaultsKey, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(T.self, forKey: key) ?? defaultValue
        }
        set {
            UserDefaults.standard.setObject(newValue, forKey: key)
        }
    }
}
