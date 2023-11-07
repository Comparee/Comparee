//
//  InformationEditingViewModelProtocol.swift
//  Comparee
//
//  Created by Андрей Логвинов on 10/19/23.
//

import Combine
import UIKit

/// Protocol for the input interface of the InformationEditingViewModel.
protocol InformationEditingViewModelInput: BaseViewModuleInputProtocol {
    /// User's name.
    var name: String { get set }
    
    /// User's age.
    var age: String { get set }
    
    /// User's Instagram username.
    var instagram: String { get set }
    
    /// Function to handle changes in registration input fields.
    ///
    /// - Parameters:
    ///   - type: The type of registration input field being changed.
    ///   - text: The updated text for the input field.
    func changeRegInput(type: RegInput, text: String?)
    
    /// Function to handle the button press event for the log-in button.
    func saveButtonPressed()
    
    /// Get the current user information asynchronously.
    ///
    /// - Returns: An asynchronous result containing the current user information or an error.
    func getCurrentUser() async throws -> DBUser

    ///  Function for checking name
    /// - Parameter name: new user name
    /// - Returns: is it unique
    func isNameUnique(_ name: String) async -> Bool
}

/// Protocol for the output interface of the InformationEditingViewModel.
protocol InformationEditingViewModelOutput {
    /// An array containing test registration fields.
    var testReg: [FieldsTypesModel] { get }
}

/// Protocol that combines both input and output interfaces for InformationEditingViewModel.
protocol InformationEditingViewModelProtocol {
    var input: InformationEditingViewModelInput { get }
    var output: InformationEditingViewModelOutput { get }
}

/// Default implementation for the InformationEditingViewModel.
extension InformationEditingViewModelProtocol where Self: InformationEditingViewModelInput & InformationEditingViewModelOutput {
    var input: InformationEditingViewModelInput { self }
    var output: InformationEditingViewModelOutput { self }
}
