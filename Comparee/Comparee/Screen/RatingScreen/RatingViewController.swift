//
//  RatingViewController.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/14/23.
//

import Combine
import UIKit
import SkeletonView

final class RatingViewController: UIViewController {
    
    // MARK: - Private properties
    private lazy var backgroundImageView = BackgroundImageView()
    private lazy var currentUserView = CurrentUserView()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionCompositionalLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset.top = 20
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .none
        return collectionView
    }()
    let refreshControl = UIRefreshControl()
    
    // MARK: - DataSource
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
        print(#function)
        super.viewDidLoad()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        collectionView.delegate = self
        collectionView.isSkeletonable = true
        setupViews()
        bindViewModel()
        viewModel.input.viewDidLoad()
        setupCurrentUser()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print(#function)
        super.viewWillDisappear(animated)
        viewModel.input.viewWillDisappear()
    }
    
    @objc private func handleRefresh() {
        print(#function)
        collectionView.refreshControl?.beginRefreshing()
        
        viewModel.input.viewDidLoad()
        
        DispatchQueue.main.async {
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
}

// MARK: - Private methods for views setup
private extension RatingViewController {
    func setupViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(collectionView)
        view.addSubview(currentUserView)
        
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
            
            currentUserView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            currentUserView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            currentUserView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            currentUserView.heightAnchor.constraint(equalToConstant: 66),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: currentUserView.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    func setupCurrentUser() {
        print(#function)
        Task { [weak self] in
            guard let self else { return }
            
            let currentUser = try await self.viewModel.output.getCurrentUser()
            guard let currentUser else { return }
            
            self.currentUserView.configure(currentUser, place: currentUser.currentPlace ?? 0)
            self.currentUserView.dismissSkeleton()
        }
    }
}

// MARK: - Collection View setup
private extension RatingViewController {
    func setupCollectionView() {
        registerCells()
        setupDataSource()
    }
    
    func setupDataSource() {
        setupDataSourceWithCells()
        setupDataSourceWithSupplementaryView()
    }
    
    func setupDataSourceWithCells() {
        dataSource = RatingViewModel.DataSource(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, row in
                guard let self else { return UICollectionViewCell() }
                
                switch row {
                case .users(let item):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: UserRatingCollectionViewCell.reuseIdentifier,
                        for: indexPath
                    ) as? UserRatingCollectionViewCell else {
                        return UICollectionViewCell() }
                    
                    // We add 4 to indexPath.row because the first 3 items are displayed in the header view,
                    // so we start numbering the actual cells from 4 to match their position in the list.
                    let place = indexPath.item + 4
                    
                    if viewModel.output.isLoading {
                        cell.isSkeletonable = true
                        cell.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient(baseColor: UIColor.clouds))
                    } else {
                        cell.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                        cell.stopSkeletonAnimation()
                        cell.configure(item, place: place)
                    }
                    return cell
                }
            }
        )
    }
    
    func setupDataSourceWithSupplementaryView() {
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self else { return UICollectionReusableView() }
            //  print(#function)
            let section = self.viewModel.output.sections[indexPath.section]
            switch section {
            case .users(let item):
                if let headerView = self.collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RatingHeaderView.reuseIdentifier, for: indexPath) as? RatingHeaderView {
                    // Getting first three elements for header view
                    let firstThreeItems = Array(item.prefix(3))
                    
                    if viewModel.output.isLoading {
                        headerView.isSkeletonable = true
                        headerView.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient(baseColor: UIColor.clouds))
                    } else {
                        headerView.configure(with: firstThreeItems)
                    }
                    
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
        collectionView.register(UserRatingCollectionViewCell.self, forCellWithReuseIdentifier: UserRatingCollectionViewCell.reuseIdentifier)
        collectionView.register(RatingHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: RatingHeaderView.reuseIdentifier)
    }
    
    func bindViewModel() {
        viewModel.output.dataSourceSnapshot
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self else { return }
                
                self.dataSource.apply($0, animatingDifferences: true, completion: nil)
                self.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
}

// MARK: - private methods for layout setup
private extension RatingViewController {
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
}

// MARK: - CollectionView Delegate
extension RatingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // When the current cell is 4 items from the end of the collection,
        // trigger pagination to load more items.
        if indexPath.row == viewModel.output.usersCount - 4 && !viewModel.output.isLoading {
            Task { [weak self] in
                guard let self else { return }
                
                let value = try await self.viewModel.output.getMaxCount()
                if !value {
                    self.viewModel.output.pagination()
                }
            }
        }
    }
    
}
