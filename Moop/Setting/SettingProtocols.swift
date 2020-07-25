//
//  SettingProtocols.swift
//  Moop
//
//  Created by kor45cw on 2020/03/09.
//  Copyright © 2020 kor45cw. All rights reserved.
//

import UIKit

protocol SettingViewDelegate: class {
    var presenter: SettingPresenterDelegate! { get set }
    
    func reload()
}

protocol SettingPresenterDelegate: class {
    var view: SettingViewDelegate! { get set }
    var numberOfSections: Int { get }
    subscript(indexPath: IndexPath) -> (section: Section, item: Section.Item)? { get }

    func numberOfItemsInSection(_ section: Int) -> Int
    func purchase(with productId: String)
    func restore()
    func rateApp()
}
