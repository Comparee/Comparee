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
    var textField: RegistrationTextField
    
    private lazy var errorLabel: ErrorLabel = {
        let errorLabel = ErrorLabel()
        errorLabel.setContentHuggingPriority(.required, for: .vertical)
        errorLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        return errorLabel
    }()
    
    // MARK: - Initialization
    init(type: RegInput) {
        definitionLabel = DefinitionLabel(type: type)
        textField = RegistrationTextField(type: type)
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
        addSubview(textField)
        addSubview(errorLabel)
    }
    
    func configureConstraints() {
        let spacing: CGFloat = 4.0
        
        definitionLabel.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            definitionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            definitionLabel.topAnchor.constraint(equalTo: topAnchor),
            definitionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.topAnchor.constraint(equalTo: definitionLabel.bottomAnchor, constant: spacing),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.heightAnchor.constraint(equalToConstant: 51),
            
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: spacing),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            errorLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            errorLabel.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
}

// MARK: - Error handling
extension RegisterInputView {
    func textFieldIsEmty(isEmpty: Bool) {
        if isEmpty {
            errorLabel.text = "! This field cannot be empty"
        } else {
            errorLabel.text = ""
        }
    }
}
