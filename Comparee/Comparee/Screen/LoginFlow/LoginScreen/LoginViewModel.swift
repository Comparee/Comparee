//
//  LoginViewModel.swift
//  Comparee
//
//  Created by Андрей Логвинов on 8/30/23.
//

import FirebaseAuth
import Foundation

final class LoginViewModel {
    // MARK: - Managers
    @Injected(\.authManager) private var authManager: AuthManagerProtocol
    @Injected(\.firebaseManager) private var firebaseManager: FirebaseManagerProtocol
    @Injected(\.userDefaultsManager) private var userDefaultsManager: UserDefaultsManagerProtocol
    
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
        Task { [weak self] in
            guard let self else { return }
            
            do {
                let result = try await self.authManager.startSignInWithAppleFlow()
                await self.handleAuthenticationResult(result)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - Private methods
private extension LoginViewModel {
    func handleAuthenticationResult(_ result: AuthDataResultModel) async {
        do {
            _ = try await firebaseManager.getUser(userId: result.uid)
            await MainActor.run {
                userDefaultsManager.userID = result.uid
                userDefaultsManager.isUserAuthorised = true
                router?.finishFlow?()
            }
        } catch {
            await MainActor.run {
                router?.trigger(.showRegistrationScreen(authModel: result))
            }
        }
    }
}
