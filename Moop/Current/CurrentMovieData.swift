//
//  CurrentMovieData.swift
//  Moop
//
//  Created by Chang Woo Son on 2019/06/23.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import Foundation

struct CurrentMovieData {
    var items: [MovieInfo] = []
    var filteredMovies: [MovieInfo] = []
}

extension CurrentMovieData {
    mutating func update(items: [MovieInfo]) {
        self.items = items.sorted(by: { $0.rank < $1.rank })
    }
}

