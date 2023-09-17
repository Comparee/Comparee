//
//  ViewController.swift
//  Comparee
//
//  Created by Андрей Логвинов on 8/27/23.
//

import Combine
import UIKit

final class RegistrationViewController: BaseViewController {
    
    // MARK: - Private properties for UI configuration
    private lazy var backgroundImageView: UIImageView = BackgroundImageView()
    private lazy var nickNameField: RegisterInputView = RegisterInputView(type: .nickName)
    private lazy var ageField: RegisterInputView = RegisterInputView(type: .age)
    private lazy var instagramField: RegisterInputView = RegisterInputView(type: .instagram)
    private lazy var buttonView = RoundedWhiteView()
    
    // MARK: - Private properties
    private var viewModel: RegistrationFlowViewModelProtocol!
    private var cancellables: Set<AnyCancellable> = []
    
    // Keyboard observing
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
        bindViewModel()
    }
}

// MARK: - Private methods
private extension RegistrationViewController {
    // Binding views for viewModel
    func bindViewModel() {
        bindButtons()
        bindTextFields()
    }
    
    func setUpDelegates() {
        nickNameField.textField.delegate = self
        ageField.textField.delegate = self
        instagramField.textField.delegate = self
    }
    
    func setupViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(nickNameField)
        view.addSubview(ageField)
        view.addSubview(instagramField)
        view.addSubview(buttonView)
        
        let customTitleView = createCustomTitleView(contactName: "Sign Up")
        navigationItem.titleView = customTitleView
        
        setUpDelegates()
        setConstraints()
        createCustomNavigationBar()
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            nickNameField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            nickNameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nickNameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nickNameField.heightAnchor.constraint(equalToConstant: 92),
            
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

// MARK: - Keyboard configuration
private extension RegistrationViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    func subscribeToAppWillResignActiveStatus() {
        NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.dismissKeyboard()
            }
            .store(in: &cancellables)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Views binding
private extension RegistrationViewController {
    func bindTextFields() {
        nickNameField.textField.textPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.name, on: viewModel.input)
            .store(in: &cancellables)
        
        ageField.textField.textPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.age, on: viewModel.input)
            .store(in: &cancellables)
        
        instagramField.textField.textPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.instagram, on: viewModel.input)
            .store(in: &cancellables)
    }
    
    func bindButtons() {
        buttonView.authButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self else { return }
                view.endEditing(true)
                self.viewModel.input.logInButtonPressed()
                for item in viewModel.output.testReg {
                    switch item.fieldsTypes {
                    case .nickName:
                        nickNameField.textFieldIsEmty(isEmpty: item.isTextEmpty)
                    case .age:
                        ageField.textFieldIsEmty(isEmpty: item.isTextEmpty)
                    default:
                        break
                    }
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - UITextFieldDelegate
extension RegistrationViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case nickNameField.textField:
            viewModel.input.changeRegInput(type: .nickName, text: textField.text)
        case ageField.textField:
            viewModel.input.changeRegInput(type: .age, text: textField.text)
        case instagramField.textField:
            viewModel.input.changeRegInput(type: .instagram, text: textField.text)
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nickNameField.textField:
            ageField.textField.becomeFirstResponder()
        case ageField.textField:
            instagramField.textField.becomeFirstResponder()
        case instagramField.textField:
            self.viewModel.input.logInButtonPressed()
        default:
            break
        }
        return true
    }
    
    // MARK: - Limiting of textField input
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength: Int
        
        switch textField {
        case nickNameField.textField, instagramField.textField:
            maxLength = 30
        case ageField.textField:
            maxLength = 3
        default:
            maxLength = 0
        }
        
        guard let currentText = textField.text as NSString? else {
            return false
        }
        
        let newString = currentText.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }

}
