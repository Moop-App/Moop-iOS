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

enum SettingSection: CaseIterable {
    case theme
    case version
    case opensource
    case feedback
    
    var title: String {
        switch self {
        case .theme:
            return "Theme"
        case .version:
            return "Version"
        case .opensource:
            return "Open Source"
        case .feedback:
            return "Feedback"
        }
    }
    
    var description: String {
        switch self {
        case .theme:
            return "준비중입니다."
        case .version:
            guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return "" }
            return "Current \(appVersion)"
        case .opensource:
            return "자세히 보기"
        case .feedback:
            return "개발자에게 버그 신고하기"
        }
    }
}

class SettingViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            let headerNib = UINib(nibName: "SettingHeaderCell", bundle: nil)
            tableView.register(headerNib, forCellReuseIdentifier: "SettingHeaderCell")
            let itemNib = UINib(nibName: "SettingItemCell", bundle: nil)
            tableView.register(itemNib, forCellReuseIdentifier: "SettingItemCell")
            let dividerNib = UINib(nibName: "SettingDividerCell", bundle: nil)
            tableView.register(dividerNib, forCellReuseIdentifier: "SettingDividerCell")
        }
    }

    let datas = SettingSection.allCases
    var currentVersion: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global(qos: .background).async {
            self.currentVersion = self.currentAppstoreVersion() ?? ""
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [IndexPath(row: 4, section: 0)], with: .automatic)
            }
        }
    }
    
    func currentAppstoreVersion() -> String? {
        guard let info = Bundle.main.infoDictionary,
            let identifier = info["CFBundleIdentifier"] as? String,
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)") else {
                return nil
        }
        do {
            let data = try Data(contentsOf: url)
            guard let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] else { return nil }
            guard let result = (json["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String else { return nil }
            return version
        } catch {
            return nil
        }
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
}

extension SettingViewController: ScrollToTopDelegate {
    func scrollToTop() {
        if tableView != nil && !datas.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                self.tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .none, animated: true)
            }
        }
    }
}

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count * 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowItem = indexPath.item % 3
        switch rowItem {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingHeaderCell", for: indexPath) as! SettingHeaderCell
            cell.titleLabel.text = datas[indexPath.item / 3].title
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingItemCell", for: indexPath) as! SettingItemCell
            let item = datas[indexPath.item / 3]
            cell.descriptionLabel.text = "\(item.description)" + (item == .version ? " / Latest \(currentVersion)" : "")
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingDividerCell", for: indexPath) as! SettingDividerCell
            cell.dividerView.backgroundColor = indexPath.item + 1 == datas.count * 3 ? .clear : .groupTableViewBackground
            return cell
        }
    }
    
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowItem = indexPath.item % 3
        return rowItem == 2 ? 11 : 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.item {
        case 1: // Theme
            break
        case 4: // Version
            guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
                let url = URL(string: "itms-apps://itunes.apple.com/app/id1464896856") else { return }
            if appVersion == currentVersion { return }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        case 7: // Open Source
            let viewController = AcknowListViewController()
            navigationController?.pushViewController(viewController, animated: true)
        case 10: // Feedback
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
        default:
            break
        }
    }
}

