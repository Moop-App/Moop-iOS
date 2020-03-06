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
    private var completionHandler: (() -> Void)?
    
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(reconnected(_:)),
                                               name: API.notificationName, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    var currentDatas: [MovieResponse] = []
    var futureDatas: [MovieResponse] = []
    
    @objc private func reconnected(_ notification: Notification) {
        guard let data = notification.userInfo?["data"] as? Data,
            let isCurrent = notification.userInfo?["isCurrent"] as? Bool else { return }
        do {
            let decodeDatas = try JSONDecoder().decode([MovieResponse].self, from: data)
            if isCurrent {
                self.currentDatas = decodeDatas.sorted(by: { $0.score < $1.score })
            } else {
                self.futureDatas = decodeDatas.sorted(by: { $0.score < $1.score })
            }
            completionHandler?()
        } catch {
            print("Decode fail")
        }
    }
    
    func requestCurrentData(completionHandler: (() -> Void)? = nil) {
        self.completionHandler = completionHandler
        API.shared.requestCurrent { [weak self] (result: Result<[MovieResponse], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                self.currentDatas = result
                completionHandler?()
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler?()
            }
        }
    }
    
    func requestFutureData(completionHandler: (() -> Void)? = nil) {
        self.completionHandler = completionHandler
        API.shared.requestFuture { [weak self] (result: Result<[MovieResponse], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                self.futureDatas = result
                completionHandler?()
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler?()
            }
        }
    }
    
    func favorites() -> [MovieResponse] {
        guard let ids = UserDefaults.standard.array(forKey: .favorites) as? [String] else { return [] }
        var infos: [MovieResponse] = []
        
        infos.append(contentsOf: currentDatas.filter({ ids.contains($0.id) }))
        infos.append(contentsOf: futureDatas.filter({ ids.contains($0.id) }))

        return infos
    }
}
