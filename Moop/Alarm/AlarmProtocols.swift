//
//  AlarmProtocols.swift
//  Moop
//
//  Created by kor45cw on 2020/06/05.
//  Copyright © 2020 kor45cw. All rights reserved.
//

import UIKit

protocol AlarmViewDelegate: class {
    var presenter: AlarmPresenterDelegate! { get set }
    func loadFinished(_ movies: [Movie])
    func loadFailed()
}

protocol AlarmPresenterDelegate: class {
    var view: AlarmViewDelegate! { get set }
    var isEmpty: Bool { get }
    
    func viewDidLoad()
}

