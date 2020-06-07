//
//  AlarmViewController.swift
//  Moop
//
//  Created by Chang Woo Son on 23/07/2019.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit
import SafariServices

class AlarmView: UIViewController {
    enum Section: CaseIterable {
        case main
    }
    
    static func instance() -> AlarmView {
        let vc: AlarmView = instance(storyboardName: Storyboard.alarm)
        vc.presenter = AlarmPresenter(view: vc)
        return vc
    }
    
    var presenter: AlarmPresenterDelegate!
    var dataSource: UICollectionViewDiffableDataSource<Section, Movie>!

    @IBOutlet private weak var emptyLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.register(MovieCell.self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        collectionView.collectionViewLayout = createdLayout()
    }
    
    var canScrollToTop: Bool = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        canScrollToTop = true
        presenter.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        canScrollToTop = false
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Movie>(collectionView: collectionView) { (collectionView, indexPath, movie) -> UICollectionViewCell? in
            let cell: MovieCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.set(movie, isFavorite: true)
            return cell
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
            
            return section
        }
    }
}

extension AlarmView: ScrollToTopDelegate {
    func scrollToTop() {
        if collectionView != nil && !presenter.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
            }
        }
    }
}

extension AlarmView: AlarmViewDelegate {
    func loadFinished(_ movies: [Movie]) {
        collectionView.isHidden = movies.isEmpty
        emptyLabel.isHidden = !movies.isEmpty
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
        snapshot.appendSections([.main])
        snapshot.appendItems(movies)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func loadFailed() {
        
    }
}

extension AlarmView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let id = dataSource.itemIdentifier(for: indexPath)?.id else { return }
        let destination = MovieDetailView.instance(id: id)
        self.navigationController?.pushViewController(destination, animated: true)
    }
}
