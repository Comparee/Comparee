//
//  AuthManagerProtocol.swift
//  Comparee
//
//  Created by Андрей Логвинов on 8/31/23.
//

import FirebaseAuth
import Foundation

/// Protocol for managing user authentication using various methods.
protocol AuthManagerProtocol {
    
    /// Starts the Sign In with Apple authentication flow asynchronously.
    ///
    /// - Returns: An asynchronous result containing `AuthDataResult` upon successful sign-in or an error upon failure.
    func startSignInWithAppleFlow() async throws -> AuthDataResultModel
    
    /// Signs the user out of the application.
    ///
    /// - Returns: An asynchronous result indicating successful sign-out or an error if sign-out fails.
    func signOut() async throws
    
    /// This function is responsible for deleting the account of the currently authenticated user. It will perform the necessary steps to remove the user's data and credentials.
    ///
    /// - Throws: An error if the deletion process fails. Check the error description for details.
    /// - Note: Make sure the user is signed in before calling this function. Use appropriate authentication methods before initiating the delete process.
    func delete() async throws
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
