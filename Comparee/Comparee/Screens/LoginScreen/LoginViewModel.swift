//
//  LoginViewModel.swift
//  Comparee
//
//  Created by Андрей Логвинов on 8/30/23.
//

import CryptoKit
import FirebaseAuth
import Foundation

final class LoginViewModel {
    
    // MARK: - Managers
    @Injected(\.authManager)
    private var authManager: AuthManagerProtocol
    
    // MARK: - Private propersties
    private weak var router: LoginFlowCoordinatorOutput?
    
    // MARK: - Initialization
    init(router: LoginFlowCoordinatorOutput) {
        self.router = router
    }
}

// MARK: - implementing LoginViewModelProtocol
extension LoginViewModel: LoginViewModelProtocol {
    func isButtonTapped() {
        Task {
            do {
                let result = try await authManager.startSignInWithAppleFlow()
                await self.router?.trigger(.showRegistrationScreen(authModel: result))
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
