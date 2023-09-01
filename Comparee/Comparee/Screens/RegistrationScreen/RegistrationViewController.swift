//
//  ViewController.swift
//  Comparee
//
//  Created by Андрей Логвинов on 8/27/23.
//

import UIKit

final class RegistrationViewController: UIViewController {
    
    private let backgroundImageView: UIImageView = BackgroundImageView()
    private lazy var navBar = CustomNavigationBar()
    private lazy var nickNameField: UIView = RegInputView(type: .nickName)
    private lazy var ageField: UIView = RegInputView(type: .age)
    private lazy var instField: UIView = RegInputView(type: .instagram)
    
    private lazy var authButton = AuthButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        
        self.navigationItem.titleView = navBar
        navBar.translatesAutoresizingMaskIntoConstraints = false
        //nicknameTextField.publisher(for: .)
        
    }
}

extension RegistrationViewController {
    
    private func setupViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(nickNameField)
        view.addSubview(ageField)
        view.addSubview(instField)
        view.addSubview(authButton)
        
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nickNameField.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            nickNameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nickNameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            ageField.topAnchor.constraint(equalTo: nickNameField.bottomAnchor, constant: 4),
            ageField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            ageField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            instField.topAnchor.constraint(equalTo: ageField.bottomAnchor, constant: 4),
            instField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            instField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            authButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -66),
            authButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            authButton.widthAnchor.constraint(equalToConstant: 64),
            authButton.heightAnchor.constraint(equalToConstant: 64)
        ])
    }
    
}
