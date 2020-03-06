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
        registerForPreviewing(with: self, sourceView: self.collectionView)
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
        let destination = FilterViewController.instance()
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
        let cellWidth = (collectionView.bounds.width - 36) / 3
        return CGSize(width: cellWidth, height: cellWidth / 600.0 * 855)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    @available(iOS 13.0, *)
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let contextMenus = presenter.fetchContextMenus(indexPath: indexPath)
        guard !contextMenus.isEmpty else { return nil }
        
        var menus: [UIAction] = []
        
        contextMenus.forEach {
            switch $0 {
            case let .text(shareText):
                menus.append(UIAction(title: "Share", image: UIImage(named: "share"), identifier: nil) { [weak self] _ in
                    guard let self = self else { return }
                    self.share(text: shareText)
                })
            case let .theater(type, id):
                menus.append(UIAction(title: type.title, image: nil, identifier: nil) { [weak self] _ in
                    guard let self = self else { return }
                    self.rating(type: type, id: id)
                })
            }
        }
        
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            UIMenu(title: "", image: nil, identifier: nil, children: menus)
        }
    }
}

extension MovieView: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = collectionView.indexPathForItem(at: location),
            let cell = collectionView.cellForItem(at: indexPath),
            let id = presenter[indexPath]?.id else { return nil }
        
        previewingContext.sourceRect = cell.frame
        let destination = MovieDetailView.instance(id: id)
        destination.delegate = self
        return destination
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
}

extension MovieView: MovieDetailPickAndPopDelegate {
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

    func rating(type: TheaterType, id: String) {
        let webURL: URL?
        switch type {
        case .cgv:
            webURL = URL(string: "http://m.cgv.co.kr/WebApp/MovieV4/movieDetail.aspx?MovieIdx=\(id)")
        case .lotte:
            webURL = URL(string: "http://www.lottecinema.co.kr/LCMW/Contents/Movie/Movie-Detail-View.aspx?movie=\(id)")
        case .megabox:
            webURL = URL(string: "http://m.megabox.co.kr/movie-detail?rpstMovieNo=\(id)")
        case .naver:
            webURL = URL(string: id)
        }

        guard let url = webURL else { return }
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
}

