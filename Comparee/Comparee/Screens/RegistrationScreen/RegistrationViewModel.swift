//
//  RegistrationViewModel.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/1/23.
//

import Combine
import FirebaseAuth

import UIKit

final class RegistrationViewModel: RegistrationFlowViewModelProtocol, RegistrationFlowViewModelInput, RegistrationFlowViewModelOutput {
    
    // MARK: - Public Properties
    @Published var name: String = ""
    @Published var age: String = ""
    @Published var instagram: String = ""
    
    @Injected(\.firebaseManager)
    private var firebaseManager: FirebaseManagerProtocol
    
    // MARK: - Private Properties
    private weak var router: LoginFlowCoordinatorOutput?
    private var authDataResultModel: AuthDataResultModel
    
    private(set) var registrationResult = PassthroughSubject<Result<Void, Error>, Never>()
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - initialization
    init(router: LoginFlowCoordinatorOutput, authDataResultModel: AuthDataResultModel) {
        self.router = router
        self.authDataResultModel = authDataResultModel
    }

}

extension RegistrationViewModel {
    func logInButtonPressed() {
        if name.isEmpty {
        
        } else {
            logIn()
        }
    }
}

private extension RegistrationViewModel {
    func logIn() {
        Task {
            try await firebaseManager.createNewUser(user: DBUser(userId: authDataResultModel.uid, email: authDataResultModel.email, name: self.name, age: self.age, instagram: self.instagram))
            await router?.trigger(.showPhotoUploadScreen)
        }
    }
}
