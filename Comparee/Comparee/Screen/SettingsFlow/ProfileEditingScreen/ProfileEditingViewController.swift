//
//  ProfileEditingViewController.swift
//  Comparee
//
//  Created by Андрей Логвинов on 10/19/23.
//

import Combine
import UIKit

class ProfileEditingViewController: UIViewController, UICollectionViewDelegate {
    // MARK: - Private properties
    private lazy var backgroundImageView = BackgroundImageView()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionCompositionalLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .none
        return collectionView
    }()
    
    // MARK: - DataSource
    private var dataSource: ProfileEditingViewModel.DataSource!
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - ViewModel
    private var viewModel: ProfileEditingViewModelProtocol!
    
    // MARK: - Initialization
    init(_ viewModel: ProfileEditingViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.hidesBottomBarWhenPushed = true
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = dataSource.itemIdentifier(for: indexPath) {
            switch item {
            case .settings(let setting): 
                viewModel.output.cellWasTapped(type: setting)
            }
        }
    }
}

// MARK: - Private methods
private extension ProfileEditingViewController {
    func configure() {
        view.addSubview(backgroundImageView)
        view.addSubview(collectionView)
        
        let customTitleView = createCustomTitleView(contactName: " Edit Profile ")
        navigationItem.titleView = customTitleView
        
        setupCollectionView()
        createCustomNavigationBar()
    }
    
    func setContraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)            
        ])
    }
}

// MARK: - Private methods for collection view setup
private extension ProfileEditingViewController {
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
        dataSource = ProfileEditingViewModel.DataSource(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, row in
                guard let self else { return UICollectionViewCell() }
                
                switch row {
                case .settings(let item):
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

private extension ProfileEditingViewController {
    func makeCollectionCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self]
            (sectionIndex: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self else { return nil }
            
            switch self.viewModel.output.sections[sectionIndex] {
            case .settings:
                return self.setupUserSection()
            }
        }
        return layout
    }
    
    func setupUserSection() -> NSCollectionLayoutSection {
        let heightDimension: NSCollectionLayoutDimension = .estimated(49)
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: heightDimension)
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: heightDimension
            ),
            subitem: item, count: 1
        )
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}
