//
//  MovieData.swift
//  Moop
//
//  Created by kor45cw on 2019/10/12.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import Foundation

class MovieData {
    var items: [MovieInfo] = []
    var filteredMovies: [MovieInfo] = []
    var searchedMovies: [MovieInfo] = []
    
    enum SortType {
        case rank
        case day
    }
}

extension MovieData {
    func update(items: [MovieInfo], sortType: SortType) {
        switch sortType {
        case .rank:
            self.items = items.sorted(by: { $0.rank < $1.rank })
        case .day:
            self.items = items.sorted(by: { $0.getDay < $1.getDay })
        }
    }
    
    func search(query: String) {
        let jamoChoQuery = Jamo.getChos(query)
        let jamoQuery = Jamo.getJamo(query)
        if jamoChoQuery == jamoQuery {
            self.searchedMovies = filteredMovies.filter({ Jamo.getChos($0.title).contains(jamoChoQuery) })
        } else {
            self.searchedMovies = filteredMovies.filter({ Jamo.getJamo($0.title).contains(jamoQuery) })
        }
    }
    
    func filter() {
        self.filteredMovies = items
            .filter { $0.contain(types: FilterData.theater) }
            .filter { $0.contain(ages: FilterData.age) }
        
        if FilterData.boxOffice {
            self.filteredMovies = filteredMovies.sorted(by: { $0.kobis?.boxOffice?.rank ?? 999 < $1.kobis?.boxOffice?.rank ?? 999 })
        }
        
        guard FilterData.nation.count == 1, let nation = FilterData.nation.first else { return }
        switch nation {
        case .korean:
            self.filteredMovies = self.filteredMovies.filter { $0.kobis?.nations?.first == "한국" }
        case .etc:
            self.filteredMovies = self.filteredMovies.filter { $0.kobis?.nations?.first != "한국" }
        }
    }
}
