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
    @Injected(\.userDefaultsManager) var userDefaultsManager: UserDefaultsManagerProtocol
    
    // MARK: - Private UI properties
    private lazy var backgroundImageView = BackgroundImageView()
    
    private lazy var appleSignInButton: UIButton = {
        let button = UIButton()
        button.layer.backgroundColor = UIColor.white.cgColor
        button.layer.cornerRadius = 25.5
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.tintColor = ColorManager.Login.appleButtonTint
        button.setTitle("Continue with Apple", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.customFont(.sfProTextMedium, size: 16)
        let appleImage = IconManager.Login.appleLogo
        let resizedAppleImage = appleImage?.resize(to: CGSize(width: 28, height: 28))
        button.setImage(resizedAppleImage, for: .normal)
        button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: -10, bottom: 0, trailing: 10)
        return button
    }()
    
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(.cormorantSemiBoldItalic, size: 44)
        label.textColor = .white
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.lineBreakMode = .byWordWrapping
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.83
        paragraphStyle.alignment = .center
        
        label.attributedText = NSMutableAttributedString(
            string: "Welcome to\nComparee",
            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )
        return label
    }()
    
    private lazy var policyLabel = PolicyLabel()
    
    private lazy var firstRingImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = IconManager.Login.firstRing
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var secondRingImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = IconManager.Login.secondRing
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var firstPreviewImageVIew: UIImageView = {
        let imageView = UIImageView()
        imageView.image = IconManager.Login.firstPreview
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var secondPreviewImageVIew: UIImageView = {
        let imageView = UIImageView()
        imageView.image = IconManager.Login.secondPreview
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Private Combine Properties
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Initialization
    init(viewModel: LoginViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAndimation()
    }
}

// MARK: - Private methods
private extension LoginViewController {
    func setupAndimation() {
        guard userDefaultsManager.isUserAuthorised else { return }
        
        var initialFrame = self.view.frame
        initialFrame.origin.x = self.view.frame.size.width
        self.view.frame = initialFrame
        
        UIView.animate(withDuration: 0.3) {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        }
    }
    
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

// MARK: - Bind views
private extension LoginViewController {
    func bindButton() {
        appleSignInButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self else { return }
                
                self.viewModel.isButtonTapped()
            }
            .store(in: &cancellables)
    }
}
