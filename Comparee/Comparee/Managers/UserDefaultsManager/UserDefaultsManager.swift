//
//  UserDefaultsManager.swift
//  DEO Video
//
//  Created by Oleg Home on 02.11.2020.
//

import Foundation

public enum UserDefaultsKey: String {
    case isUserAuthorised
    case userInfo
}

final class UserDefaultsManager: UserDefaultsManagerProtocol {
    
    private let userDefaults = UserDefaults.standard
    @UserDefaultsValue(key: .isUserAuthorised, defaultValue: false) var isUserAuthorised: Bool
    @UserDefaultsOptionalValue(key: .userInfo) var userInfo: DBUser?
}

@propertyWrapper
struct UserDefaultsValue<Value> {
    
    let key: UserDefaultsKey
    let defaultValue: Value
    
    var wrappedValue: Value {
        get { UserDefaults.standard.value(forKey: key.rawValue) as? Value ?? defaultValue }
        set { UserDefaults.standard.setValue(newValue, forKey: key.rawValue) }
    }
    
}

@propertyWrapper
struct UserDefaultsOptionalValue<Value> {
    
    let key: UserDefaultsKey
    
    var wrappedValue: Value? {
        get { UserDefaults.standard.value(forKey: key.rawValue) as? Value }
        set { UserDefaults.standard.setValue(newValue, forKey: key.rawValue) }
    }
    
}
