//
//  TopUserView.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/28/23.
//

import SkeletonView
import UIKit
import SDWebImage

final class TopUserView: UIView {
    // MARK: - Injection
    @Injected(\.storageManager) var storageManager: StorageManagerProtocol
    
    // MARK: - Private properties
    lazy var userPhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.image = IconManager.CompareScreen.background
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.isSkeletonable = true
        return imageView
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(.sfProTextRegular, size: 16)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameStack: UIStackView = {
        NSLayoutConstraint.activate([
            userNameLabel.widthAnchor.constraint(equalToConstant: 88),
            userNameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        let stackView = UIStackView(arrangedSubviews: [userNameLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layer.cornerRadius = 4
        stackView.clipsToBounds = true
        stackView.isSkeletonable = true
        return stackView
    }()
    
    private lazy var instagramImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = IconManager.CompareScreen.instagram
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var userRatingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(.sfProTextSemibold, size: 24)
        label.textColor = .white
        label.text = "0000"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        NSLayoutConstraint.activate([
            instagramImage.widthAnchor.constraint(equalToConstant: 32),
            instagramImage.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        let stackView = UIStackView(arrangedSubviews: [instagramImage, userRatingLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layer.cornerRadius = 4
        stackView.clipsToBounds = true
        stackView.isSkeletonable = true
        return stackView
    }()
    
    private var instagramLink: String?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setConstraints()
        bindViews()
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        userPhoto.layer.cornerRadius = userPhoto.bounds.height / 2
        userPhoto.layer.borderWidth = 2.0
        userPhoto.layer.borderColor = UIColor.white.cgColor
    }
}

// MARK: - Public methods
extension TopUserView {
    func configure(_ userItem: UsersViewItem) {
        instagramLink = userItem.instagram
        userNameLabel.text = userItem.name
        userRatingLabel.text = String(userItem.rating)
        userNameLabel.textColor = .white
        userRatingLabel.textColor = .white
        getImage(with: userItem.userId)
        guard let instagram = userItem.instagram else { return }
        
        instagramImage.isHidden = instagram.isEmpty
    }
    
    func showSkeleton() {
        userPhoto.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient(baseColor: UIColor.clouds))
        nameStack.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient(baseColor: UIColor.clouds))
        horizontalStackView.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient(baseColor: UIColor.clouds))
    }
}

// MARK: - Private methods
private extension TopUserView {
    func setupViews() {
        addSubview(userPhoto)
        addSubview(nameStack)
        addSubview(horizontalStackView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            userPhoto.topAnchor.constraint(equalTo: self.topAnchor),
            userPhoto.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            userPhoto.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            userPhoto.bottomAnchor.constraint(equalTo: userNameLabel.topAnchor, constant: -10),
            
            nameStack.heightAnchor.constraint(equalToConstant: 20),
            nameStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            nameStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            nameStack.bottomAnchor.constraint(equalTo: horizontalStackView.topAnchor, constant: -4),
            
            horizontalStackView.heightAnchor.constraint(equalToConstant: 32),
            horizontalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            horizontalStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    func bindViews() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(instagramWasTapped))
        instagramImage.addGestureRecognizer(tapGesture)
        instagramImage.isUserInteractionEnabled = true
    }
    
    @MainActor
    func dismissSkeleton() {
        userPhoto.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.1))
        userPhoto.stopSkeletonAnimation()
        nameStack.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
        nameStack.stopSkeletonAnimation()
        horizontalStackView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
        horizontalStackView.stopSkeletonAnimation()
    }
    
    func getImage(with userId: String) {
        Task { [weak self] in
            guard let self else { return }
            
            let url = try await self.storageManager.getUrlForImage(path: userId)
            self.userPhoto.sd_setImage(with: url)
            self.setCornerRadius()
            self.dismissSkeleton()
        }
    }
    
    @MainActor
    func setCornerRadius() {
        userPhoto.layer.cornerRadius = userPhoto.bounds.width / 2
    }
    
    @objc func instagramWasTapped() {
        let originalLink = "https://www.instagram.com/"
        if let instagramLink,
           let url = URL(string: originalLink + instagramLink) {
            UIApplication.shared.open(url)
        }
    }
}
