//
//  ProfileViewController.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/14/23.
//

import Combine
import UIKit

final class ProfileViewController: UIViewController, UICollectionViewDelegate {
    // MARK: - Private properties
    private lazy var backgroundImageView = BackgroundImageView()
    private lazy var currentUserView = UserProfileView()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionCompositionalLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .none
        return collectionView
    }()
    
    private lazy var signOutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 24
        button.titleLabel?.font = UIFont.customFont(.sfProTextSemibold, size: 16)
        button.setTitle("Sign out", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(signOutButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - DataSource
    private var dataSource: ProfileViewModel.DataSource!
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - ViewModel
    private var viewModel: ProfileViewModelProtocol!
    
    // MARK: - Initialization
    init(_ viewModel: ProfileViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        configure()
        setContraints()
        bindViewModel()
        viewModel.input.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.input.viewDidAppear()
        setupCurrentUser()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = dataSource.itemIdentifier(for: indexPath) {
            switch item {
            case .users(let user):
                viewModel.output.cellWasTapped(type: user)
            }
        }
    }
}

// MARK: - Private methods
private extension ProfileViewController {
    func configure() {
        view.addSubview(backgroundImageView)
        view.addSubview(currentUserView)
        view.addSubview(collectionView)
        view.addSubview(signOutButton)
        
        let customTitleView = createCustomTitleView(contactName: " Profile ")
        navigationItem.titleView = customTitleView
        
        setupCollectionView()
    }
    
    func setContraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            currentUserView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            currentUserView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            currentUserView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            currentUserView.heightAnchor.constraint(equalToConstant: 65),
            
            collectionView.topAnchor.constraint(equalTo: currentUserView.bottomAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            signOutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            signOutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            signOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            signOutButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    func setupCurrentUser() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let currentUser = try await self.viewModel.output.getCurrentUser()
                guard let currentUser else { return }
                
                self.currentUserView.configure(currentUser)
                self.currentUserView.dismissSkeleton()
            } catch {
                self.showAlert(alertType: .userUploading)
            }
        }
    }
}

// MARK: - Private methods for collection view setup
private extension ProfileViewController {
    func setupCollectionView() {
        registerCells()
        setupDataSource()
    }
    
    func setupDataSource() {
        setupDataSourceWithCells()
    }
    
    func registerCells() {
        collectionView.register(SettingsCell.self, forCellWithReuseIdentifier: SettingsCell.reuseIdentifier)
    }
    
    func setupDataSourceWithCells() {
        dataSource = ProfileViewModel.DataSource(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, row in
                guard let self else { return UICollectionViewCell() }
                
                switch row {
                case .users(let item):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: SettingsCell.reuseIdentifier,
                        for: indexPath
                    ) as? SettingsCell else { return UICollectionViewCell() }
                    
                    cell.configure(with: item.name.rawValue)
                    return cell
                }
            }
        )
    }
    
    func bindViewModel() {
        viewModel.output.dataSourceSnapshot
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self else { return }
                
                self.dataSource.apply($0, animatingDifferences: true, completion: nil)
            }
            .store(in: &cancellables)
    }
}

private extension ProfileViewController {
    func makeCollectionCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self]
            (sectionIndex: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self else { return nil }
            
            switch self.viewModel.output.sections[sectionIndex] {
            case .users:
                return self.setupUserSection()
            }
        }
        return layout
    }
    
    func setupUserSection() -> NSCollectionLayoutSection {
        let heightDimension: NSCollectionLayoutDimension = .estimated(49)
        let item = NSCollectionLayoutItem( layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: heightDimension))
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: heightDimension), subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}

// MARK: - Error handling
private extension ProfileViewController {
    func showAlert(alertType: AlertCase) {
        let alertView = AlertView()
        alertView.setUpCustomAlert(
            title: "Loading error",
            description: "Please try refreshing the page or checking your internet connection",
            actionText: "Try again"
        )
        switch alertType {
        case .signOut:
            alertView.actionButton.addTarget(self, action: #selector(signOutButtonTapped), for: .touchUpInside)
        case .userUploading:
            alertView.actionButton.addTarget(self, action: #selector(tryButtonWasTapped), for: .touchUpInside)
        }
        viewModel.input.showAlert(alertView)
    }
    
    @objc func signOutButtonTapped() {
        Task { [weak self] in
            guard let self else { return }
            do {
                try await self.viewModel.output.signOut()
            } catch {
                self.showAlert(alertType: .signOut)
            }
        }
    }
    
    @objc func tryButtonWasTapped() {
        setupCurrentUser()
    }
}
