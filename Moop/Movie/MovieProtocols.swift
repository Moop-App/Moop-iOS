//
//  MovieProtocols.swift
//  Moop
//
//  Created by kor45cw on 2019/10/12.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit

// View
// 1. Presenter로 사용자의 Event를 전달
// 2. Presenter에게 전달받은 결과를 통해서 View를 업데이트
protocol MovieViewDelegate: class {
    var presenter: MoviePresenterDelegate! { get set }
    func loadFinished()
    func loadFailed()
    func change(state: MoviePresenter.MovieType)
    func rating(type: TheaterType, url: URL?)
    func share(text: String)
}

// Presenter
// 1. View에게 전달받은 Event에 따라 Model의 데이터 처리요청
// 2. Model에게 전달받은 데이터를 기반으로 View에게 전달
// 데이터를 가공하는 역할은 여기서
protocol MoviePresenterDelegate: class {
    var view: MovieViewDelegate! { get set }
    var numberOfItemsInSection: Int { get }
    var isEmpty: Bool { get }
    subscript(indexPath: IndexPath) -> Movie? { get }
    
    func viewDidLoad()
    func updateState(_ index: Int)
    func fetchDatas()
    
    func fetchContextMenus(indexPath: IndexPath) -> [UIAction]
}

// Model
// 1. Presenter에게 요청받은 데이터를 반환
// 모델은 주로 데이터를 가져오거나 데이터를 저장하는 역할을 한다.
