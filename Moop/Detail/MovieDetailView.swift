//
//  MovieDetailViewController.swift
//  Moop
//
//  Created by Chang Woo Son on 23/05/2019.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit
import StoreKit
import SafariServices
import GoogleMobileAds
import kor45cw_Extension

protocol MovieDetailPickAndPopDelegate: class {
    func share(text: String)
    func rating(type: TheaterType, id: String)
}

protocol DetailHeaderDelegate: class {
    func wrapper(type: TheaterType)
    func poster(_ image: UIImage)
}

class MovieDetailView: UIViewController {
    static func instance(id: String) -> MovieDetailView {
        let vc: MovieDetailView = instance(storyboardName: Storyboard.main)
        vc.presenter = MovieDetailPresenter(view: vc, moopId: id)
        return vc
    }
    
    var presenter: MovieDetailPresenterDelegate!
    
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(MovieInfoPlotCell.self)
            tableView.register(TrailerHeaderCell.self)
            tableView.register(TrailerCell.self)
            tableView.register(TrailerFooterCell.self)
            tableView.register(NaverInfoCell.self)
            tableView.register(TheaterCell.self)
            tableView.register(PosterWithInfoCell.self)
            tableView.register(BoxOfficeCell.self)
            tableView.register(ImdbCell.self)
            tableView.register(NativeAdCell.self)
        }
    }
    
    private var bannerView: GADBannerView!
    @IBOutlet private weak var bannerWrpperView: UIView!
    @IBOutlet private weak var bannerViewHeightConstraint: NSLayoutConstraint!
    private var adLoader: GADAdLoader!
    private var nativeAd: GADUnifiedNativeAd?
    
    weak var delegate: MovieDetailPickAndPopDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        configureAd()
        
        presenter.viewDidLoad()
        
//        guard let ids = UserDefaults.standard.array(forKey: .favorites) as? [String] else { return }
//        favoriteButton.tag = ids.contains(item?.id ?? "") ? 1 : 0
//        favoriteButton.setImage(favoriteButton.tag == 1 ? UIImage(named: "heart_fill") : UIImage(named: "heart"), for: .normal)
    }
    
    private func configureAd() {
        if UserDefaults.standard.bool(forKey: .adFree) {
            bannerWrpperView.removeFromSuperview()
            return
        }
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = AdConfig.bannderKey
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerWrpperView.addSubview(bannerView)
        
        adLoader = GADAdLoader(adUnitID: AdConfig.nativeAdKey,
                               rootViewController: self,
                               adTypes: [.unifiedNative],
                               options: nil)
        adLoader.delegate = self
        adLoader.load(GADRequest())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadBannerAd()
    }
    
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { _ in
            self.loadBannerAd()
        })
    }
    
    func loadBannerAd() {
        guard !UserDefaults.standard.bool(forKey: .adFree) else { return }
        let viewWidth = view.frame.inset(by: view.safeAreaInsets).size.width
        
        if bannerView != nil {
            bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
            bannerViewHeightConstraint.constant = bannerView.adSize.size.height
        }
        bannerView.load(GADRequest())
    }

    
    func isAllowedToOpenStoreReview() -> Bool {
        // 365일 내에 최대 3회까지 사용자에게만 표시된다는 사실을 알고있어야 합니다.
        // TODO: 1년 지난 후에는 체크 하는 로직 만들어야
        let launchCount = UserDefaults.standard.integer(forKey: .detailViewCount)
        let isOpen = launchCount == 3 || launchCount == 10 || launchCount == 20
        if launchCount == 3 {
            UserDefaults.standard.set(Date(), forKey: .firstReviewDate)
        }
        UserDefaults.standard.set((launchCount + 1), forKey: .detailViewCount)
        return isOpen
    }
    
    @IBAction private func share(_ sender: UIBarButtonItem) {
        share(sender: sender)
    }
    
    @IBAction private func favorite(_ sender: UIButton) {
        sender.tag = sender.tag == 0 ? 1 : 0
        sender.setImage(sender.tag == 1 ? UIImage(named: "heart_fill") : UIImage(named: "heart"), for: .normal)
        favorite(isAdd: sender.tag == 1)
    }
    
//    override var previewActionItems: [UIPreviewActionItem] {
//        let shareAction = UIPreviewAction(title: "Share", style: .default) { [weak self] (_, viewController) in
//            self?.delegate?.share(text: self?.item?.shareText ?? "")
//        }
//        let cgvAction = UIPreviewAction(title: "CGV", style: .default) { [weak self] (_, viewController) in
//            self?.delegate?.rating(type: .cgv, id: self?.item?.cgv?.id ?? "")
//        }
//        let lotteAction = UIPreviewAction(title: "LOTTE", style: .default) { [weak self] (_, _) in
//            self?.delegate?.rating(type: .lotte, id: self?.item?.lotte?.id ?? "")
//        }
//        let megaboxAction = UIPreviewAction(title: "MEGABOX", style: .default) { [weak self] (_, _) in
//            self?.delegate?.rating(type: .megabox, id: self?.item?.megabox?.id ?? "")
//        }
//        let naverAction = UIPreviewAction(title: "NAVER", style: .default) { [weak self] (_, _) in
//            self?.delegate?.rating(type: .naver, id: self?.item?.naver?.link ?? "")
//        }
//
//        return [shareAction, cgvAction, lotteAction, megaboxAction, naverAction]
//    }
}

extension MovieDetailView: DetailHeaderDelegate {
    func wrapper(type: TheaterType) {
//        let webURL: URL?
//        switch type {
//        case .cgv:
//            webURL = URL(string: "http://m.cgv.co.kr/WebApp/MovieV4/movieDetail.aspx?MovieIdx=\(item?.cgv?.id ?? "")")
//        case .lotte:
//            webURL = URL(string: "https://www.lottecinema.co.kr/NLCMW/movie/moviedetailview?movie=\(item?.lotte?.id ?? "")")
//        case .megabox:
//            webURL = URL(string: "http://m.megabox.co.kr/?menuId=movie-detail&movieCode=\(item?.megabox?.id ?? "")")
//        case .naver:
//            webURL = URL(string: item?.naver?.link ?? "")
//        }
        
//        guard let url = webURL else { return }
//        let safariViewController = SFSafariViewController(url: url)
//        present(safariViewController, animated: true, completion: nil)
    }
    
    func share(sender: UIBarButtonItem? = nil) {
        let viewController = UIActivityViewController(activityItems: [presenter.movieInfo?.shareText ?? ""], applicationActivities: [])
        if UIDevice.current.userInterfaceIdiom == .pad {
            if sender != nil {
                viewController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
            } else {
                viewController.popoverPresentationController?.sourceView = self.view
                viewController.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0,
                                                                                  width: self.view.frame.size.width / 2,
                                                                                  height: self.view.frame.size.height / 4)
            }
        }
        present(viewController, animated: true, completion: nil)
    }
    
    func favorite(isAdd: Bool) {
//        guard var array = UserDefaults.standard.array(forKey: .favorites) as? [String],
//            let itemId = item?.id else {
//                if isAdd {
//                    UserDefaults.standard.set([item?.id ?? ""], forKey: .favorites)
//                    NotificationManager.shared.addNotification(item: item)
//                }
//                return
//        }
//        if isAdd {
//            array.append(itemId)
//            NotificationManager.shared.addNotification(item: item)
//        } else if let index = array.firstIndex(of: itemId) {
//            array.remove(at: index)
//            NotificationManager.shared.removeNotification(item: item)
//        }
//        UserDefaults.standard.set(array, forKey: .favorites)
    }
    
    func poster(_ image: UIImage) {
        let posterViewController = PosterViewController.instance(image: image)
        posterViewController.modalPresentationStyle = .fullScreen
        self.present(posterViewController, animated: true)
    }
}

extension MovieDetailView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfItemsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellType = presenter[indexPath] else {
            return UITableViewCell()
        }
        
        switch cellType {
        case .header:
            let cell: PosterWithInfoCell = tableView.dequeueReusableCell(for: indexPath)
            cell.set(presenter.movieInfo)
            cell.delegate = self
            return cell
        case .boxOffice:
            let cell: BoxOfficeCell = tableView.dequeueReusableCell(for: indexPath)
            cell.set(presenter.movieInfo)
            return cell
        case .imdb:
            let cell: ImdbCell = tableView.dequeueReusableCell(for: indexPath)
            cell.set(presenter.movieInfo)
            return cell
        case .cgv:
            let cell: TheaterCell = tableView.dequeueReusableCell(for: indexPath)
            cell.set(presenter.movieInfo)
            cell.delegate = self
            return cell
        case .naver:
            let cell: NaverInfoCell = tableView.dequeueReusableCell(for: indexPath)
            cell.set(presenter.movieInfo?.naverInfo)
            cell.delegate = self
            return cell
        case .plot:
            let cell: MovieInfoPlotCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(presenter.movieInfo?.plot)
            return cell
        case .trailerHeader:
            let cell: TrailerHeaderCell = tableView.dequeueReusableCell(for: indexPath)
            cell.set(presenter.title)
            return cell
        case .trailer(let trailerInfo):
            let cell: TrailerCell = tableView.dequeueReusableCell(for: indexPath)
            cell.set(trailerInfo)
            return cell
        case .trailerFooter:
            let cell: TrailerFooterCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        case .ad:
            let cell: NativeAdCell = tableView.dequeueReusableCell(for: indexPath)
            cell.set(nativeAd)
            return cell
        }
    }
}

extension MovieDetailView: MovieDetailViewDelegate {
    func loadFinished() {
        self.title = presenter.title
        if isAllowedToOpenStoreReview() {
            SKStoreReviewController.requestReview()
        }
    }
    
    func loadFailed() {
        
    }
}

extension MovieDetailView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cellType = presenter[indexPath] else { return }
        
        switch cellType {
        case .boxOffice, .naver:
            wrapper(type: .naver)
        case .trailer(let trailerInfo):
            guard let youtubeURL = URL(string:"youtube://\(trailerInfo.youtubeId)"),
                let httpURL = URL(string:"https://www.youtube.com/watch?v=\(trailerInfo.youtubeId)") else { return }
            if UIApplication.shared.canOpenURL(youtubeURL) {
                UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.open(httpURL, options: [:], completionHandler: nil)
            }
        case .trailerFooter:
            let title = presenter.title.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            guard let httpURL = URL(string: "https://www.youtube.com/results?search_query=\(title ?? "")"),
                let youtubeURL = URL(string: "youtube://www.youtube.com/results?search_query=\(title ?? "")") else { return }
            if UIApplication.shared.canOpenURL(youtubeURL) {
                UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.open(httpURL, options: [:], completionHandler: nil)
            }
        default: break
        }
    }
}

extension MovieDetailView: GADBannerViewDelegate, GADUnifiedNativeAdLoaderDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        // Add banner to view and add constraints as above.
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
        })
    }
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        self.nativeAd = nativeAd
        self.nativeAd?.rootViewController = self
        
        
//        if totalCell.contains(where: { cellType in
//            switch cellType {
//            case .ad: return true
//            default: return false
//            }
//        }) {
//            return
//        }
//
//        guard let index = totalCell.firstIndex(where: { cellType in
//            switch cellType {
//            case .trailerHeader: return true
//            default: return false
//            }
//        }) else { return }
//        totalCell.insert(.ad, at: index+1)
//        tableView.beginUpdates()
//        tableView.insertRows(at: [IndexPath(item: index+1, section: 0)], with: .automatic)
//        tableView.endUpdates()
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        
    }
}
