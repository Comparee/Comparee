//
//  AuthManager.swift
//  Comparee
//
//  Created by Андрей Логвинов on 8/31/23.
//

import AuthenticationServices
import CryptoKit
import FirebaseAuth
import Foundation

final class AuthManager: NSObject {
    // MARK: - Injection
    @Injected(\.reachabilityManager) private var reachabilityManager: ReachabilityManagerProtocol
    
    // MARK: - Private properties
    private var currentNonce: String?
    private var completion: ((Result<AuthDataResultModel, Error>) -> Void)?
    
    // MARK: - Initialization
    override init() {
        super.init()
    }
}

// MARK: - Authentication Methods
extension AuthManager: AuthManagerProtocol {
    func signOut() async throws {
        try Auth.auth().signOut()
    }
    
    func startSignInWithAppleFlow() async throws -> AuthDataResultModel {
        try await withCheckedThrowingContinuation { [weak self] continuation in
            self?.startSignInWithAppleFlow { result in
                switch result {
                case .success(let signInAppleResult):
                    continuation.resume(returning: signInAppleResult)
                    return
                case .failure(let error):
                    continuation.resume(throwing: error)
                    return
                }
            }
        }
    }
    
    func delete() async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }
        
        try await user.delete()
    }
}

// MARK: - Private methods
private extension AuthManager {
    /// Start the Sign-In with Apple authentication flow.
    func startSignInWithAppleFlow(completion: @escaping (Result<AuthDataResultModel, Error>) -> Void) {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.requestedOperation = .operationLogin
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        self.completion = completion
    }
    
    /// Generate a random nonce string.
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    /// Calculate the SHA256 hash of a string.
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }
            .joined()
        
        return hashString
    }
}

// MARK: - ASAuthorizationControllerDelegate methods
extension AuthManager: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard
            let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
            let appleIDToken = appleIDCredential.identityToken,
            let idTokenString = String(data: appleIDToken, encoding: .utf8),
            let nonce = currentNonce
        else {
            completion?(.failure(URLError(.badServerResponse)))
            return
        }
        
        // Initialize a Firebase credential, including the user's full name.
        let credential = OAuthProvider.appleCredential(
            withIDToken: idTokenString,
            rawNonce: nonce,
            fullName: appleIDCredential.fullName
        )
        
        Auth.auth().signIn(with: credential) { [weak self] authResult, error in
            guard let self = self else { return }
            
            guard error == nil else {
                self.completion?(.failure(error!))
                return
            }
            
            self.completion?(.success(AuthDataResultModel(user: authResult?.user)))
        }
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding methods
extension AuthManager: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first
        else {
            // Fallback to a default window if there is no valid window scene.
            return UIWindow()
        }
        
        return window
    }
}
