//
//  TopUserView.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/28/23.
//

import UIKit
import SkeletonView

final class TopUserView: UIView {
    var storageManager = StorageManager()
    // MARK: - Private properties
    lazy var userPhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.image = IconManager.PhotoUpload.preview
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "----------"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.text = "----"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var horizontalStackView: UIStackView = {
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
        return stackView
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeViewSkeletonable()
        setupViews()
        setConstraints()
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        userPhoto.layer.cornerRadius = userPhoto.bounds.width / 2
        userPhoto.layer.borderWidth = 2.0
        userPhoto.layer.borderColor = UIColor.white.cgColor
    }
    
    func configure(_ userItem: UsersViewItem) {
        userNameLabel.text = userItem.name
        instagramImage.isHidden = !userItem.isInstagramEnabled
        userRatingLabel.text = String(userItem.rating)
        Task {[weak self] in
            guard let self else { return }
            
            let url = try await self.storageManager.getUrlForImage(path: userItem.userId)
            self.userPhoto.image = try await UIImage.downloadImage(from: url)
            await dismissSkeleton()
        }
    }
    
    @MainActor
    func dismissSkeleton() {
        userPhoto.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
        userPhoto.stopSkeletonAnimation()
        userNameLabel.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
        userNameLabel.stopSkeletonAnimation()
        horizontalStackView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
        horizontalStackView.stopSkeletonAnimation()
        userPhoto.layer.cornerRadius = userPhoto.bounds.width / 2
    }
    
}

// MARK: - Private methods
private extension TopUserView {
    func setupViews() {
        addSubview(userPhoto)
        addSubview(userNameLabel)
        addSubview(horizontalStackView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            userPhoto.topAnchor.constraint(equalTo: self.topAnchor),
            userPhoto.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            userPhoto.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            userPhoto.bottomAnchor.constraint(equalTo: userNameLabel.topAnchor, constant: -10),
            
            userNameLabel.heightAnchor.constraint(equalToConstant: 20),
            userNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            userNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            userNameLabel.bottomAnchor.constraint(equalTo: horizontalStackView.topAnchor, constant: -4),
            
            horizontalStackView.heightAnchor.constraint(equalToConstant: 32),
            horizontalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            horizontalStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    func makeViewSkeletonable() {
        userPhoto.isSkeletonable = true
        userNameLabel.isSkeletonable = true
        horizontalStackView.isSkeletonable = true
        
        userPhoto.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient(baseColor: UIColor.clouds))
        userNameLabel.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient(baseColor: UIColor.clouds))
        horizontalStackView.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient(baseColor: UIColor.clouds))
    }
}
