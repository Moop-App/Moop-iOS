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
import SwiftyStoreKit

class SettingView: UIViewController {
    static func instance() -> SettingView {
        let vc: SettingView = instance(storyboardName: Storyboard.setting)
        vc.presenter = SettingPresenter(view: vc)
        return vc
    }
    
    var presenter: SettingPresenterDelegate!
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(SettingHeaderCell.self)
            tableView.register(SettingItemCell.self)
            tableView.register(SettingDividerCell.self)
        }
    }

    var currentVersion: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserData.isAdFree {
            self.navigationItem.rightBarButtonItems = nil
        }
        presenter.viewDidLoad()
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
    
    @IBAction private func restore(_ sender: UIBarButtonItem) {
        presenter.restoreIAP { [weak self] isRestored in
            if isRestored {
                UserData.isAdFree = true
                self?.tableView.reloadData()
            }
        }
    }
}

extension SettingView: SettingViewDelegate {
    func updatedCurrentVersion() {
        tableView.reloadRows(at: [IndexPath(row: 7, section: 0)], with: .automatic)
    }
}

extension SettingView: ScrollToTopDelegate {
    func scrollToTop() {
        if tableView != nil && !presenter.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                self.tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .none, animated: true)
            }
        }
    }
}

extension SettingView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfItemsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowItem = indexPath.item % 3
        guard let (title, description, isInApp) = presenter[indexPath.item / 3] else { return UITableViewCell() }
        
        switch rowItem {
        case 0:
            let cell: SettingHeaderCell = tableView.dequeueReusableCell(for: indexPath)
            cell.titleLabel.text = title
            return cell
        case 1:
            let cell: SettingItemCell = tableView.dequeueReusableCell(for: indexPath)
            cell.descriptionLabel.text = description
            if isInApp {
                cell.requestInAppInfo()
            }
            return cell
        default:
            let cell: SettingDividerCell = tableView.dequeueReusableCell(for: indexPath)
            if indexPath.item + 1 == presenter.itemCount * 3 {
                cell.dividerView.backgroundColor = .clear
            }
            return cell
        }
    }
    
}

extension SettingView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        presenter.rowHeight(indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.item {
        case 1: // Theme
            break
        case 4: // MAP
            self.performSegue(withIdentifier: "toMaps", sender: self)
        case 7: // Version
            guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
                let url = URL(string: "itms-apps://itunes.apple.com/app/id1464896856") else { return }
            if appVersion == currentVersion { return }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        case 10: // Open Source
            let path = Bundle.main.path(forResource: "Pods-Moop-acknowledgements", ofType: "plist")
            let viewController = AcknowListViewController(acknowledgementsPlistPath: path)
            navigationController?.pushViewController(viewController, animated: true)
        case 13: // Feedback
            if MFMailComposeViewController.canSendMail() {
                let configuration = FeedbackConfiguration(toRecipients: ["kor45cw@gmail.com"], hidesUserEmailCell: false, usesHTML: false)
                let controller    = FeedbackViewController(configuration: configuration)
                navigationController?.pushViewController(controller, animated: true)
            } else {
                let url = URL(string: "http://pf.kakao.com/_xaPxkxau")
                if let url = url, UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:])
                }
            }
        case 16: // IN_APP
            SwiftyStoreKit.purchaseProduct(AdConfig.adFreeKey, quantity: 1, atomically: true) { [weak self] result in
                switch result {
                case .success:
                    UserData.isAdFree = true
                    self?.tableView.reloadData()
                case .error(let error):
                    print((error as NSError).localizedDescription)
                }
            }
        default:
            break
        }
    }
}

