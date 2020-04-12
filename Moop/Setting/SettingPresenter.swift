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
    
    private let datas = Section.allCases
    
    init(view: SettingViewDelegate) {
        self.view = view
    }
    
    var numberOfSections: Int {
        datas.count
    }
    
    subscript(indexPath: IndexPath) -> (section: Section, item: Section.Item)? {
        guard let section = datas[safe: indexPath.section],
            let item = section.contents[safe: indexPath.item] else { return nil }
        return (section, item)
    }
}

extension SettingPresenter: SettingPresenterDelegate {
    func numberOfItemsInSection(_ section: Int) -> Int {
        datas[safe: section]?.contents.count ?? 0
    }
    
    func rowHeight(_ indexPath: IndexPath) -> CGFloat {
        indexPath.item % 3 == 2 ? 11 : 60
    }
    
    func restoreIAP(completionHandler: @escaping (Bool) -> Void) {
        SwiftyStoreKit.restorePurchases { result in
            completionHandler(result.restoredPurchases.count == 1)
        }
    }
}
