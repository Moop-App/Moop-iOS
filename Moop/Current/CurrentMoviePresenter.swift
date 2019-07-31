//
//  CurrentMoviePresenter.swift
//  Moop
//
//  Created by Chang Woo Son on 2019/06/23.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import Foundation
import Alamofire

class CurrentMoviePresenter: NSObject {
    private var movieData: CurrentMovieData
    weak var view: CurrentMovieViewDelegate!
    private var isSearched: Bool = false
    
    
    init(view: CurrentMovieViewDelegate) {
        self.view = view
        movieData = CurrentMovieData()
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

extension CurrentMoviePresenter: FilterChangeDelegate {
    func theaterChanged() {
        movieData.filter(types: UserDefaults.standard.object([TheaterType].self, forKey: .theater))
        self.view.loadFinished()
    }
}

extension CurrentMoviePresenter: UISearchResultsUpdating, UISearchBarDelegate {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        self.isSearched = searchController.isActive
        movieData.search(query: searchController.searchBar.text ?? "")
        self.view.loadFinished()
    }
}

extension CurrentMoviePresenter: CurrentMoviePresenterDelegate {
    func fetchDatas() {
        MovieInfoManager.shared.requestCurrentData { [weak self] in
            guard let self = self else { return }
            self.movieData.update(items: MovieInfoManager.shared.currentDatas)
            self.theaterChanged()
        }
    }
}
