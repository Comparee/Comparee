//
//  RatingViewController.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/14/23.
//

import Combine
import UIKit

final class RatingViewController: UIViewController, UICollectionViewDelegate {
    
    // MARK: - Private properties
    private lazy var backgroundImageView = BackgroundImageView()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionCompositionalLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .none
        return collectionView
    }()
    
    private lazy var currentUser = CurrentUserView()
    
    // MARK: - Private Properties
    private var dataSource: RatingViewModel.DataSource!
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - ViewModel
    private var viewModel: RatingViewModelProtocol!
    
    // MARK: - Initialization
    init(_ viewModel: RatingViewModelProtocol) {
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
        setupViews()
        bindViewModel()
        viewModel.input.viewDidLoad()
        Task {
            let a = try await viewModel.output.getCurrentUser()
            self.currentUser.configure(a, place: a.rating)
            currentUser.dismissSkeleton()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //viewModel.input.viewDidLoad()
        Task {
            let a = try await viewModel.output.getCurrentUser()
            self.currentUser.configure(a, place: a.rating)
            currentUser.dismissSkeleton()
        }
    }
}

// MARK: - Private methods
extension RatingViewController {
    func setupViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(collectionView)
        view.addSubview(currentUser)
        
        let customTitleView = createCustomTitleView(contactName: " Rating ")
        navigationItem.titleView = customTitleView
        setupCollectionView()
        setConstraints()
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            currentUser.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            currentUser.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            currentUser.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            currentUser.heightAnchor.constraint(equalToConstant: 66),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: currentUser.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
    }
    
    func setupCollectionView() {
        registerCells()
        setupDataSource()
    }
    
    func setupDataSource() {
        setupDataSourceWithCells()
        setupDataSourceWithSupplementaryView()
    }
    
    func setupDataSourceWithCells() {
        dataSource = RatingViewModel.DataSource(collectionView: collectionView, cellProvider: { [weak self] (collectionView, indexPath, row) in
            guard let self else { return UICollectionViewCell() }
            switch row {
            case .users(let item):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserRatingCellCollectionViewCell.reuseIdentifier, for: indexPath) as? UserRatingCellCollectionViewCell else {
                    return UICollectionViewCell() }
                let place = indexPath.row + 4
                cell.configure(item, place: place)
                print(!viewModel.output.isLoading)
                if !viewModel.output.isLoading {
                    cell.dismissSkeleton()
                }
                else {
                    cell.showSkeleton()
                }
                return cell
            }
        })
    }
    
    func setupDataSourceWithSupplementaryView() {
        dataSource.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) in
            guard let self else { return UICollectionReusableView() }
            
            let section = self.viewModel.output.sections[indexPath.section]
            switch section {
            case .users(let item):
                if let headerView = self.collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RatingHeaderView.reuseIdentifier, for: indexPath) as? RatingHeaderView {
                    // Getting first three elements for header view
                    let firstThreeItems = Array(item.prefix(3))

                    headerView.configure(with: firstThreeItems)
                    
                    return headerView
                }
            }
            return UICollectionReusableView()
        }
    }
    
    
    func makeHeaderViewSupplementaryItemWithHeight(_ height: CGFloat) -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerViewItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(height)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top
        )
        headerViewItem.pinToVisibleBounds = false
        
        return headerViewItem
    }
    
    func registerCells() {
        collectionView.register(UserRatingCellCollectionViewCell.self, forCellWithReuseIdentifier: UserRatingCellCollectionViewCell.reuseIdentifier)
        collectionView.register(RatingHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: RatingHeaderView.reuseIdentifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == viewModel.output.usersCount - 4 {
            viewModel.output.pagination()
        }
    }
}

extension RatingViewController: UICollectionViewDelegateFlowLayout {
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
        let heightDimension: NSCollectionLayoutDimension = .estimated(60)
        let item = NSCollectionLayoutItem( layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: heightDimension))
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: heightDimension), subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [makeHeaderViewSupplementaryItemWithHeight(337)]
        return section
    }
    
    func bindViewModel() {
        viewModel.output.dataSourceSnapshot
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self else { return }
                
                self.dataSource.apply($0 , animatingDifferences: true , completion: nil)
            }
            .store(in: &cancellables)
    }
}
