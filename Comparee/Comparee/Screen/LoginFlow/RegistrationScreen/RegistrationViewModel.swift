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
    
    // MARK: - Injection
    @Injected(\.firebaseManager) private var firebaseManager: FirebaseManagerProtocol
    @Injected(\.userDefaultsManager) private var userDefaultsManager: UserDefaultsManagerProtocol
    
    // MARK: - Public Properties
    @Published var name: String = ""
    @Published var age: String = ""
    @Published var instagram: String = ""
    var testReg: [FieldsTypesModel] = RegInput.allCases
        .filter { $0 != .instagram }
        .map { FieldsTypesModel(fieldsTypes: $0) }
    
    // MARK: - Private Properties
    private weak var router: LoginFlowCoordinatorOutput?
    private var authDataResultModel: AuthDataResultModel
    private var cancellables: Set<AnyCancellable> = []
    
    private var isAllFieldsCorrect: Bool {
        testReg.first(where: { $0.isTextEmpty }) == nil
    }
    
    // MARK: - initialization
    init(router: LoginFlowCoordinatorOutput, authDataResultModel: AuthDataResultModel) {
        self.router = router
        self.authDataResultModel = authDataResultModel
    }
}

// MARK: - Public methods
extension RegistrationViewModel {
    func changeRegInput(type: RegInput, text: String?) {
        guard let index = testReg.firstIndex(where: { $0.fieldsTypes == type }), let text else { return }
        
        testReg[index].changeTextState(needChange: text.isEmpty)
    }
    
    func logInButtonPressed() {
        Task { [weak self] in
            guard let self else { return }
            
            let isNameUnique = await self.isNameUnique( self.name)
            if isAllFieldsCorrect && isNameUnique{
                self.logIn()
            }
        }
    }
    
    func isNameUnique(_ name: String) async -> Bool {
        await self.firebaseManager.checkForNameExisting(name: name)
    }
}

// MARK: - Private methods
private extension RegistrationViewModel {
    func logIn() {
        Task {
            let newUser = DBUser(
                userId: authDataResultModel.uid,
                email: authDataResultModel.email,
                name: self.name,
                age: self.age,
                instagram: self.instagram,
                comparisons: nil
            )
            
            try firebaseManager.createNewUser(newUser)
            userDefaultsManager.userID = newUser.userId
            await MainActor.run {
                router?.trigger(.showPhotoUploadScreen)
            }
        }
    }
}
