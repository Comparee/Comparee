//
//  AuthManagerProtocol.swift
//  Comparee
//
//  Created by Андрей Логвинов on 8/31/23.
//

import AuthenticationServices
import FirebaseAuth
import Foundation

protocol AuthManagerProtocol {
    func startSignInWithAppleFlow(completion: @escaping (Result<AuthDataResult?, Error>) -> Void)
}

private struct AuthManagerKey: InjectionKey {
    // The initial value for the injection key is an instance of AuthManager.
    static var currentValue: AuthManagerProtocol = AuthManager()
}

/// Extension to manage the injection of AuthManager.
extension InjectedValues {
    var authManager: AuthManagerProtocol {
        get { Self[AuthManagerKey.self] }
        set { Self[AuthManagerKey.self] = newValue }
    }
}
