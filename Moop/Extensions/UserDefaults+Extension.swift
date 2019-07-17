//
//  UserDefaults+Extension.swift
//  AppStoreSearch
//
//  Created by Chang Woo Son on 2019/06/29.
//  Copyright © 2019 Chang Woo Son. All rights reserved.
//

import UIKit

enum UserDefaultsKey {
    case theater
    
    var keyString: String {
        switch self {
        case .theater:
            return "Theater"
        }
    }
}


extension UserDefaults {
    func set(_ value: Any?, forKey key: UserDefaultsKey) { set(value, forKey: key.keyString) }
    func set(_ value: [Any]?, forKey key: UserDefaultsKey) { set(value, forKey: key.keyString) }
    func set(_ value: Int, forKey key: UserDefaultsKey) { set(value, forKey: key.keyString) }
    func set(_ value: Float, forKey key: UserDefaultsKey) { set(value, forKey: key.keyString) }
    func set(_ value: Double, forKey key: UserDefaultsKey) { set(value, forKey: key.keyString) }
    func set(_ value: Bool, forKey key: UserDefaultsKey) { set(value, forKey: key.keyString) }
    func set(_ url: URL?, forKey key: UserDefaultsKey) { set(url, forKey: key.keyString) }
    func setObject<T: Encodable>(_ value: T, forKey key: UserDefaultsKey) {
        let data = try? JSONEncoder().encode(value)
        set(data, forKey: key.keyString)
    }
    
    func removeObject(forKey key: UserDefaultsKey) { removeObject(forKey: key.keyString) }
    
    func object(forKey key: UserDefaultsKey) -> Any? { return object(forKey: key.keyString) }
    func object<T: Decodable>(_ type: T.Type, forKey key: UserDefaultsKey) -> T? {
        if let data = data(forKey: key) {
            return try? JSONDecoder().decode(type, from: data)
        }
        return nil
    }
    func string(forKey key: UserDefaultsKey) -> String? { return string(forKey: key.keyString) }
    func array(forKey key: UserDefaultsKey) -> [Any]? { return array(forKey: key.keyString) }
    func dictionary(forKey key: UserDefaultsKey) -> [String : Any]? { return dictionary(forKey: key.keyString) }
    func data(forKey key: UserDefaultsKey) -> Data? { return data(forKey: key.keyString) }
    func stringArray(forKey key: UserDefaultsKey) -> [String]? { return stringArray(forKey: key.keyString) }
    func integer(forKey key: UserDefaultsKey) -> Int { return integer(forKey: key.keyString) }
    func float(forKey key: UserDefaultsKey) -> Float { return float(forKey: key.keyString) }
    func double(forKey key: UserDefaultsKey) -> Double { return double(forKey: key.keyString) }
    func bool(forKey key: UserDefaultsKey) -> Bool { return bool(forKey: key.keyString) }
    func url(forKey key: UserDefaultsKey) -> URL? { return url(forKey: key.keyString) }
}
