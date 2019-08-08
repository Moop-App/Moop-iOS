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
    case map
    case version
    case opensource
    case feedback
    
    var title: String {
        switch self {
        case .theme:
            return "테마".localized
        case .map:
            return "지도".localized
        case .version:
            return "버전".localized
        case .opensource:
            return "오픈소스".localized
        case .feedback:
            return "피드백".localized
        }
    }
    
    var description: String {
        switch self {
        case .theme:
            return "준비중입니다".localized
        case .map:
            return "지도확인하기".localized
        case .version:
            guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return "" }
            return "\("현재".localized) \(appVersion)"
        case .opensource:
            return "자세히보기".localized
        case .feedback:
            return "개발자에게버그신고하기".localized
        }
    }
}

class SettingViewController: UIViewController {
    static func instance() -> SettingViewController {
        let vc: SettingViewController = instance(storyboardName: .setting)
        return vc
    }
    
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(SettingHeaderCell.self)
            tableView.register(SettingItemCell.self)
            tableView.register(SettingDividerCell.self)
        }
    }

    let datas = SettingSection.allCases
    var currentVersion: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.currentVersion = self.currentAppstoreVersion() ?? ""
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [IndexPath(row: 4, section: 0)], with: .automatic)
            }
        }
    }
    
    func currentAppstoreVersion() -> String? {
        guard let info = Bundle.main.infoDictionary,
            let identifier = info["CFBundleIdentifier"] as? String,
            let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(identifier)") else {
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
            let cell: SettingHeaderCell = tableView.dequeueReusableCell(for: indexPath)
            cell.titleLabel.text = datas[indexPath.item / 3].title
            return cell
        case 1:
            let cell: SettingItemCell = tableView.dequeueReusableCell(for: indexPath)
            let item = datas[indexPath.item / 3]
            cell.descriptionLabel.text = "\(item.description)" + (item == .version ? " / \("최신".localized) \(currentVersion)" : "")
            return cell
        default:
            let cell: SettingDividerCell = tableView.dequeueReusableCell(for: indexPath)
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
        default:
            break
        }
    }
}

