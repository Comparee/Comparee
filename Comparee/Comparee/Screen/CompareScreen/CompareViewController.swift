//
//  CompareViewController.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/14/23.
//

import Firebase
import SkeletonView
import UIKit

final class CompareViewController: UIViewController {
    // MARK: - Private properties
    private lazy var backgroundImageView = BackgroundImageView()
    private lazy var firstCompareView = CompareView()
    private lazy var secondCompareView = CompareView()
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [firstCompareView, secondCompareView])
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
        
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var adviceLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white.withAlphaComponent(0.1)
        label.text = "Tap on the photo you like better"
        label.font = UIFont.customFont(.satoshiMedium, size: 17)
        label.layer.cornerRadius = 4
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var noCardsLabel: UILabel = {
        let label = UILabel()
        label.text = "You don't have any cards to compare"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var waitingLabel: UILabel = {
        let label = UILabel()
        label.text = "Wait a little, new cards will be coming soon"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = ColorManager.Compare.errorDefinition
        label.numberOfLines = 1
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var viewModel: CompareViewModelProtocol!
    
    // MARK: - Initialization
    init(_ viewModel: CompareViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        bindViews()
        getUserData()
    }
}

// MARK: - Private methods
private extension CompareViewController {
    func setupViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(horizontalStackView)
        view.addSubview(vsView)
        view.addSubview(adviceLabel)
        
        let customTitleView = createCustomTitleView(contactName: "Who is cooler? ")
        navigationItem.titleView = customTitleView
        
        firstCompareView.backgroundImage.isSkeletonable = true
        firstCompareView.horizontalStackView.isSkeletonable = true
        secondCompareView.backgroundImage.isSkeletonable = true
        secondCompareView.horizontalStackView.isSkeletonable = true
    }
    
    func setConstraints() {
        let aspectRatio: CGFloat = 141 / 82
        
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
            vsView.centerYAnchor.constraint(equalTo: horizontalStackView.centerYAnchor, constant: -22),
            vsView.widthAnchor.constraint(equalToConstant: 64),
            vsView.heightAnchor.constraint(equalToConstant: 64),
            
            firstCompareView.heightAnchor.constraint(equalTo: firstCompareView.widthAnchor, multiplier: aspectRatio),
            secondCompareView.heightAnchor.constraint(equalTo: secondCompareView.widthAnchor, multiplier: aspectRatio)
        ])
        
        let aspectRatioConstraint = NSLayoutConstraint(
            item: horizontalStackView,
            attribute: .height,
            relatedBy: .equal,
            toItem: horizontalStackView,
            attribute: .width,
            multiplier: aspectRatio,
            constant: 0
        )
        aspectRatioConstraint.priority = UILayoutPriority(999)
        aspectRatioConstraint.isActive = true
    }
    
    func bindViews() {
        let firstTapGesture = UITapGestureRecognizer(target: self, action: #selector(firstViewTapped))
        let secondTapGesture = UITapGestureRecognizer(target: self, action: #selector(secondViewTapped))
        firstCompareView.addGestureRecognizer(firstTapGesture)
        secondCompareView.addGestureRecognizer(secondTapGesture)
        
        firstCompareView.isUserInteractionEnabled = true
        secondCompareView.isUserInteractionEnabled = true
    }
    
    func getNewPhotos() {
        showSkeleton()
        Task {
            do {
                let newImagePair = try await viewModel.input.getNewImagePair()
                await MainActor.run {
                    dismissSkeleton()
                    firstCompareView.backgroundImage.image = newImagePair.firstImage
                    secondCompareView.backgroundImage.image = newImagePair.secondImage
                }
                let result = try await viewModel.input.getUsersInfoPair()
                firstCompareView.userLabel.text = result.firstUserInfo
                secondCompareView.userLabel.text = result.secondUserInfo
            }
            catch {
                await MainActor.run {
                    switch error {
                    case CompareError.newComparisonsNotFound:
                        newComparisonsNotFound()
                    case CompareError.connectionProblem:
                        showAlert()
                    default:
                        showAlert()
                    }
                }
            }
        }
    }
    
    func getUserData() {
        Task {
            try await viewModel.input.getAllUserIds()
            await MainActor.run {
                getNewPhotos()
            }
        }
    }
}

// MARK: - User Interaction
private extension CompareViewController {
    @objc func firstViewTapped() {
        getNewPhotos()
        viewModel.input.viewWasSelected(.first)
    }

    @objc func secondViewTapped() {
        getNewPhotos()
        viewModel.input.viewWasSelected(.second)
    }
    
    @objc func tryButtonWasTapped() {
        getUserData()
    }
}

// MARK: - SkeletonView
private extension CompareViewController {
    func showSkeleton() {
        firstCompareView.backgroundImage.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient(baseColor: UIColor.clouds))
        secondCompareView.backgroundImage.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient(baseColor: UIColor.clouds))
        firstCompareView.horizontalStackView.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient(baseColor: UIColor.clouds))
        secondCompareView.horizontalStackView.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient(baseColor: UIColor.clouds))
    }
    
    func dismissSkeleton() {
        firstCompareView.backgroundImage.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
        firstCompareView.backgroundImage.stopSkeletonAnimation()
        
        secondCompareView.backgroundImage.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
        secondCompareView.backgroundImage.stopSkeletonAnimation()
        
        firstCompareView.horizontalStackView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
        firstCompareView.horizontalStackView.stopSkeletonAnimation()
        
        secondCompareView.horizontalStackView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
        secondCompareView.horizontalStackView.stopSkeletonAnimation()
    }
}

// MARK: - Error Handling
private extension CompareViewController {
    func showAlert() {
        let alertView = AlertView()
        alertView.setUpCustomAlert(
            title: "Loading error",
            description: "Please try refreshing the page or checking your internet connection",
            actionText: "Try again"
        )
        alertView.actionButton.addTarget(self, action: #selector(tryButtonWasTapped), for: .touchUpInside)
        viewModel.input.showAlert(alertView)
    }
    
    func newComparisonsNotFound() {
        horizontalStackView.isHidden = true
        vsView.isHidden = true
        adviceLabel.isHidden = true
        view.addSubview(noCardsLabel)
        view.addSubview(waitingLabel)
        
        NSLayoutConstraint.activate([
            noCardsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 52),
            noCardsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -52),
            noCardsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noCardsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -14),
            noCardsLabel.heightAnchor.constraint(equalToConstant: 64),
            
            waitingLabel.topAnchor.constraint(equalTo: noCardsLabel.bottomAnchor, constant: 8),
            waitingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            waitingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}
