//
//  UserRatingCellCollectionViewCell.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/29/23.
//

import SkeletonView
import UIKit
import SDWebImage

final class UserRatingCollectionViewCell: UICollectionViewCell {
    // Injection
    @Injected(\.userDefaultsManager) private var userDefaultsManager: UserDefaultsManagerProtocol
    @Injected(\.storageManager) private var storageManager: StorageManagerProtocol
    
    // MARK: - Private properties
    private lazy var placeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(.sfProTextRegular, size: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var userImageView: UIImageView = {
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
        label.font = UIFont.customFont(.satoshiMedium, size: 16)
        label.textColor = .white
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(.sfProTextSemibold, size: 20)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.preferredMaxLayoutWidth = 6
        return label
    }()
    
    private lazy var instagramImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = IconManager.CompareScreen.instagram
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Stacks for normal showing a skeletonView
    private lazy var instagramStackView: UIStackView = {
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
    
    private lazy var ratingHorizontalStackView: UIStackView = {
        NSLayoutConstraint.activate([
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
    
    private lazy var nameHorizontalStackView: UIStackView = {
        NSLayoutConstraint.activate([
            nameLabel.widthAnchor.constraint(equalToConstant: 88),
            nameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel])
        //stackView.backgroundColor = .white
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
    
    private lazy var placeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [placeLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var instagramLink: String?
    
    // MARK: - Initialise
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setConstraints()
        makeViewsSkeletonable()
        bindViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        placeLabel.text = nil
        nameLabel.text = nil
        ratingLabel.text = nil
        instagramImage.isHidden = true
        userImageView.image = UIImage.compareBackground
    }
}

// MARK: - Public methods
extension UserRatingCollectionViewCell {
    func configure(_ userItem: UsersViewItem, place: Int) {
        self.instagramLink = userItem.instagram
        nameLabel.text = userItem.name
        instagramImage.isHidden = userItem.instagram == ""
        ratingLabel.text = String(userItem.rating)
        placeLabel.text = String(place)
        
        ratingLabel.numberOfLines = 0
        ratingLabel.lineBreakMode = .byWordWrapping
        ratingLabel.preferredMaxLayoutWidth = 120
        
        getImage(with: userItem.userId)
        backgroundColor = (userItem.userId == userDefaultsManager.userID) ? ColorManager.Rating.currentUser : .none
        
        ratingLabel.layoutIfNeeded()
        ratingHorizontalStackView.layoutIfNeeded()
    }
    
    @MainActor
    func dismissSkeleton() {
        placeStackView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
        placeStackView.stopSkeletonAnimation()
        userImageView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
        userImageView.stopSkeletonAnimation()
        instagramStackView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
        instagramStackView.stopSkeletonAnimation()
        ratingHorizontalStackView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
        ratingHorizontalStackView.stopSkeletonAnimation()
        nameHorizontalStackView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
        nameHorizontalStackView.stopSkeletonAnimation()
    }
}

// MARK: - Private methods
extension UserRatingCollectionViewCell {
    func makeViewsSkeletonable() {
        userImageView.isSkeletonable = true
        instagramImage.isSkeletonable = true
        instagramStackView.isSkeletonable = true
        ratingHorizontalStackView.isSkeletonable = true
        nameHorizontalStackView.isSkeletonable = true
        placeStackView.isSkeletonable = true
    }
    
    func setupViews() {
        self.contentView.addSubview(userImageView)
        self.contentView.addSubview(nameHorizontalStackView)
        self.contentView.addSubview(lineView)
        self.contentView.addSubview(instagramStackView)
        self.contentView.addSubview(ratingHorizontalStackView)
        self.contentView.addSubview(placeStackView)
        
        userImageView.layer.cornerRadius = 24
    }
    
    func bindViews() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(instagramWasTapped))
        instagramStackView.addGestureRecognizer(tapGesture)
        instagramStackView.isUserInteractionEnabled = true
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            placeStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            placeStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            userImageView.widthAnchor.constraint(equalToConstant: 48),
            userImageView.heightAnchor.constraint(equalToConstant: 48),
            userImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            userImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 63),
            
            nameHorizontalStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            nameHorizontalStackView.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 8),
            
            instagramStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            instagramStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            ratingHorizontalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -63),
            ratingHorizontalStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            lineView.heightAnchor.constraint(equalToConstant: 1),
            lineView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            lineView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func getImage(with userId: String) {
        Task { [weak self] in
            guard let self else { return }
            
            let url = try await self.storageManager.getUrlForImage(path: userId)
            self.userImageView.sd_setImage(with: url,
                                           placeholderImage: UIImage.compareBackground,
                                           options: .scaleDownLargeImages,
                                           completed: nil)
        }
    }
    
    @objc
    func instagramWasTapped() {
        let originalLink = "https://www.instagram.com/"
        if let instagramLink,
           let url = URL(string: originalLink + instagramLink) {
            UIApplication.shared.open(url)
        }
    }
}
