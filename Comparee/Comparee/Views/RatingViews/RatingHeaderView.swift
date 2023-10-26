//
//  RatingHeaderView.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/28/23.
//

import UIKit

final class RatingHeaderView: UICollectionReusableView {
    // MARK: - Private properties
    private lazy var firstUser = TopUserView()
    private lazy var secondUser = TopUserView()
    private lazy var thirdUser = TopUserView()
    
    private lazy var firstLabel = TopPlaceLabel(text: "1")
    private lazy var secondLabel = TopPlaceLabel(text: "2")
    private lazy var thirdLabel = TopPlaceLabel(text: "3")
    
    private lazy var crownImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = IconManager.RatingScreen.crown
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUserViewsLayout()
        firstUser.showSkeleton()
        secondUser.showSkeleton()
        thirdUser.showSkeleton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - public methods
    func configure(with items: [UsersViewItem]) {
        if !items.isEmpty {
            firstUser.configure(items[0])
            secondUser.configure(items[1])
            thirdUser.configure(items[2])
        }
    }
}

// MARK: - Private methods
private extension RatingHeaderView {
    func setupUserViewsLayout() {
        setupViews()
        setConstraints()
        setAspectRatiosForUserViews()
    }
    
    func setupViews() {
        addSubview(firstUser)
        addSubview(secondUser)
        addSubview(thirdUser)
        addSubview(crownImageView)
        addSubview(firstLabel)
        addSubview(secondLabel)
        addSubview(thirdLabel)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            secondUser.trailingAnchor.constraint(equalTo: firstUser.leadingAnchor, constant: -10),
            secondUser.topAnchor.constraint(equalTo: self.topAnchor, constant: 148),
            secondUser.widthAnchor.constraint(equalToConstant: 97),
            
            firstUser.topAnchor.constraint(equalTo: self.topAnchor, constant: 80),
            firstUser.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            firstUser.widthAnchor.constraint(equalToConstant: 120),
            
            thirdUser.leadingAnchor.constraint(equalTo: firstUser.trailingAnchor, constant: 10),
            thirdUser.topAnchor.constraint(equalTo: self.topAnchor, constant: 148),
            thirdUser.widthAnchor.constraint(equalToConstant: 97),
            
            crownImageView.bottomAnchor.constraint(equalTo: firstUser.topAnchor, constant: -18),
            crownImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            crownImageView.widthAnchor.constraint(equalToConstant: 51),
            crownImageView.heightAnchor.constraint(equalToConstant: 42),
            
            secondLabel.bottomAnchor.constraint(equalTo: secondUser.topAnchor, constant: -15),
            secondLabel.centerXAnchor.constraint(equalTo: secondUser.centerXAnchor),
            
            firstLabel.bottomAnchor.constraint(equalTo: crownImageView.topAnchor, constant: -15),
            firstLabel.centerXAnchor.constraint(equalTo: crownImageView.centerXAnchor),
            
            thirdLabel.bottomAnchor.constraint(equalTo: thirdUser.topAnchor, constant: -15),
            thirdLabel.centerXAnchor.constraint(equalTo: thirdUser.centerXAnchor)
        ])
        
        firstUser.userPhoto.layer.cornerRadius = firstUser.frame.width / 2
        firstUser.skeletonCornerRadius = Float(firstUser.frame.width / 2)
        secondUser.userPhoto.layer.cornerRadius = secondUser.frame.width / 2
        secondUser.skeletonCornerRadius = Float(secondUser.frame.width / 2)
        thirdUser.userPhoto.layer.cornerRadius = thirdUser.frame.width / 2
        thirdUser.skeletonCornerRadius = Float(thirdUser.frame.width / 2)
    }
    
    func setAspectRatiosForUserViews() {
        let aspectRatioForFirstUser: CGFloat = 188 / 120
        let aspectRatioForOtherUser: CGFloat = 165 / 97
        
        let firstUserAspectRatioConstraint = NSLayoutConstraint(
            item: firstUser,
            attribute: .height,
            relatedBy: .equal,
            toItem: firstUser,
            attribute: .width,
            multiplier: aspectRatioForFirstUser,
            constant: 0
        )
        
        let secondUserAspectRatioConstraint = NSLayoutConstraint(
            item: secondUser,
            attribute: .height,
            relatedBy: .equal,
            toItem: secondUser,
            attribute: .width,
            multiplier: aspectRatioForOtherUser,
            constant: 0
        )
        
        let thirdUserAspectRatioConstraint = NSLayoutConstraint(
            item: thirdUser,
            attribute: .height,
            relatedBy: .equal,
            toItem: thirdUser,
            attribute: .width,
            multiplier: aspectRatioForOtherUser,
            constant: 0
        )
        
        secondUserAspectRatioConstraint.priority = UILayoutPriority(999)
        secondUserAspectRatioConstraint.isActive = true
        
        firstUserAspectRatioConstraint.priority = UILayoutPriority(999)
        firstUserAspectRatioConstraint.isActive = true
        
        thirdUserAspectRatioConstraint.priority = UILayoutPriority(999)
        thirdUserAspectRatioConstraint.isActive = true
    }
}
