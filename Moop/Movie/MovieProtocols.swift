//
//  MovieProtocols.swift
//  Moop
//
//  Created by kor45cw on 2019/10/12.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import Foundation
protocol MovieViewDelegate: class {
    var presenter: MoviePresenterDelegate! { get set }
    func loadFinished()
    func loadFailed()
    func change(state: MoviePresenter.MovieType)
}

protocol MoviePresenterDelegate: class {
    var view: MovieViewDelegate! { get set }
    var numberOfItemsInSection: Int { get }
    var isEmpty: Bool { get }
    subscript(indexPath: IndexPath) -> Movie? { get }
    
    func viewDidLoad()
    func updateState(_ index: Int)
    func fetchDatas()
}
