//
//  CompareViewController.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/14/23.
//

import UIKit
import Firebase

final class CompareViewController: UIViewController {
    // MARK: - Private properties
    private lazy var backgroundImageView = BackgroundImageView()
    private lazy var firstView = CompareView()
    private lazy var secondView = CompareView()
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [firstView, secondView])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 7
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var vsView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 32
        view.backgroundColor = .white
        
        let imageView = UIImageView(image: IconManager.CompareScreen.vsTitle)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        imageView.centerYAnchor.constraint(equalTo:  view.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo:  view.centerXAnchor).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var adviceLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
        label.text = "Tap on the photo you like better"
        label.font = UIFont.customFont(.satoshiMedium, size: 17)
        label.layer.cornerRadius = 4
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
    }
}

// MARK: - Private methods
private extension CompareViewController {
    func setupViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(horizontalStackView)
        view.addSubview(vsView)
        view.addSubview(adviceLabel)
        
        let customTitleView = createCustomTitleView(contactName: "Who is cooler?")
        navigationItem.titleView = customTitleView
        createCustomNavigationBar()
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            horizontalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            horizontalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            adviceLabel.leadingAnchor.constraint(equalTo: horizontalStackView.leadingAnchor),
            adviceLabel.trailingAnchor.constraint(equalTo: horizontalStackView.trailingAnchor),
            adviceLabel.bottomAnchor.constraint(equalTo: horizontalStackView.topAnchor, constant: -20),
            adviceLabel.heightAnchor.constraint(equalToConstant: 33),
            
            vsView.centerXAnchor.constraint(equalTo: horizontalStackView.centerXAnchor),
            vsView.centerYAnchor.constraint(equalTo: horizontalStackView.centerYAnchor,constant: -22),
            vsView.widthAnchor.constraint(equalToConstant: 64),
            vsView.heightAnchor.constraint(equalToConstant: 64)
        ])
        
        let aspectRatioConstraint = NSLayoutConstraint(
            item: horizontalStackView,
            attribute: .height,
            relatedBy: .equal,
            toItem: horizontalStackView,
            attribute: .width,
            multiplier: 141 / 82,
            constant: 0
        )
        aspectRatioConstraint.priority = UILayoutPriority(999)
        aspectRatioConstraint.isActive = true

        firstView.heightAnchor.constraint(equalTo: firstView.widthAnchor, multiplier: 141 / 82).isActive = true
        secondView.heightAnchor.constraint(equalTo: secondView.widthAnchor, multiplier: 141 / 82).isActive = true
    }
}

