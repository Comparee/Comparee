//
//  UserDefaultsManagerProtocol.swift
//  Comparee
//
//  Created by Andrey Logvinov.
//

import Foundation

protocol UserDefaultsManagerProtocol {
    var isUserAuthorised: Bool { get set }
    var userID: String? { get set }
}

private struct UserDefaultsManagerKey: InjectionKey {
    static var currentValue: UserDefaultsManagerProtocol = UserDefaultsManager()
}

extension InjectedValues {
    var userDefaultsManager: UserDefaultsManagerProtocol {
        get { Self[UserDefaultsManagerKey.self] }
        set { Self[UserDefaultsManagerKey.self] = newValue }
    }
}
