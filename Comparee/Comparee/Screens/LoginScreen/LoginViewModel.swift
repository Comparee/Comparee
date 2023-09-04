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
        authManager.startSignInWithAppleFlow { [weak self] result in
            switch result {
            case .success(_):
                self?.router?.trigger(.showRegistrationScreen)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
