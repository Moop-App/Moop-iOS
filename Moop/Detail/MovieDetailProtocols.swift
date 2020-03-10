//
//  MovieDetailProtocols.swift
//  Moop
//
//  Created by kor45cw on 2020/03/01.
//  Copyright © 2020 kor45cw. All rights reserved.
//

import UIKit

protocol MovieDetailViewDelegate: class {
    var presenter: MovieDetailPresenterDelegate! { get set }
    func loadFinished()
    func loadFailed()
    func rating(type: TheaterType, url: URL?)
    func share(text: String)
}

protocol MovieDetailPresenterDelegate: class {
    var view: MovieDetailViewDelegate! { get set }
    var numberOfItemsInSection: Int { get }
    var title: String { get }
    var movieInfo: Movie? { get }
    subscript(indexPath: IndexPath) -> MovieDetailCellType? { get }
    var adIndex: Array<Int>.Index? { get }
    var previewActionItems: [UIPreviewAction] { get }

    func viewDidLoad()
    func webURL(with type: TheaterType) -> URL?
}
