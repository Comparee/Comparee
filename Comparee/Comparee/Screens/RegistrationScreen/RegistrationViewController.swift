//
//  ViewController.swift
//  Comparee
//
//  Created by Андрей Логвинов on 8/27/23.
//

import Combine
import UIKit

final class RegistrationViewController: BaseViewController {
    
    //MARK: - Private properties for UI configuration
    private lazy var backgroundImageView: UIImageView = BackgroundImageView()
    private lazy var nickNameField: RegisterInputView = RegisterInputView(type: .nickName)
    private lazy var ageField: RegisterInputView = RegisterInputView(type: .age)
    private lazy var instagramField: RegisterInputView = RegisterInputView(type: .instagram)
    private lazy var buttonView = RoundedWhiteView()
    
    // MARK: - Private properties
    private var viewModel: RegistrationFlowViewModelProtocol!
    private var cancellables: Set<AnyCancellable> = []
    
    //keyboard observing
    override var isObservingKeyboard: Bool { true }
    
    // MARK: - Initialization
    init(viewModel: RegistrationFlowViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setupViews()
        setConstraints()
        
        createCustomNavigationBar()
        
        bindViewModel()
        subscribeToAppWillResignActiveStatus()
        
    }
    
    // MARK: - Override functions for keyboard configuration
    override func keyboardWillHideAction() {
        super.keyboardWillHideAction()
        self.view.frame.origin.y = 0
        self.navigationItem.titleView?.isHidden = false
    }
    
    override func keyboardWillShowAction() {
        super.keyboardWillShowAction()
        configureKeyboardAction()
    }
    
    // MARK: - Binding view for viewModel
    private func bindViewModel() {
        bindButtons()
        bindTextFields()
    }
    
}

//MARK: - UI Setup
extension RegistrationViewController {
    
    private func setupViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(nickNameField)
        view.addSubview(ageField)
        view.addSubview(instagramField)
        view.addSubview(buttonView)
        
        let customTitleView = createCustomTitleView(contactName: "Sign Up")
        navigationItem.titleView = customTitleView
    }
    
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            nickNameField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            nickNameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nickNameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            ageField.topAnchor.constraint(equalTo: nickNameField.bottomAnchor, constant: 4),
            ageField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            ageField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        
            instagramField.topAnchor.constraint(equalTo: ageField.bottomAnchor, constant: 4),
            instagramField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            instagramField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
       
            buttonView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -66),
            buttonView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            buttonView.widthAnchor.constraint(equalToConstant: 76),
            buttonView.heightAnchor.constraint(equalToConstant: 76)
        ])
        
    }
    
}

extension UIViewController {
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Keyboard configuration
private extension RegistrationViewController {
    func subscribeToAppWillResignActiveStatus() {
        NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.dismissKeyboard()
            }
            .store(in: &cancellables)
    }
    
    func configureKeyboardAction() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            if nickNameField.nicknameTextField.isFirstResponder
                || ageField.nicknameTextField.isFirstResponder
                || instagramField.nicknameTextField.isFirstResponder {
                UIView.animate(withDuration: 0.3) {
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let window = windowScene.windows.first {
                        if window.safeAreaInsets.bottom < 0 {
                            self.view.frame.origin.y = -100
                            self.navigationItem.titleView?.isHidden = true
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Views binding
private extension RegistrationViewController {
    func bindTextFields() {
        nickNameField.nicknameTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.name, on: viewModel.input)
            .store(in: &cancellables)
        
        ageField.nicknameTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.age, on: viewModel.input)
            .store(in: &cancellables)
        
        instagramField.nicknameTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.instagram, on: viewModel.input)
            .store(in: &cancellables)
        
    }
    
    func bindButtons() {
        buttonView.authButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self else { return }
                
                self.viewModel.input.logInButtonPressed()
                self.view.endEditing(true)
            }
            .store(in: &cancellables)
    }
}
