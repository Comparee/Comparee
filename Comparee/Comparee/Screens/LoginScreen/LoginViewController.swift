//
//  AuthViewController.swift
//  Comparee
//
//  Created by Андрей Логвинов on 8/28/23.
//

import CryptoKit
import FirebaseAuth
import UIKit

final class LoginViewController: UIViewController {
    // MARK: - ViewModel
    private let viewModel: LoginViewModelProtocol
    
    // Background image configuration
    private lazy var backgroundImageView: UIImageView = BackgroundImageView()
    
    // Private properties for UI
    private lazy var appleSignInButton: SignInButton = SignInButton()
    private lazy var welcomeLabel: UILabel = WelcomeLabel()
    private lazy var policyLabel: UILabel = PolicyLabel()
    private lazy var firstRingImage: UIImageView = FirstRingImage()
    private lazy var secondRingImage: UIImageView = SecondRingImage()
    private lazy var firstPreviewImageVIew: UIImageView = FirstPreviewImageVIew()
    private lazy var secondPreviewImageVIew: UIImageView = SecondPreviewImageVIew()
    
    // MARK: - Initialization
    init(viewModel: LoginViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appleSignInButton.delegate = self
        setupViews()
        setConstraints()
    }
}

// MARK: - Extension for views configurations
private extension LoginViewController {
    func setupViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(appleSignInButton)
        view.addSubview(welcomeLabel)
        view.addSubview(policyLabel)
        view.addSubview(firstRingImage)
        view.addSubview(secondRingImage)
        view.addSubview(secondPreviewImageVIew)
        view.addSubview(firstPreviewImageVIew)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        if let window = UIApplication.shared.windows.first {
            if window.safeAreaInsets.bottom > 0 {
                NSLayoutConstraint.activate([
                    welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
                    policyLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12)
                ])
            } else {
                NSLayoutConstraint.activate([
                    welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 22),
                    policyLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12)
                ])
            }
        }
        
        NSLayoutConstraint.activate([
            appleSignInButton.bottomAnchor.constraint(equalTo: policyLabel.topAnchor, constant: -4),
            appleSignInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            appleSignInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            appleSignInButton.heightAnchor.constraint(equalToConstant: 51),
            
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            welcomeLabel.heightAnchor.constraint(equalToConstant: 90),
            
            policyLabel.leadingAnchor.constraint(equalTo: appleSignInButton.leadingAnchor),
            policyLabel.trailingAnchor.constraint(equalTo: appleSignInButton.trailingAnchor),
            
            firstRingImage.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 2),
            firstRingImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            secondRingImage.topAnchor.constraint(equalTo: firstPreviewImageVIew.topAnchor, constant: 178),
            secondRingImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            
            firstPreviewImageVIew.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 40),
            firstPreviewImageVIew.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            firstPreviewImageVIew.widthAnchor.constraint(equalToConstant: 263),
            firstPreviewImageVIew.heightAnchor.constraint(equalToConstant: 263),
            
            secondPreviewImageVIew.bottomAnchor.constraint(equalTo: firstPreviewImageVIew.bottomAnchor, constant: 86),
            secondPreviewImageVIew.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondPreviewImageVIew.widthAnchor.constraint(equalToConstant: 218),
            secondPreviewImageVIew.heightAnchor.constraint(equalToConstant: 218)
        ])
    }
}

// MARK: - SignInButtonDelegate
extension LoginViewController: SignInButtonDelegate {
    func signInButtonTapped() {
        viewModel.isButtonTapped()
    }
    
}
