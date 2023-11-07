//
//  RatingViewModelProtocol.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/28/23.
//

import Combine
import Foundation

protocol RatingViewModelInput: BaseViewModuleInputProtocol {}
// MARK: - Output

/// Protocol defining the input requirements for the RatingViewModel.
protocol RatingViewModelOutput {
    /// A subject that holds the current snapshot of the rating view model.
    var dataSourceSnapshot: CurrentValueSubject<RatingViewModel.Snapshot, Never> { get }
    
    /// An array of sections within the rating view model.
    var sections: [RatingViewModel.Section] { get }
    
    /// The total count of users in the rating view model.
    var usersCount: Int { get }
    
    /// Indicates whether data is currently being loaded.
    var isLoading: Bool { get }
    
    /// Retrieves the current user asynchronously and returns a UsersViewItem if available.
    /// - Returns: A UsersViewItem representing the current user.
    func getCurrentUser() async -> UsersViewItem?
    
    /// Handles pagination for the rating view model.
    func pagination()
    
    /// Performs a hard reload of the data in the collection.
    func hardReload()

    /// Retrieves the maximum count of items asynchronously.
    /// - Returns: A boolean value indicating whether the collection has obtained all user data. `
    /// - Throws: An error if there's an issue with the asynchronous data retrieval process.
    func getMaxCount() async throws -> Bool
}

/// Protocol defining the overall requirements for the RatingViewModel.
protocol RatingViewModelProtocol {
    /// The input requirements for the RatingViewModel.
    var input: RatingViewModelInput { get }
    
    /// The output requirements for the RatingViewModel.
    var output: RatingViewModelOutput { get }
}

extension RatingViewModelProtocol where Self: RatingViewModelInput & RatingViewModelOutput {
    var input: RatingViewModelInput { self }
    var output: RatingViewModelOutput { self }
}
