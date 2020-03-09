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
    
    func updatedCurrentVersion()
}

protocol SettingPresenterDelegate: class {
    var view: SettingViewDelegate! { get set }
    var isEmpty: Bool { get }
    var itemCount: Int { get }
    var numberOfItemsInSection: Int { get }
    subscript(_ index: Int) -> (title: String, description: String, isInApp: Bool)? { get }


    func viewDidLoad()
    func rowHeight(_ indexPath: IndexPath) -> CGFloat
    func restoreIAP(completionHandler: @escaping (Bool) -> Void)
}
