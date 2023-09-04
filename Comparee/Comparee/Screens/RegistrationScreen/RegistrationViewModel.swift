//
//  RegistrationViewModel.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/1/23.
//

import Combine
import UIKit

final class RegistrationViewModel: RegistrationFlowViewModelProtocol, RegistrationFlowViewModelInput, RegistrationFlowViewModelOutput {
    
    // MARK: - Public Properties
    @Published var mail: String = ""
    @Published var age: String = ""
    @Published var instagram: String = ""
    
    // MARK: - Private Properties
    private weak var router: LoginFlowCoordinatorOutput?
    
    private(set) var registrationResult =  PassthroughSubject<Result<Void, Error>, Never>()
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - initialization
    init(router: LoginFlowCoordinatorOutput) {
        self.router = router
    }

}

extension RegistrationViewModel {
    func logInButtonPressed() {
        if mail.isEmpty {
            print("Error field is empty")
        } else {
            logIn()
        }
    }
    
    func openMainFlow() {
        print("openMainFlow")
    }
}

private extension RegistrationViewModel {
    func logIn() {
        print("\(mail) + \(age) + \(instagram)")
    }
}
