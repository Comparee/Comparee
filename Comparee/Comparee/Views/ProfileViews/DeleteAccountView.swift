//
//  deleteAccountView.swift
//  Comparee
//
//  Created by Андрей Логвинов on 10/20/23.
//

import SwiftEntryKit
import UIKit

final class DeleteAccountView: UIView {
    
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
        label.text = "Delete account"
        label.font = UIFont.customFont(.sfProTextSemibold, size: 20)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Are you sure you want to delete your account?"
        label.font = UIFont.customFont(.sfProTextRegular, size: 15)
        label.textColor = ColorManager.PhotoUpload.photoUploadDefinition
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.customFont(.sfProTextMedium, size: 16)
        button.backgroundColor = .systemIndigo
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 22.5
        button.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.systemIndigo, for: .normal)
        button.titleLabel?.font = UIFont.customFont(.sfProTextMedium, size: 16)
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemIndigo.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 22.5
        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [cancelButton, deleteButton])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
    
    func setUpCustomAlert(title: String, description: String, actionText: String) {
        titleLabel.text = title
        descriptionLabel.text = description
        deleteButton.setTitle(actionText, for: .normal)
    }
    
    @objc func deleteButtonPressed() {
        SwiftEntryKit.dismiss()
    }
    
    @objc func cancelButtonPressed() {
        SwiftEntryKit.dismiss()
    }
}

// MARK: - Private methods
private extension DeleteAccountView {
    func setupConstraints() {
        let height: CGFloat = 45
        
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(buttonStack)
        addSubview(viewForCancel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            
            viewForCancel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            viewForCancel.centerXAnchor.constraint(equalTo: centerXAnchor),
            viewForCancel.heightAnchor.constraint(equalToConstant: 4),
            viewForCancel.widthAnchor.constraint(equalToConstant: 42)
        ])
        
        descriptionLabel.layoutToSuperview(axis: .horizontally, offset: 30)
        descriptionLabel.layout(.top, to: .bottom, of: titleLabel, offset: 4)
        descriptionLabel.forceContentWrap(.vertically)
        
        buttonStack.layout(.top, to: .bottom, of: descriptionLabel, offset: 12)
        buttonStack.layoutToSuperview(.bottom, offset: -24)
        buttonStack.layoutToSuperview(.centerX)
        buttonStack.layoutToSuperview(.leading, offset: 16)
        buttonStack.layoutToSuperview(.trailing, offset: -16)
        
        buttonStack.set(.height, of: height)
        buttonStack.layer.cornerRadius = height * 0.5
    }
}
