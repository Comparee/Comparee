//
//  UserDefaultsManagerProtocol.swift
//  DEO Video
//
//  Created by Sergey Runovich on 06/09/2022.
//

import Foundation

protocol UserDefaultsManagerProtocol {
    var isUserAuthorised: Bool { get set }
    var userInfo: DBUser? { get set }
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
