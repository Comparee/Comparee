//
//  CurrentUserView.swift
//  Comparee
//
//  Created by Андрей Логвинов on 10/5/23.
//

import SkeletonView
import UIKit

final class CurrentUserView: UIView {
    // Injection
    @Injected(\.userDefaultsManager) private var userDefaultsManager: UserDefaultsManagerProtocol
    @Injected(\.storageManager) private var storageManager: StorageManagerProtocol
    
    private lazy var placeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = IconManager.CompareScreen.background
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 24
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var instagramImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = IconManager.CompareScreen.instagram
        imageView.layer.backgroundColor = UIColor.white.cgColor
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var horizontalStackView: UIStackView = {
        NSLayoutConstraint.activate([
            instagramImage.widthAnchor.constraint(equalToConstant: 32),
            instagramImage.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        let stackView = UIStackView(arrangedSubviews: [instagramImage])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layer.cornerRadius = 4
        stackView.clipsToBounds = true
        return stackView
    }()
    
    lazy var ratingHorizontalStackView: UIStackView = {
        NSLayoutConstraint.activate([
            ratingLabel.widthAnchor.constraint(equalToConstant: 54),
            ratingLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        let stackView = UIStackView(arrangedSubviews: [ratingLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layer.cornerRadius = 4
        stackView.clipsToBounds = true
        return stackView
    }()
    
    lazy var nameHorizontalStackView: UIStackView = {
        NSLayoutConstraint.activate([
            nameLabel.widthAnchor.constraint(equalToConstant: 88),
            nameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel])
        stackView.backgroundColor = .white
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layer.cornerRadius = 4
        stackView.clipsToBounds = true
        return stackView
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.Rating.line
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initialise
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupViews()
        setConstraints()
        makeViewsSkeletonable()
        showSkeleton()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK: - Public methods
extension CurrentUserView {
    func configure(_ userItem: UsersViewItem, place: Int) {
        nameLabel.text = userItem.name
        instagramImage.isHidden = !userItem.isInstagramEnabled
        ratingLabel.text = String(userItem.rating)
        placeLabel.text = "\(place + 1)"
        getImage(with: userItem.userId)
        backgroundColor = (userItem.userId == userDefaultsManager.userID) ? ColorManager.Rating.currentUser : .none
    }
    
    @MainActor
    func dismissSkeleton() {
        userImageView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
        userImageView.stopSkeletonAnimation()
        horizontalStackView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
        horizontalStackView.stopSkeletonAnimation()
        ratingHorizontalStackView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
        ratingHorizontalStackView.stopSkeletonAnimation()
        nameHorizontalStackView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
        nameHorizontalStackView.stopSkeletonAnimation()
        
        nameHorizontalStackView.backgroundColor = .none
        horizontalStackView.backgroundColor = .none
        instagramImage.backgroundColor = .none
    }
}

// MARK: - Private methods for skeleton configuration
private extension CurrentUserView {
    func showSkeleton() {
        userImageView.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient(baseColor: UIColor.clouds))
        horizontalStackView.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient(baseColor: UIColor.clouds))
        ratingHorizontalStackView.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient(baseColor: UIColor.clouds))
        nameHorizontalStackView.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient(baseColor: UIColor.clouds))
    }
    
    func makeViewsSkeletonable() {
        userImageView.isSkeletonable = true
        instagramImage.isSkeletonable = true
        horizontalStackView.isSkeletonable = true
        ratingHorizontalStackView.isSkeletonable = true
        nameHorizontalStackView.isSkeletonable = true
    }
}

// MARK: - Private methods
private extension CurrentUserView {
    func setupViews() {
        self.addSubview(placeLabel)
        self.addSubview(userImageView)
        self.addSubview(nameHorizontalStackView)
        self.addSubview(lineView)
        self.addSubview(horizontalStackView)
        self.addSubview(ratingHorizontalStackView)
        
        userImageView.layer.cornerRadius = 24
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            placeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            placeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            userImageView.widthAnchor.constraint(equalToConstant: 48),
            userImageView.heightAnchor.constraint(equalToConstant: 48),
            userImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            userImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 63),
            
            nameHorizontalStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            nameHorizontalStackView.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 8),
            
            horizontalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            horizontalStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            ratingHorizontalStackView.trailingAnchor.constraint(equalTo: horizontalStackView.leadingAnchor, constant: -12),
            ratingHorizontalStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),

            lineView.heightAnchor.constraint(equalToConstant: 1),
            lineView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            lineView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func getImage(with userId: String) {
        Task {[weak self] in
            guard let self else { return }
            
            let url = try await self.storageManager.getUrlForImage(path: userId)
            self.userImageView.image = try await UIImage.downloadImage(from: url)
            dismissSkeleton()
        }
    }
}
