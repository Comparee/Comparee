//
//  StorageManagerProtocol.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/7/23.
//

import Foundation


protocol StorageManagerProtocol {

}

private struct StorageManagerKey: InjectionKey {
    // The initial value for the injection key is an instance of AuthManager.
    static var currentValue: StorageManagerProtocol = StorageManager()
}

/// Extension to manage the injection of AuthManager.
extension InjectedValues {
    var storageManager: StorageManagerProtocol {
        get { Self[StorageManagerKey.self] }
        set { Self[StorageManagerKey.self] = newValue }
    }
}
