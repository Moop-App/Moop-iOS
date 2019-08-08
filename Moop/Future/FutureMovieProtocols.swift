//
//  FutureMovieProtocols.swift
//  Moop
//
//  Created by kor45cw on 08/08/2019.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import Foundation

protocol FutureMovieViewDelegate: class {
    var presenter: FutureMoviePresenterDelegate! { get set }
    func loadFinished()
    func loadFailed()
}

protocol FutureMoviePresenterDelegate: class {
    var view: FutureMovieViewDelegate! { get set }
    var numberOfItemsInSection: Int { get }
    var isEmpty: Bool { get }
    subscript(indexPath: IndexPath) -> MovieInfo? { get }
    func fetchDatas()
}
