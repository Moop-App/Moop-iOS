//
//  FutureMoviePresenter.swift
//  Moop
//
//  Created by kor45cw on 08/08/2019.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit

class FutureMoviePresenter: NSObject {
    private var movieData: FutureMovieData
    weak var view: FutureMovieViewDelegate!
    private var isSearched: Bool = false
    
    
    init(view: FutureMovieViewDelegate) {
        self.view = view
        movieData = FutureMovieData()
    }
    
    var numberOfItemsInSection: Int {
        return isSearched ? movieData.searchedMovies.count : movieData.filteredMovies.count
    }
    
    var isEmpty: Bool {
        return isSearched ? movieData.searchedMovies.isEmpty : movieData.filteredMovies.isEmpty
    }
    
    subscript(indexPath: IndexPath) -> MovieInfo? {
        return isSearched ? movieData.searchedMovies[indexPath.item] : movieData.filteredMovies[indexPath.item]
    }
}

extension FutureMoviePresenter: FilterChangeDelegate {
    func filterItemChanged() {
        movieData.filter()
        self.view.loadFinished()
    }
}

extension FutureMoviePresenter: UISearchResultsUpdating, UISearchBarDelegate {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        self.isSearched = searchController.isActive
        movieData.search(query: searchController.searchBar.text ?? "")
        self.view.loadFinished()
    }
}

extension FutureMoviePresenter: FutureMoviePresenterDelegate {
    func fetchDatas() {
        MovieInfoManager.shared.requestFutureData { [weak self] in
            guard let self = self else { return }
            self.movieData.update(items: MovieInfoManager.shared.futureDatas)
            self.filterItemChanged()
        }
    }
}
