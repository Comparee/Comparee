//
//  InformationEditingViewController.swift
//  Comparee
//
//  Created by Андрей Логвинов on 10/19/23.
//

import Combine
import UIKit

final class InformationEditingViewController: BaseViewController {
    
    // MARK: - Private properties for UI configuration
    private lazy var backgroundImageView: UIImageView = BackgroundImageView()
    private lazy var nickNameField: RegisterInputView = RegisterInputView(type: .nickName)
    private lazy var ageField: RegisterInputView = RegisterInputView(type: .age)
    private lazy var instagramField: RegisterInputView = RegisterInputView(type: .instagram)
    private lazy var button = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont.customFont(.sfProTextSemibold, size: 16)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 24
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var buttonBottomConstraint: NSLayoutConstraint = {
        let constraint = button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32) // Initial position
        constraint.isActive = true
        return constraint
    }()
    
    // MARK: - Private properties
    private var viewModel: InformationEditingViewModelProtocol!
    private var cancellables: Set<AnyCancellable> = []
    private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Initialization
    init(viewModel: InformationEditingViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupViews()
        bindViewModel()
        getCurrentUser()
    }
}

// MARK: - Private methods
private extension InformationEditingViewController {
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
        view.addSubview(button)
        view.addSubview(dimmingView)
        
        let customTitleView = createCustomTitleView(contactName: " Edit Info ")
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
            
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -46),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.heightAnchor.constraint(equalToConstant: 48),
            
            dimmingView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimmingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmingView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @MainActor
    func showLoader() {
        // Create and configure an activity indicator
        dimmingView.isHidden = false
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        // Center the activity indicator in the view
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Start animating the activity indicator
        activityIndicator.startAnimating()
        
        // Disable user interaction during loading
        view.isUserInteractionEnabled = false
    }
    
    @MainActor
    func stopLoader() {
        // Stop and remove the activity indicator
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        activityIndicator = nil
        
        // Re-enable user interaction
        view.isUserInteractionEnabled = true
        dimmingView.isHidden = true
    }
    
    func getCurrentUser() {
        Task { [weak self] in
            guard let self else { return }
            self.showLoader()
            let currentUser = try await self.viewModel.input.getCurrentUser()
            self.nickNameField.textField.text = currentUser.name
            self.ageField.textField.text = currentUser.age
            self.instagramField.textField.text = currentUser.instagram
            
            self.viewModel.input.changeRegInput(type: .nickName, text: currentUser.name)
            self.viewModel.input.changeRegInput(type: .age, text: currentUser.age)
            self.viewModel.input.changeRegInput(type: .instagram, text: currentUser.instagram)
            self.stopLoader()
        }
    }
}

// MARK: - Keyboard configuration
private extension InformationEditingViewController {
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
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            let offset: CGFloat = -12
            buttonBottomConstraint.constant = -keyboardHeight + offset
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        buttonBottomConstraint.constant = -32
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - Views binding
private extension InformationEditingViewController {
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
        button.publisher(for: .touchUpInside)
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - UITextFieldDelegate
extension InformationEditingViewController: UITextFieldDelegate {
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
