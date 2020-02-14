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
    private let currentMovieData: [Movie]
    private let futureMovieData: [Movie]
    internal weak var view: MovieViewDelegate!
    private var isSearched: Bool = false
    private let realm = try? Realm()

    private var state: MovieType = .current {
        didSet {
            guard oldValue != state else { return }
            view.change(state: state)
            
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
        currentMovieData = realm?.objects(Movie.self).filter("now == true").compactMap { $0 } ?? []
        futureMovieData = realm?.objects(Movie.self).filter("now == false").compactMap { $0 } ?? []
        super.init()
    }
    
    
    var numberOfItemsInSection: Int {
        switch state {
        case .current:
            return currentMovieData.count
//            return isSearched ? currentMovieData.searchedMovies.count : currentMovieData.filteredMovies.count
        case .future:
            return 0
//            return isSearched ? futureMovieData.searchedMovies.count : futureMovieData.filteredMovies.count
        }
    }
    
    var isEmpty: Bool {
        switch state {
        case .current:
            return currentMovieData.isEmpty
//            return isSearched ? currentMovieData.searchedMovies.isEmpty : currentMovieData.filteredMovies.isEmpty
        case .future:
            return false
//            return isSearched ? futureMovieData.searchedMovies.isEmpty : futureMovieData.filteredMovies.isEmpty
        }
    }
    
    subscript(indexPath: IndexPath) -> Movie? {
        switch state {
        case .current:
            return currentMovieData[safe: indexPath.item]
//            return isSearched ? currentMovieData.searchedMovies[safe: indexPath.item] : currentMovieData.filteredMovies[safe: indexPath.item]
        case .future:
            return nil
//            return isSearched ? futureMovieData.searchedMovies[safe: indexPath.item] : futureMovieData.filteredMovies[safe: indexPath.item]
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
        self.isSearched = searchController.isActive
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
    func changeType() {
        
    }
    
    func fetchDatas(type: [MoviePresenter.MovieType]) {
//        var targetType = type
//        if type.isEmpty {
//            targetType = [state]
//        }
//        let group = DispatchGroup()
//
//        if targetType.contains(.current) {
//            fetchCurrentDatas(group)
//        }
//        if targetType.contains(.future) {
//            fetchFutureDatas(group)
//        }
//
//
//        group.notify(queue: .main) {
//            self.filterItemChanged()
//        }
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
            try? self.realm?.write {
                self.realm?.add(movies, update: .modified)
            }
//            self.currentMovieData.update(items: MovieInfoManager.shared.currentDatas, sortType: .rank)
        }
    }
    
    private func fetchFutureDatas() {
        MovieInfoManager.shared.requestFutureData { [weak self] in
            guard let self = self else { return }
//            self.futureMovieData.update(items: MovieInfoManager.shared.futureDatas, sortType: .day)
        }
    }
    
    func updateState(_ index: Int) {
        state = MovieType(rawValue: index) ?? .current
    }
}
