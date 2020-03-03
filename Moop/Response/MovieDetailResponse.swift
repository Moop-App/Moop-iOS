//
//  MovieDetailResponse.swift
//  Moop
//
//  Created by kor45cw on 2020/03/01.
//  Copyright © 2020 kor45cw. All rights reserved.
//

import Foundation

struct MovieDetailResponse: Decodable {
    let id: String
    let score: Int
    let title: String
    let posterUrl: String
    let openDate: String
    let now: Bool
    let age: Int
    let nationFilter: [String]?
    let genres: [String]?
    let boxOffice: BoxOfficeResponse?
    let showTm: Int?
    let nations: [String]?
    let directors: [String]?
    let actors: [String]?
    let companies: [String]?
    let cgv: TheaterResponse?
    let lotte: TheaterResponse?
    let megabox: TheaterResponse?
    let naver: TheaterResponse?
    let imdb: TheaterResponse?
    let rt: TheaterResponse?
    let mc: TheaterResponse?
    let plot: String?
    let trailers: [TrailerResponse]
}

struct BoxOfficeResponse: Decodable {
    let rank: Int
    let audiCnt: Int
    let audiAcc: Int
}

struct TheaterResponse: Decodable {
    let id: String?
    let star: String
    let url: String?
}

struct TrailerResponse: Decodable {
    let youtubeId: String
    let title: String
    let author: String
    let thumbnailUrl: String
}
