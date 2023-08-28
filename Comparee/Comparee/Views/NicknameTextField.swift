//
//  NicknameTextField.swift
//  Comparee
//
//  Created by Андрей Логвинов on 8/28/23.
//

import UIKit

class NicknameTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        frame = CGRect(x: 0, y: 0, width: 335, height: 51)
        backgroundColor = UIColor(red: 0.183, green: 0.176, blue: 0.176, alpha: 1)
        layer.cornerRadius = 25
        translatesAutoresizingMaskIntoConstraints = false
        
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: self.frame.height))
        leftViewMode = .always
        clearButtonMode = .always
        returnKeyType = .continue
        placeholder = "Your nickname"
        textColor = UIColor(red: 0.463, green: 0.463, blue: 0.463, alpha: 1)
        font = UIFont(name: "SFProText-Regular", size: 16)
        
    }
}
