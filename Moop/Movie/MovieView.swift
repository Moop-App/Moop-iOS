//
//  MovieView.swift
//  Moop
//
//  Created by kor45cw on 2019/10/12.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit
import SafariServices

class MovieView: UIViewController {
    
    enum Section: CaseIterable {
        case main
    }
    
    static func instance() -> MovieView {
        let vc: MovieView = instance(storyboardName: Storyboard.movie)
        vc.presenter = MoviePresenter(view: vc)
        return vc
    }
    
    var presenter: MoviePresenterDelegate!
    var dataSource: UICollectionViewDiffableDataSource<Section, Movie>!
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let refreshControl = UIRefreshControl()
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
            collectionView.refreshControl = refreshControl
            collectionView.register(MovieCell.self)
            collectionView.register(MovieViewSegmentedControl.self,
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                    withReuseIdentifier: "MovieViewSegmentedControl")
        }
    }
    
    @objc private func requestData() {
        presenter.fetchDatas()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        presenter.viewDidLoad()
        configureDataSource()
        collectionView.collectionViewLayout = createdLayout()
    }
    
    func changeIndex(_ index: Int) {
        if let view = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0)) as? MovieViewSegmentedControl {
            view.setIndex(index)
        }
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Movie>(collectionView: collectionView) { (collectionView, indexPath, movie) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MovieCell else { return UICollectionViewCell() }
            cell.set(movie)
            return cell
        }
        
        dataSource.supplementaryViewProvider = { [weak self] (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MovieViewSegmentedControl", for: indexPath) as? MovieViewSegmentedControl else { return nil }
            header.delegate = self
            return header
        }
    }
    
    private func createdLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (_, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let isWideView = layoutEnvironment.container.effectiveContentSize.width > 414
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let count = isWideView ? 5 : 3
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalWidth(1 / (6 * CGFloat(count)) * 8.1))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: count)
            group.interItemSpacing = .fixed(8)
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 8
            section.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 0, bottom: 0, trailing: 0)
            
            
            let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                          heightDimension: .estimated(42))
            
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerFooterSize,
                elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [sectionHeader]
            
            return section
        }
    }
    
    private func setUp() {
        navigationItem.title = MoviePresenter.MovieType.current.title
        searchController.searchResultsUpdater = presenter as? MoviePresenter
        searchController.searchBar.delegate = presenter as? MoviePresenter
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        navigationItem.searchController = searchController
    }
    
    var canScrollToTop: Bool = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        canScrollToTop = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        canScrollToTop = false
    }
    
    @IBAction private func filter(_ sender: UIBarButtonItem) {
        let destination = FilterView.instance()
        destination.delegate = presenter as? MoviePresenter
        self.present(UINavigationController(rootViewController: destination), animated: true)
    }
}

extension MovieView: MovieViewDelegate {
    func loadFinished(_ movies: [Movie]) {
        refreshControl.endRefreshing()
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
        snapshot.appendSections([.main])
        snapshot.appendItems(movies)
        dataSource.apply(snapshot, animatingDifferences: true)
        
        presenter.updateIndexes()
    }
    
    func loadFailed() {
        refreshControl.endRefreshing()
    }
    
    func change(state: MoviePresenter.MovieType) {
        navigationItem.title = state.title
    }
    
    func share(text: String) {
        let viewController = UIActivityViewController(activityItems: [text], applicationActivities: [])
        if UIDevice.current.userInterfaceIdiom == .pad {
            viewController.popoverPresentationController?.sourceView = self.view
            viewController.popoverPresentationController?.sourceRect = CGRect(x: self.view.frame.size.width / 2,
                                                                              y: self.view.frame.size.height / 2,
                                                                              width: 0, height: 0)
        }
        present(viewController, animated: true, completion: nil)
    }
    
    func rating(type: TheaterType, url: URL?) {
        guard let url = url else { return }
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
}

extension MovieView: MovieViewSegmentedControlChangeDelegate {
    func trackSelected(index: Int) {
        presenter.updateState(index)
    }
}

extension MovieView: ScrollToTopDelegate {
    func scrollToTop() {
        if collectionView != nil && !presenter.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
            }
        }
    }
}

extension MovieView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let id = dataSource.itemIdentifier(for: indexPath)?.id else { return }
        let destination = MovieDetailView.instance(id: id)
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let movie = dataSource.itemIdentifier(for: indexPath)
        let contextMenus = presenter.fetchContextMenus(item: movie)
        guard !contextMenus.isEmpty else { return nil }
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            UIMenu(title: "", image: nil, identifier: nil, children: contextMenus)
        }
    }
}

