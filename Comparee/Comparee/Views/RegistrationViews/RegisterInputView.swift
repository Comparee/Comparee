//
//  RegInputView.swift
//  Comparee
//
//  Created by Андрей Логвинов on 8/30/23.
//

import UIKit

final class RegisterInputView: UIView {
    
    // MARK: - Properties
    private var definitionLabel: DefinitionLabel
    var nicknameTextField: NicknameTextField
    
    private let errorLabel: ErrorLabel = {
        let label = ErrorLabel()
        return label
    }()
    
    // MARK: - Initialization
    init(type: RegInput) {
        definitionLabel = DefinitionLabel(type: type)
        nicknameTextField = NicknameTextField(type: type)
        
        super.init(frame: .zero)
        configureSubviews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configuration
private extension RegisterInputView {
    func configureSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(definitionLabel)
        addSubview(nicknameTextField)
        addSubview(errorLabel)
    }
    
    func configureConstraints() {
        let spacing: CGFloat = 4.0
        
        definitionLabel.translatesAutoresizingMaskIntoConstraints = false
        nicknameTextField.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            definitionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            definitionLabel.topAnchor.constraint(equalTo: topAnchor),
            definitionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            nicknameTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            nicknameTextField.topAnchor.constraint(equalTo: definitionLabel.bottomAnchor, constant: spacing),
            nicknameTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
            nicknameTextField.heightAnchor.constraint(equalToConstant: 51),
            
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorLabel.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor, constant: spacing),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            errorLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
