//
//  UserDefaultsManager.swift
//  Comparee
//
//  Created by Andrey Logvinov
//

import Foundation

enum UserDefaultsKey: String {
    case isUserAuthorised
    case userID
}

final class UserDefaultsManager: UserDefaultsManagerProtocol {
    
    private let userDefaults = UserDefaults.standard
    @UserDefaultsValue(key: .isUserAuthorised, defaultValue: false) var isUserAuthorised: Bool
    @UserDefaultsValue(key: .userID, defaultValue: nil) var userID: String?
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
