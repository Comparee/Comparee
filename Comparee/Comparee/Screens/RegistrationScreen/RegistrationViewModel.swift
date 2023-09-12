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
    var testReg: [FieldsTypesModel] = RegInput.allCases.map { FieldsTypesModel(fieldsTypes: $0) }
    
    // MARK: - Injection
    @Injected(\.firebaseManager)
    private var firebaseManager: FirebaseManagerProtocol
    
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
    
    func changeRegInput(type: RegInput, text: String?) {
        guard let index = testReg.firstIndex(where: { $0.fieldsTypes == type }), let text else { return }
      
        testReg[index].changeTextState(needChange: text.isEmpty)
    }
    
    func logInButtonPressed() {
        if isAllFieldsCorrect {
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
