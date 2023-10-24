//
//  ProfileEditingViewModelProtocol.swift
//  Comparee
//
//  Created by Андрей Логвинов on 10/19/23.
//

import Combine
import Foundation

protocol ProfileEditingViewModelInput: BaseViewModuleInputProtocol {}

/// Protocol defining the input requirements for the RatingViewModel.
protocol ProfileEditingViewModelOutput {
    /// A subject that holds the current snapshot of the rating view model.
    var dataSourceSnapshot: CurrentValueSubject<ProfileEditingViewModel.Snapshot, Never> { get }
    
    /// An array of sections within the rating view model.
    var sections: [ProfileEditingViewModel.Section] { get }
    
    func cellWasTapped(type: ProfileSettingsViewItem)
}

/// Protocol defining the overall requirements for the RatingViewModel.
protocol ProfileEditingViewModelProtocol {
    /// The input requirements for the RatingViewModel.
    var input: ProfileEditingViewModelInput { get }
    
    /// The output requirements for the RatingViewModel.
    var output: ProfileEditingViewModelOutput { get }
}

extension ProfileEditingViewModelProtocol where Self: ProfileEditingViewModelInput & ProfileEditingViewModelOutput {
    var input: ProfileEditingViewModelInput { self }
    var output: ProfileEditingViewModelOutput { self }
}
