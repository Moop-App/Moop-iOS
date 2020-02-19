//
//  MoviePresenter.swift
//  Moop
//
//  Created by kor45cw on 2019/10/12.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit
import RealmSwift
import Networking

class MoviePresenter: NSObject {
    internal weak var view: MovieViewDelegate!
    
    private let realm = try? Realm()
    private var notificationToken: NotificationToken?
    
    private var currentMovieData: [Movie] = []
    private var futureMovieData: [Movie] = []

    private var state: MovieType = .current {
        didSet {
            guard oldValue != state else { return }
            view.change(state: state)
            changedType()
        }
    }
    
    enum MovieType: Int {
        case current = 0
        case future
        
        var title: String {
            switch self {
            case .current:
                return "현재 상영".localized
            case .future:
                return "개봉 예정".localized
            }
        }
    }
        
    init(view: MovieViewDelegate) {
        self.view = view
        super.init()
        setupNotification()
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    private func setupNotification() {
        notificationToken = realm?.objects(Movie.self).observe { [weak self, weak view] changes in
            guard let self = self else { return }
            switch changes {
            case let .initial(results):
                self.currentMovieData = results.filter("now == true").sorted(byKeyPath: "score", ascending: true).compactMap { $0 }
                self.futureMovieData = results.filter("now == false").sorted(byKeyPath: "getDay").compactMap { $0 }
                view?.loadFinished()
            case let .update(results, _, _, _):
                self.currentMovieData = results.filter("now == true").sorted(byKeyPath: "score", ascending: true).compactMap { $0 }
                self.futureMovieData = results.filter("now == false").sorted(byKeyPath: "getDay").compactMap { $0 }
                view?.loadFinished()
            case let .error(error):
                print("An error occurred: \(error)")
            }
        }
    }
    
    
    var numberOfItemsInSection: Int {
        switch state {
        case .current:
            return currentMovieData.count
        case .future:
            return futureMovieData.count
        }
    }
    
    var isEmpty: Bool {
        switch state {
        case .current:
            return currentMovieData.isEmpty
        case .future:
            return futureMovieData.isEmpty
        }
    }
    
    subscript(indexPath: IndexPath) -> Movie? {
        switch state {
        case .current:
            return currentMovieData[safe: indexPath.item]
        case .future:
            return futureMovieData[safe: indexPath.item]
        }
    }
}

extension MoviePresenter: FilterChangeDelegate {
    func filterItemChanged() {
//        switch state {
//        case .current:
//            currentMovieData.filter()
//        case .future:
//            futureMovieData.filter()
//        }
        view.loadFinished()
    }
}

extension MoviePresenter: UISearchResultsUpdating, UISearchBarDelegate {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
//        self.isSearched = searchController.isActive
//        switch state {
//        case .current:
//            currentMovieData.search(query: searchController.searchBar.text ?? "")
//        case .future:
//            futureMovieData.search(query: searchController.searchBar.text ?? "")
//        }
        self.view.loadFinished()
    }
}

extension MoviePresenter: MoviePresenterDelegate {
    func viewDidLoad() {
        checkCurrentUpdateTime()
    }
    
    private func changedType() {
        switch state {
        case .current:
            if currentMovieData.isEmpty {
                checkCurrentUpdateTime()
            } else {
                view.loadFinished()
            }
        case .future:
            if futureMovieData.isEmpty {
                checkFutureUpdateTime()
            } else {
                view.loadFinished()
            }
        }
    }
    
    func fetchDatas() {
        switch state {
        case .current:
            checkCurrentUpdateTime()
            
        case .future:
            checkFutureUpdateTime()
        }
    }
    
    private func checkCurrentUpdateTime() {
        requestCurrentUpdateTime { [weak self, weak view] isUpdatedRequire in
            if isUpdatedRequire {
                self?.fetchCurrentDatas()
            } else {
                view?.loadFinished()
            }
        }
    }
    
    private func requestCurrentUpdateTime(completionHandler: @escaping (Bool) -> Void) {
        API.shared.requestCurrentUpdateTime { result in
            switch result {
            case .success(let updatedTime):
                completionHandler(MovieTimeData.currentUpdatedTime != updatedTime)
                MovieTimeData.currentUpdatedTime = updatedTime
            case .failure(let error):
                print("Error requestCurrentUpdateTime", error.localizedDescription)
            }
        }
    }
    
    private func fetchCurrentDatas() {
        MovieInfoManager.shared.requestCurrentData { [weak self] in
            guard let self = self else { return }
            let movies = MovieInfoManager.shared.currentDatas.map { Movie(response: $0) }
            if !movies.isEmpty {
                try? self.realm?.write {
                    self.realm?.delete(self.currentMovieData)
                    self.realm?.add(movies, update: .modified)
                }
            }
            self.view.loadFinished()
        }
    }
    
    private func checkFutureUpdateTime() {
           requestFutureUpdateTime { [weak self, weak view] isUpdatedRequire in
               if isUpdatedRequire {
                   self?.fetchFutureDatas()
               } else {
                   view?.loadFinished()
               }
           }
       }
    
    private func requestFutureUpdateTime(completionHandler: @escaping (Bool) -> Void) {
        API.shared.requestFutureUpdateTime { result in
            switch result {
            case .success(let updatedTime):
                completionHandler(MovieTimeData.futureUpdatedTime != updatedTime)
                MovieTimeData.futureUpdatedTime = updatedTime
            case .failure(let error):
                print("Error requestCurrentUpdateTime", error.localizedDescription)
            }
        }
    }
    
    private func fetchFutureDatas() {
        MovieInfoManager.shared.requestFutureData { [weak self] in
            guard let self = self else { return }
            let movies = MovieInfoManager.shared.futureDatas.map { Movie(response: $0) }
            if !movies.isEmpty {
                try? self.realm?.write {
                    self.realm?.delete(self.futureMovieData)
                    self.realm?.add(movies, update: .modified)
                }
            }
            self.view.loadFinished()
        }
    }
    
    func updateState(_ index: Int) {
        state = MovieType(rawValue: index) ?? .current
    }
}
