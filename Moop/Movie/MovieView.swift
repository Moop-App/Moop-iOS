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
    static func instance() -> MovieView {
        let vc: MovieView = instance(storyboardName: Storyboard.movie)
        vc.presenter = MoviePresenter(view: vc)
        return vc
    }
    
    var presenter: MoviePresenterDelegate!

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
    func loadFinished() {
        refreshControl.endRefreshing()
        collectionView.reloadData()
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

extension MovieView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.numberOfItemsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MovieCell else { return UICollectionViewCell() }
        cell.set(presenter[indexPath])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let id = presenter[indexPath]?.id else { return }
        let destination = MovieDetailView.instance(id: id)
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var header: UICollectionReusableView?

        if kind == UICollectionView.elementKindSectionHeader,
            let segmentedHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MovieViewSegmentedControl", for: indexPath) as? MovieViewSegmentedControl {
            segmentedHeader.delegate = self
            header = segmentedHeader
        }

        return header!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 38)
    }
}

extension MovieView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // TODO: 아이패드에서는 한줄에 더 많은 셀이 나와야 한다. 5개 정도
        let cellWidth = (collectionView.bounds.width - 36) / 3
        return CGSize(width: cellWidth, height: cellWidth / 600.0 * 855)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let contextMenus = presenter.fetchContextMenus(indexPath: indexPath)
        guard !contextMenus.isEmpty else { return nil }
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            UIMenu(title: "", image: nil, identifier: nil, children: contextMenus)
        }
    }
}

