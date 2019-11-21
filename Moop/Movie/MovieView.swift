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
            collectionView.delegate = self
            collectionView.dataSource = self
            refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
            collectionView.refreshControl = refreshControl
            collectionView.register(MovieCell.self)
            collectionView.register(MovieViewSegmentedControl.self,
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                    withReuseIdentifier: "MovieViewSegmentedControl")

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = MoviePresenter.MovieType.current.title
        searchController.searchResultsUpdater = presenter as? MoviePresenter
        searchController.searchBar.delegate = presenter as? MoviePresenter
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        navigationItem.searchController = searchController
        registerForPreviewing(with: self, sourceView: self.collectionView)
        presenter.fetchDatas(type: [.current, .future])
    }
    
    
    @objc private func requestData() {
        presenter.fetchDatas(type: [])
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
        collectionView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func loadFailed() {
        refreshControl.endRefreshing()
        // TODO: Fail Toast
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
        return presenter.numberOfItemsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MovieCell else { return UICollectionViewCell() }
        cell.set(presenter[indexPath])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destination = MovieDetailViewController.instance(item: presenter[indexPath])
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
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            let share = UIAction(title: "Share", image: UIImage(named: "share"), identifier: nil) { [weak self] _ in
                guard let self = self else { return }
                self.share(text: self.presenter[indexPath]?.shareText ?? "")
            }
            let cgv = UIAction(title: "CGV", image: nil, identifier: nil) { [weak self] _ in
                guard let self = self else { return }
                self.rating(type: .cgv, id: self.presenter[indexPath]?.cgv?.id ?? "")
            }

            let lotte = UIAction(title: "LOTTE", image: nil, identifier: nil) { [weak self] _ in
                guard let self = self else { return }
                self.rating(type: .lotte, id: self.presenter[indexPath]?.lotte?.id ?? "")
            }

            let megabox = UIAction(title: "MEGABOX", image: nil, identifier: nil) { [weak self] _ in
                guard let self = self else { return }
                self.rating(type: .megabox, id: self.presenter[indexPath]?.megabox?.id ?? "")
            }

            let naver = UIAction(title: "NAVER", image: nil, identifier: nil) { [weak self] _ in
                guard let self = self else { return }
                self.rating(type: .naver, id: self.presenter[indexPath]?.naver?.link ?? "")
            }
            
            return UIMenu(title: "", image: nil, identifier: nil, children: [share, cgv, lotte, megabox, naver])
        }
    }
}

extension MovieView: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = collectionView.indexPathForItem(at: location),
            let cell = collectionView.cellForItem(at: indexPath) else { return nil }
        
        previewingContext.sourceRect = cell.frame
        let destination = MovieDetailViewController.instance(item: presenter[indexPath])
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
            webURL = URL(string: "http://m.megabox.co.kr/?menuId=movie-detail&movieCode=\(id)")
        case .naver:
            webURL = URL(string: id)
        }
        
        guard let url = webURL else { return }
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
}

