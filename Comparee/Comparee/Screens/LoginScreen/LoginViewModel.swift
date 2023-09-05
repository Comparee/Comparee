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
    
    // MARK: - Dependencies
    @Injected(\.authManager)
    private var authManager: AuthManagerProtocol
    
    private weak var router: LoginFlowCoordinatorOutput?
    
    init(router: LoginFlowCoordinatorOutput) {
        self.router = router
    }
    
}

extension LoginViewModel: LoginViewModelProtocol {
    func isButtonTapped() {
        Task {
            do {
                let result = try await authManager.startSignInWithAppleFlow()
                switch result {
                case .some(_):
                    await self.router?.trigger(.showRegistrationScreen)
                default:
                    break
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
