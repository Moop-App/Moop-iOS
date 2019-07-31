//
//  CurrentMoviePresenter.swift
//  Moop
//
//  Created by Chang Woo Son on 2019/06/23.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import Foundation
import Alamofire

class CurrentMoviePresenter {
    var movieData: CurrentMovieData
    weak var view: CurrentMovieViewDelegate!
    
    init(view: CurrentMovieViewDelegate) {
        self.view = view
        movieData = CurrentMovieData()
    }
    
    var numberOfItemsInSection: Int {
        return movieData.items.count
    }
    
    var isEmpty: Bool {
        return movieData.items.isEmpty
    }
    
    subscript(indexPath: IndexPath) -> MovieInfo? {
        return movieData.items[indexPath.item]
    }
}

extension CurrentMoviePresenter: CurrentMoviePresenterDelegate {
    func fetchDatas() {
        let requestURL = URL(string: "\(Config.baseURL)/now/list.json")!
        AF.request(requestURL)
            .validate(statusCode: [200])
            .responseDecodable { [weak self] (response: DataResponse<[MovieInfo]>) in
                guard let self = self else { return }
                switch response.result {
                case .success(let result):
                    self.movieData.update(items: result)
                    self.view.loadFinished()
                case .failure(let error):
                    print(error.localizedDescription)
                    self.view.loadFailed()
                }
        }
    }
}
