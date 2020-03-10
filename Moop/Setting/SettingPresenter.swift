//
//  SettingPresenter.swift
//  Moop
//
//  Created by kor45cw on 2020/03/09.
//  Copyright © 2020 kor45cw. All rights reserved.
//

import Foundation
import SwiftyStoreKit

class SettingPresenter {
    internal weak var view: SettingViewDelegate!
    
    private let datas = SettingSection.allCases
    private var currentVersion = ""
    
    init(view: SettingViewDelegate) {
        self.view = view
    }
    
    var isEmpty: Bool {
        datas.isEmpty
    }
    
    var itemCount: Int {
        datas.count
    }
    
    var numberOfItemsInSection: Int {
        if UserData.isAdFree {
            return (datas.count - 1) * 3
        }
        return datas.count * 3
    }
    
    subscript(index: Int) -> (title: String, description: String, isInApp: Bool)? {
        guard let data = datas[safe: index] else { return nil }
        
        let description = "\(data.description)" + (data == .version ? " / \("최신".localized) \(currentVersion)" : "")
        return (data.title, description, data == .inapp)
    }
}

extension SettingPresenter: SettingPresenterDelegate {
    func viewDidLoad() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.currentVersion = self.currentAppstoreVersion() ?? ""
            DispatchQueue.main.async {
                self.view.updatedCurrentVersion()
            }
        }
    }
    
    func rowHeight(_ indexPath: IndexPath) -> CGFloat {
        indexPath.item % 3 == 2 ? 11 : 60
    }
    
    func restoreIAP(completionHandler: @escaping (Bool) -> Void) {
        SwiftyStoreKit.restorePurchases { result in
            completionHandler(result.restoredPurchases.count == 1)
        }
    }
    
    private func currentAppstoreVersion() -> String? {
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
}
