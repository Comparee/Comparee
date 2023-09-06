//
//  AuthViewController.swift
//  Comparee
//
//  Created by Андрей Логвинов on 8/28/23.
//

import Combine
import UIKit

final class LoginViewController: UIViewController {
    // MARK: - ViewModel
    private let viewModel: LoginViewModelProtocol
    
    // Background image configuration
    private lazy var backgroundImageView = BackgroundImageView()
    
    // Private properties for UI
    private lazy var appleSignInButton: SignInButton = SignInButton()
    private lazy var welcomeLabel = WelcomeLabel()
    private lazy var policyLabel = PolicyLabel()
    private lazy var firstRingImage = FirstRingImage()
    private lazy var secondRingImage = SecondRingImage()
    private lazy var firstPreviewImageVIew = FirstPreviewImageVIew()
    private lazy var secondPreviewImageVIew = SecondPreviewImageVIew()
    
    // Private properties for Combine
    private var cancellables: Set<AnyCancellable> = []
    
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
        configureUI()
    }
}

// MARK: - Extension for views configurations
private extension LoginViewController {
    func configureUI() {
        setupViews()
        setConstraints()
        bindButton()
    }
    
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
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
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
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
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

// MARK: - Bind button
extension LoginViewController {
    func bindButton() {
        appleSignInButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.isButtonTapped()
                self.view.endEditing(true)
            }
            .store(in: &cancellables)
    }
    
}
