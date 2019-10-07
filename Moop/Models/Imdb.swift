//
//  imdb.swift
//  Moop
//
//  Created by kor45cw on 07/10/2019.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import Foundation

struct Imdb: Decodable {
    let imdb: String
    let imdbUrl: String?
    let mc: String?
    let rt: String?
}
