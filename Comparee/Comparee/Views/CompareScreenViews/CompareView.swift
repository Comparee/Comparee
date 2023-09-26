//
//  CompareView.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/18/23.
//

import UIKit

final class CompareView: UIView {
    // MARK: - Private properties
    private lazy var instagramImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = IconManager.CompareScreen.instagram
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Public properties
    lazy var userLabel: UILabel = {
        let label = UILabel()
        label.text = "---------------"
        label.textColor = .white
        label.font = UIFont.customFont(.satoshiMedium, size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var horizontalStackView: UIStackView = {
        NSLayoutConstraint.activate([
            instagramImage.widthAnchor.constraint(equalToConstant: 32),
            instagramImage.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        let stackView = UIStackView(arrangedSubviews: [instagramImage, userLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layer.cornerRadius = 16
        stackView.clipsToBounds = true
        return stackView
    }()
    
    lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = IconManager.CompareScreen.background
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension CompareView {
    func createHorizontalStack(hasInstagram: Bool) {
        let stackView: UIStackView
        
        if hasInstagram {
            stackView = UIStackView(arrangedSubviews: [instagramImage, userLabel])
            NSLayoutConstraint.activate([
                instagramImage.widthAnchor.constraint(equalToConstant: 32),
                instagramImage.heightAnchor.constraint(equalToConstant: 32)
            ])
        } else {
            stackView = UIStackView(arrangedSubviews: [userLabel])
        }
        
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layer.cornerRadius = 16
        stackView.clipsToBounds = true
        
        horizontalStackView = stackView
    }
}

// MARK: - Private methods
private extension CompareView {
    func setupViews() {
        addSubview(backgroundImage)
        addSubview(horizontalStackView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: horizontalStackView.topAnchor, constant: -12),
            
            horizontalStackView.heightAnchor.constraint(equalToConstant: 32),
            horizontalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
