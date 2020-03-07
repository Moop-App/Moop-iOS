//
//  MovieModel.swift
//  Moop
//
//  Created by kor45cw on 2019/10/12.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import Foundation

class MovieModel {
    var items: [Movie] = []
    var filteredMovies: [Movie] = []
    var searchedMovies: [Movie] = []
}

extension MovieModel {
    func search(query: String) {
        let jamoChoQuery = Jamo.getChos(query)
        let jamoQuery = Jamo.getJamo(query)
        if jamoChoQuery == jamoQuery {
            self.searchedMovies = filteredMovies.filter({ Jamo.getChos($0.title).contains(jamoChoQuery) })
        } else {
            self.searchedMovies = filteredMovies.filter({ Jamo.getJamo($0.title).contains(jamoQuery) })
        }
    }
    
    func filtered() {
        filteredMovies = items
            .filter { $0.contain(types: FilterData.theater) }
            .filter { $0.contain(ages: FilterData.age) }
        
        if FilterData.boxOffice {
            filteredMovies.sort(by: { $0.boxOfficeScore.value ?? 999 < $1.boxOfficeScore.value ?? 999 })
        }
        
        guard FilterData.nation.count == 1, let nation = FilterData.nation.first else { return }
        switch nation {
        case .korean:
            filteredMovies = filteredMovies.filter { $0.nationFilter.contains("K") }
        case .etc:
            filteredMovies = filteredMovies.filter { $0.nationFilter.contains("F") }
        }
    }
}
