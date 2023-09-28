//
//  RatingHeaderView.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/28/23.
//

import UIKit

final class RatingHeaderView: UIView {
    // MARK: - Private properties
    private lazy var firstUser = TopUserView()
    private lazy var secondUser = TopUserView()
    private lazy var thirdUser = TopUserView()
    
    private lazy var firstLabel = TopPlaceLabel(text: "1")
    private lazy var secondLabel = TopPlaceLabel(text: "2")
    private lazy var thirdLabel = TopPlaceLabel(text: "3")
    
    private lazy var crownImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Crown")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupUserViewsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            
            firstUser.topAnchor.constraint(equalTo: self.topAnchor, constant: 102),
            firstUser.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            firstUser.widthAnchor.constraint(equalToConstant: 120),
            
            thirdUser.leadingAnchor.constraint(equalTo: firstUser.trailingAnchor, constant: 10),
            thirdUser.topAnchor.constraint(equalTo: self.topAnchor, constant: 148),
            thirdUser.widthAnchor.constraint(equalToConstant: 97),
            
            crownImageView.bottomAnchor.constraint(equalTo: firstUser.topAnchor, constant: -8),
            crownImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            crownImageView.widthAnchor.constraint(equalToConstant: 32),
            crownImageView.heightAnchor.constraint(equalToConstant: 32),
            
            secondLabel.bottomAnchor.constraint(equalTo: secondUser.topAnchor, constant: -15),
            secondLabel.centerXAnchor.constraint(equalTo: secondUser.centerXAnchor),
            
            firstLabel.bottomAnchor.constraint(equalTo: crownImageView.topAnchor, constant: -15),
            firstLabel.centerXAnchor.constraint(equalTo: crownImageView.centerXAnchor),
            
            thirdLabel.bottomAnchor.constraint(equalTo: thirdUser.topAnchor, constant: -15),
            thirdLabel.centerXAnchor.constraint(equalTo: thirdUser.centerXAnchor)
        ])
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
