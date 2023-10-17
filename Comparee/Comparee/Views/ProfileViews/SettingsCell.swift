//
//  SettingsCell.swift
//  Comparee
//
//  Created by Андрей Логвинов on 10/11/23.
//

import UIKit

final class SettingsCell: UICollectionViewCell {
    // MARK: - Private properties
    private lazy var cellLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(.sfProTextRegular, size: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var menuImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = IconManager.ProfileScreen.cellImage
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.Rating.line
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension SettingsCell {
    func configure(with text: String) {
        cellLabel.text = text
    }
}

// MARK: - Private methods
private extension SettingsCell {
    func setupView() {
        self.contentView.addSubview(cellLabel)
        self.contentView.addSubview(menuImage)
        self.contentView.addSubview(lineView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            cellLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            cellLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            menuImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -28),
            menuImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),

            lineView.heightAnchor.constraint(equalToConstant: 1),
            lineView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            lineView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
