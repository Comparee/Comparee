//
//  FirebaseManagerProtocol.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/1/23.
//

import Foundation

protocol FirebaseManagerProtocol {
    func createNewUser(user: DBUser) async throws
}

private struct FirebaseManagerKey: InjectionKey {
    // The initial value for the injection key is an instance of AuthManager.
    static var currentValue: FirebaseManagerProtocol = FirebaseManager()
}

/// Extension to manage the injection of AuthManager.
extension InjectedValues {
    var firebaseManager: FirebaseManagerProtocol {
        get { Self[FirebaseManagerKey.self] }
        set { Self[FirebaseManagerKey.self] = newValue }
    }
}
