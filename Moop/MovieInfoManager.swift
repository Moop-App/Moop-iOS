//
//  MovieInfoManager.swift
//  Moop
//
//  Created by Chang Woo Son on 24/07/2019.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import Foundation
import Networking

class MovieInfoManager {
    static let shared: MovieInfoManager = MovieInfoManager()
    private init() { }
    
    var currentDatas: [MovieInfo] = []
    var futureDatas: [MovieInfo] = []
    
    func requestCurrentData(completionHandler: (() -> Void)? = nil) {
        API.shared.requestCurrent { [weak self] (result: Result<[MovieInfo], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                self.currentDatas = result.sorted(by: { $0.rank < $1.rank })
                completionHandler?()
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler?()
            }
        }
    }
    
    func requestFutureData(completionHandler: (() -> Void)? = nil) {
        API.shared.requestFuture { [weak self] (result: Result<[MovieInfo], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                self.futureDatas = result.sorted(by: { $0.rank < $1.rank })
                completionHandler?()
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler?()
            }
        }
    }
    
    func favorites() -> [MovieInfo] {
        guard let ids = UserDefaults.standard.array(forKey: .favorites) as? [String] else { return [] }
        var infos: [MovieInfo] = []
        
        infos.append(contentsOf: currentDatas.filter({ ids.contains($0.id) }))
        infos.append(contentsOf: futureDatas.filter({ ids.contains($0.id) }))

        return infos
    }
}
