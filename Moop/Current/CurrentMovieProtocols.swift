//
//  CurrentMovieProtocols.swift
//  Moop
//
//  Created by Chang Woo Son on 2019/06/23.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import Foundation

protocol CurrentMovieViewDelegate: class {
    var presenter: CurrentMoviePresenterDelegate! { get set }
    func loadFinished()
    func loadFailed()
}

protocol CurrentMoviePresenterDelegate: class {
    var view: CurrentMovieViewDelegate! { get set }
    var numberOfItemsInSection: Int { get }
    var isEmpty: Bool { get }
    subscript(indexPath: IndexPath) -> MovieInfo? { get }
    func fetchDatas()
}
