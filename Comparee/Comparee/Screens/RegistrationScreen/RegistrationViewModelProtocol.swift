//
//  RegistrationViewModelProtocol.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/1/23.
//

import Combine
import UIKit

protocol RegistrationFlowViewModelInput: BaseViewModuleInputProtocol {
    var name: String { get set }
    var age: String { get set }
    var instagram: String { get set }
    
    func logInButtonPressed()
}

protocol RegistrationFlowViewModelOutput {
    var registrationResult: PassthroughSubject<Result<Void, Error>, Never> { get }
}

protocol RegistrationFlowViewModelProtocol {
    var input: RegistrationFlowViewModelInput { get }
    var output: RegistrationFlowViewModelOutput { get }
}

extension RegistrationFlowViewModelProtocol where Self: RegistrationFlowViewModelInput & RegistrationFlowViewModelOutput {
    var input: RegistrationFlowViewModelInput { self }
    var output: RegistrationFlowViewModelOutput { self }
}
