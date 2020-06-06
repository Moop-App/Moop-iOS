//
//  ViewController.swift
//  Moop
//
//  Created by Chang Woo Son on 22/05/2019.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit
import AcknowList
import MessageUI
import CTFeedbackSwift

class SettingView: UIViewController {
    static func instance() -> SettingView {
        let vc: SettingView = instance(storyboardName: Storyboard.setting)
        vc.presenter = SettingPresenter(view: vc)
        return vc
    }
    
    var presenter: SettingPresenterDelegate!
    
    @IBOutlet private weak var 광고포장뷰: UIView!
    @IBOutlet private weak var bannerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tableView: UITableView!
    
    private var 광고모듈: AdManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        광고모듈 = AdManager(배너광고타입: .설정, viewController: self, wrapperView: 광고포장뷰, 전면광고타입: .설정, 네이티브광고타입: .상세)
        
        guard !UserData.isAdFree else {
            광고포장뷰.removeFromSuperview()
            return
        }
        광고모듈.delegate = self
        광고모듈.배너보여줘()
    }
    
    var canScrollToTop: Bool = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        canScrollToTop = true
        loadBannerAd()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        canScrollToTop = false
    }
    
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        
        coordinator.animate(alongsideTransition: { _ in
            self.loadBannerAd()
        })
    }
    
    func loadBannerAd() {
        guard !UserData.isAdFree else { return }
        let viewWidth = view.frame.inset(by: view.safeAreaInsets).size.width
        bannerViewHeightConstraint.constant = 광고모듈.resize배너(width: viewWidth)
    }
}

extension SettingView: SettingViewDelegate {
    func reload() {
        tableView.reloadData()
    }
}

extension SettingView: ScrollToTopDelegate {
    func scrollToTop() {
        if tableView != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                self.tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .none, animated: true)
            }
        }
    }
}

extension SettingView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        presenter.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfItemsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let (section, item) = presenter[indexPath] else { return UITableViewCell() }
        
        switch (section, item) {
        case (_, .header):
            let cell: SettingHeaderCell = tableView.dequeueReusableCell(for: indexPath)
            cell.set(section.title)
            return cell
        case (_, .footer):
            let cell: SettingFooterCell = tableView.dequeueReusableCell(for: indexPath)
            cell.set(section.footer)
            return cell
        case (.inApp, _):
            let cell: SettingCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setAd(item)
            return cell
        case (.etc, _):
            let cell: SettingCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setETC(item)
            return cell
        }
    }
    
}

extension SettingView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let (section, item) = presenter[indexPath] else { return }
        
        switch (section, item) {
        case (.inApp, .showAd):
            광고모듈.전면광고보여줘(isRandom: false)
        case (.inApp, .inApp):
            presenter.purchase(with: item.productId)
        case (.inApp, .restore):
            presenter.restore()
        case (.etc, .showMap):
            self.performSegue(withIdentifier: "toMaps", sender: self)
        case (.etc, .openSource):
            let path = Bundle.main.path(forResource: "Pods-Moop-acknowledgements", ofType: "plist")
            let viewController = AcknowListViewController(acknowledgementsPlistPath: path)
            navigationController?.pushViewController(viewController, animated: true)
        case (.etc, .bugReport):
            if MFMailComposeViewController.canSendMail() {
                let configuration = FeedbackConfiguration(toRecipients: ["kor45cw@gmail.com"], hidesUserEmailCell: false, usesHTML: false)
                let controller    = FeedbackViewController(configuration: configuration)
                navigationController?.pushViewController(controller, animated: true)
            } else {
                UIPasteboard.general.string = "kor45cw@gmail.com"
                let alert = UIAlertController(title: "메일 주소 복사 완료".localized, message: "클립보드에 저장된 이메일로 문의주세요".localized, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인".localized, style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        case (.etc, .version):
            guard let cell = tableView.cellForRow(at: indexPath) as? SettingCell,
                let url = URL(string: "itms-apps://itunes.apple.com/app/id1464896856") else { return }
            if cell.isUpdatable,  UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        default: return
        }
    }
}

extension SettingView: AdManagerDelegate {
    func 배너광고Loaded() {
        loadBannerAd()
    }
}
