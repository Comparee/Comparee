//
//  NicknameTextField.swift
//  Comparee
//
//  Created by Андрей Логвинов on 8/28/23.
//

import UIKit

final class RegistrationTextField: UITextField {
    
    init(type: RegInput) {
        super.init(frame: .zero)

        configure(type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension RegistrationTextField {
    func configure(type: RegInput) {
        switch type {
        case .nickName:
            placeholder = "Your nickname"
            keyboardType = .asciiCapable
        case .age:
            placeholder = "Your age"
            keyboardType = .numberPad
        case .instagram:
            placeholder = "Your instagram"
            keyboardType = .asciiCapable
        }
        
        autocorrectionType = .no
        backgroundColor = ColorManager.Registration.backPlaceholderColor
        layer.cornerRadius = 25
        translatesAutoresizingMaskIntoConstraints = false
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: ColorManager.Registration.textPlaceholderColor
        ]
        let attributedPlaceholder = NSAttributedString(string: placeholder!, attributes: attributes)
        
        self.attributedPlaceholder = attributedPlaceholder
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: self.frame.height))
        leftViewMode = .always
        clearButtonMode = .never
        returnKeyType = .go
        textColor = UIColor.white
        font = UIFont.customFont(.sfProTextRegular, size: 16)
    }
}
