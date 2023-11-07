//
//  RegistrationViewModelProtocol.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/1/23.
//

import Combine
import UIKit

/// Protocol for the input interface of the Registration Flow View Model.
protocol RegistrationFlowViewModelInput: BaseViewModuleInputProtocol {
    var name: String { get set }
    var age: String { get set }
    var instagram: String { get set }
    
    /// Function to handle changes in registration input fields.
    ///
    /// - Parameters:
    ///   - type: The type of registration input field being changed.
    ///   - text: The updated text for the input field.
    func changeRegInput(type: RegInput, text: String?)
    
    /// Function to handle the button press event for the log-in button.
    func logInButtonPressed()
    
    ///  Function for checking name
    /// - Parameter name: new user name
    /// - Returns: is it unique
    func isNameUnique(_ name: String) async -> Bool
}

/// Protocol for the output interface of the Registration Flow View Model.
protocol RegistrationFlowViewModelOutput {
    /// An array containing test registration fields.
    var testReg: [FieldsTypesModel] { get }
}

/// Protocol that combines both input and output interfaces for the Registration Flow View Model.
protocol RegistrationFlowViewModelProtocol {
    var input: RegistrationFlowViewModelInput { get }
    var output: RegistrationFlowViewModelOutput { get }
}

/// Default implementation for the Registration Flow View Model protocol.
extension RegistrationFlowViewModelProtocol where Self: RegistrationFlowViewModelInput & RegistrationFlowViewModelOutput {
    var input: RegistrationFlowViewModelInput { self }
    var output: RegistrationFlowViewModelOutput { self }
}
