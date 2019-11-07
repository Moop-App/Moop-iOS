//
//  MoviePresenter.swift
//  Moop
//
//  Created by kor45cw on 2019/10/12.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit

class MoviePresenter: NSObject {
    private let currentMovieData: MovieData
    private let futureMovieData: MovieData
    weak var view: MovieViewDelegate!
    private var isSearched: Bool = false
    private var state: MovieType = .current {
        didSet {
            guard oldValue != state else { return }
            view.change(state: state)
            filterItemChanged()
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
        currentMovieData = MovieData()
        futureMovieData = MovieData()
    }
    
    
    var numberOfItemsInSection: Int {
        switch state {
        case .current:
            return isSearched ? currentMovieData.searchedMovies.count : currentMovieData.filteredMovies.count
        case .future:
            return isSearched ? futureMovieData.searchedMovies.count : futureMovieData.filteredMovies.count
        }
    }
    
    var isEmpty: Bool {
        switch state {
        case .current:
            return isSearched ? currentMovieData.searchedMovies.isEmpty : currentMovieData.filteredMovies.isEmpty
        case .future:
            return isSearched ? futureMovieData.searchedMovies.isEmpty : futureMovieData.filteredMovies.isEmpty
        }
    }
    
    subscript(indexPath: IndexPath) -> MovieInfo? {
        switch state {
        case .current:
            return isSearched ? currentMovieData.searchedMovies[safe: indexPath.item] : currentMovieData.filteredMovies[safe: indexPath.item]
        case .future:
            return isSearched ? futureMovieData.searchedMovies[safe: indexPath.item] : futureMovieData.filteredMovies[safe: indexPath.item]
        }
    }
}

extension MoviePresenter: FilterChangeDelegate {
    func filterItemChanged() {
        switch state {
        case .current:
            currentMovieData.filter()
        case .future:
            futureMovieData.filter()
        }
        view.loadFinished()
    }
}

extension MoviePresenter: UISearchResultsUpdating, UISearchBarDelegate {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        self.isSearched = searchController.isActive
        switch state {
        case .current:
            currentMovieData.search(query: searchController.searchBar.text ?? "")
        case .future:
            futureMovieData.search(query: searchController.searchBar.text ?? "")
        }
        self.view.loadFinished()
    }
}


extension MoviePresenter: MoviePresenterDelegate {
    func fetchDatas(type: [MoviePresenter.MovieType]) {
        var targetType = type
        if type.isEmpty {
            targetType = [state]
        }
        let group = DispatchGroup()
        
        if targetType.contains(.current) {
            fetchCurrentDatas(group)
        }
        if targetType.contains(.future) {
            fetchFutureDatas(group)
        }
        
        
        group.notify(queue: .main) {
            self.filterItemChanged()
        }
    }
    
    private func fetchCurrentDatas(_ group: DispatchGroup? = nil) {
        group?.enter()
        MovieInfoManager.shared.requestCurrentData { [weak self] in
            guard let self = self else { return }
            self.currentMovieData.update(items: MovieInfoManager.shared.currentDatas, sortType: .rank)
            group?.leave()
        }
    }
    
    private func fetchFutureDatas(_ group: DispatchGroup? = nil) {
        group?.enter()
        MovieInfoManager.shared.requestFutureData { [weak self] in
            guard let self = self else { return }
            self.futureMovieData.update(items: MovieInfoManager.shared.futureDatas, sortType: .day)
            group?.leave()
        }
    }
    
    func updateState(_ index: Int) {
        state = MovieType(rawValue: index) ?? .current
    }
}
