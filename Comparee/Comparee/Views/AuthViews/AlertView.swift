//
//  AlertView.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/8/23.
//

import SwiftEntryKit
import UIKit

final class AlertView: UIView {
    
    private lazy var viewForCancel: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray4
        view.layer.cornerRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Upload Error"
        label.font = UIFont.customFont(.sfProTextSemibold, size: 20)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Failed to upload photo. Please check the information provided and try again."
        label.font = UIFont.customFont(.sfProTextRegular, size: 15)
        label.textColor = ColorManager.PhotoUpload.photoUploadDefinition
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    lazy var actionButton: UIButton = {
        let button = UIButton()
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.customFont(.sfProTextMedium, size: 16)
        button.backgroundColor = .systemIndigo
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
        return button
    }()
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = .white
        layer.cornerRadius = 24
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func actionButtonPressed() {
        SwiftEntryKit.dismiss()
    }
}

// MARK: - Setup Constraints
private extension AlertView {
    func setupConstraints() {
        let height: CGFloat = 45
        
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(actionButton)
        addSubview(viewForCancel)
        
        NSLayoutConstraint.activate([
            viewForCancel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            viewForCancel.centerXAnchor.constraint(equalTo: centerXAnchor),
            viewForCancel.heightAnchor.constraint(equalToConstant: 4),
            viewForCancel.widthAnchor.constraint(equalToConstant: 42)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30)
        ])
        
        descriptionLabel.layoutToSuperview(axis: .horizontally, offset: 30)
        descriptionLabel.layout(.top, to: .bottom, of: titleLabel, offset: 4)
        descriptionLabel.forceContentWrap(.vertically)
        
        actionButton.set(.height, of: height)
        actionButton.layout(.top, to: .bottom, of: descriptionLabel, offset: 12)
        actionButton.layoutToSuperview(.bottom, offset: -24)
        actionButton.layoutToSuperview(.centerX)
        actionButton.layoutToSuperview(.trailing, offset: -16)
        actionButton.layoutToSuperview(.leading, offset: 16)
        
        actionButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30)
        
        actionButton.layer.cornerRadius = height * 0.5
    }
}

// MARK: - Setup Attributes
extension AlertView {
    static func setupAttributes() -> EKAttributes {
        var attributes = EKAttributes.bottomFloat
        attributes.displayDuration = .infinity
        attributes.screenBackground = .color(color: .init(light: ColorManager.PhotoUpload.lightAlertColor, dark: ColorManager.PhotoUpload.darkAlertColor))
        attributes.shadow = .active(
            with: .init(
                color: .black,
                opacity: 0.3,
                radius: 8
            )
        )
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .enabled(
            swipeable: true,
            pullbackAnimation: .jolt
        )
        
        attributes.entranceAnimation = .init(
            translate: .init(
                duration: 0.7,
                spring: .init(damping: 1, initialVelocity: 0)
            ),
            scale: .init(
                from: 1.05,
                to: 1,
                duration: 0.4,
                spring: .init(damping: 1, initialVelocity: 0)
            )
        )
        
        attributes.exitAnimation = .init(
            translate: .init(duration: 0.2)
        )
        attributes.popBehavior = .animated(
            animation: .init(
                translate: .init(duration: 0.2)
            )
        )
        
        attributes.positionConstraints.verticalOffset = 10
        attributes.statusBar = .light
        return attributes
    }
    
    func setUpCustomAlert(title: String, description: String, actionText: String) {
        titleLabel.text = title
        descriptionLabel.text = description
        actionButton.setTitle(actionText, for: .normal)
    }
}
