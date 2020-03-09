//
//  FilterProtocols.swift
//  Moop
//
//  Created by kor45cw on 2020/03/09.
//  Copyright © 2020 kor45cw. All rights reserved.
//

import Foundation

protocol FilterViewDelegate: class {
    var presenter: FilterPresenterDelegate! { get set }
    func loadFinished()
    func updateDataInfo()
}

protocol FilterPresenterDelegate: class {
    var view: FilterViewDelegate! { get set }
    var isModalInPresentation: Bool { get }
    var isDoneButtonEnable: Bool { get }
    subscript(_ indexPath: IndexPath) -> (title: String, isSelected: Bool)? { get }

    func viewDidLoad()
    func done()
    func didSelect(with indexPath: IndexPath) -> Bool?
}
