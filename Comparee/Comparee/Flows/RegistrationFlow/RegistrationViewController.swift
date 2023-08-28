//
//  ViewController.swift
//  Comparee
//
//  Created by Андрей Логвинов on 8/27/23.
//

import UIKit

final class RegistrationViewController: UIViewController {
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Background")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nicknameLabel = DefinitionLabel()
    private lazy var nicknameTextField = NicknameTextField()
    private lazy var errorLabel = ErrorLabel()
    
    private lazy var authButton = AuthButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
    }
    
    
}

extension RegistrationViewController {
    
    private func setupViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(nicknameLabel)
        view.addSubview(nicknameTextField)
        view.addSubview(errorLabel)
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
            nicknameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            nicknameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nicknameLabel.widthAnchor.constraint(equalToConstant: 90),
            nicknameLabel.heightAnchor.constraint(equalToConstant: 17)
        ])
        
        NSLayoutConstraint.activate([
            nicknameTextField.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 10),
            nicknameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nicknameTextField.widthAnchor.constraint(equalToConstant: 335),
            nicknameTextField.heightAnchor.constraint(equalToConstant: 51)
        ])
        
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor, constant: 10), // Place it below nicknameTextField
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorLabel.widthAnchor.constraint(equalToConstant: 220)
        ])
        
        NSLayoutConstraint.activate([
            authButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -66), // Place it below nicknameTextField
            authButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
           authButton.widthAnchor.constraint(equalToConstant: 64),
            authButton.heightAnchor.constraint(equalToConstant: 64)
        ])
    }

}


//MARK: - For seeing canvas

import SwiftUI

struct UIViewControllerPreview<ViewControllerType: UIViewController>: UIViewControllerRepresentable {
    let viewController: ViewControllerType
    
    init(_ builder: @escaping () -> ViewControllerType) {
        viewController = builder()
    }
    
    func makeUIViewController(context: Context) -> ViewControllerType {
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: ViewControllerType, context: Context) {
        // No need to update
    }
}

struct ViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            RegistrationViewController()
        }
    }
}
