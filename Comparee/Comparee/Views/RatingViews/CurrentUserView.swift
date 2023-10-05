//
//  CurrentUserView.swift
//  Comparee
//
//  Created by Андрей Логвинов on 10/5/23.
//

import UIKit
import Kingfisher

class CurrentUserView: UIView {

    private lazy var placeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        label.text = "1"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = IconManager.PhotoUpload.preview
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
        label.textAlignment = .center
        label.text = "Andrey"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.text = "1820"
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
    
    // MARK: - Initialise
    override init(frame: CGRect) {
        super.init(frame: frame)
       // translatesAutoresizingMaskIntoConstraints = false
        setupViews()
        setConstraints()
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(red: 0.412, green: 0.204, blue: 0.761, alpha: 1)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    var storageManager = StorageManager()
    
    func configure(_ userItem: UsersViewItem, place: Int) {
        nameLabel.text = userItem.name
        instagramImage.isHidden = !userItem.isInstagramEnabled
        ratingLabel.text = String(userItem.rating)
        placeLabel.text = String(place)
        Task {
            let url = try await storageManager.getUrlForImage(path: userItem.userId)
            userImageView.image = try await downloadImage(from: url)
        }
    }
    
    func downloadImage(from url: URL) async throws -> UIImage {
        try await withCheckedThrowingContinuation { continuation in
            Task {
                await MainActor.run {
                    let imageView = UIImageView()
                    imageView.kf.setImage(with: url) { result in
                        switch result {
                        case .success(let value):
                            continuation.resume(returning: value.image)
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                    }
                }
            }
        }
    }
}

private extension CurrentUserView {
    func setupViews() {
        self.addSubview(placeLabel)
        self.addSubview(userImageView)
        self.addSubview(nameLabel)
        self.addSubview(ratingLabel)
        self.addSubview(instagramImage)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            placeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            placeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            userImageView.widthAnchor.constraint(equalToConstant: 48),
            userImageView.heightAnchor.constraint(equalToConstant: 48),
            userImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            userImageView.leadingAnchor.constraint(equalTo: placeLabel.trailingAnchor, constant: 32),
            
            nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 8),
            
            instagramImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            instagramImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            ratingLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: instagramImage.leadingAnchor, constant: -12)
        ])
    }
}

