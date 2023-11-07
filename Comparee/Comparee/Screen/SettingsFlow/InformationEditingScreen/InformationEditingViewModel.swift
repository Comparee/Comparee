//
//  InformationEditingViewModel.swift
//  Comparee
//
//  Created by Андрей Логвинов on 10/19/23.
//

import Combine
import Foundation

final class InformationEditingViewModel: InformationEditingViewModelProtocol, InformationEditingViewModelInput, InformationEditingViewModelOutput {
    
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
    private weak var router: ProfileScreenFlowCoordinatorOutput?
    private var cancellables: Set<AnyCancellable> = []
    
    private var isAllFieldsCorrect: Bool {
        testReg.first(where: { $0.isTextEmpty }) == nil
    }
    
    // MARK: - initialization
    init(router: ProfileScreenFlowCoordinatorOutput) {
        self.router = router
    }
}

// MARK: - Public methods
extension InformationEditingViewModel {
    func getCurrentUser() async throws -> DBUser {
        let currentUserId = userDefaultsManager.userID
        let user = try await firebaseManager.getUser(userId: currentUserId ?? "")
        return user
    }
    
    func changeRegInput(type: RegInput, text: String?) {
        guard let index = testReg.firstIndex(where: { $0.fieldsTypes == type }), let text else { return }
        switch type {
        case .nickName:
             name = text
        case .age:
            age = text
        case .instagram:
            instagram = text
        }
        testReg[index].changeTextState(needChange: text.isEmpty)
    }
    
    func saveButtonPressed() {
        Task { [weak self] in
            guard let self else { return }
    
            let isNameUnique = await self.isNameUnique(self.name)
            if isAllFieldsCorrect && isNameUnique{
                self.saveNewInformation()
            }
        }
    }
    
    func isNameUnique(_ name: String) async -> Bool {
        await self.firebaseManager.checkForNameExisting(name: name)
    }
}

// MARK: - Private methods
private extension InformationEditingViewModel {
    func saveNewInformation() {
        Task { [weak self] in
            guard let self else { return }
            
            try await self.firebaseManager.updateUserInfo(
                with: self.userDefaultsManager.userID ?? "",
                name: self.name,
                age: self.age,
                instagram: self.instagram
            )
            await MainActor.run {
                self.router?.trigger(.base(.dismiss))
            }
        }
    }
}
