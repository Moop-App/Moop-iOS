//
//  MovieInfo.swift
//  Moop
//
//  Created by Chang Woo Son on 23/05/2019.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import Foundation

struct MovieInfo: Decodable {
    let age: String
    let ageValue: Int
    let cgv: CGVInfo?
    let id: String
    let isNow: Bool
    let lotte: LotteInfo?
    let megabox: MegaBoxInfo?
    let naver: NaverInfo?
    let openDate: String
    let posterUrl: String
    let title: String
    let trailers: [TrailerInfo]?
}

struct NaverInfo: Decodable {
    let link: String?
    let subtitle: String
    let title: String
    let userRating: String
}

struct MegaBoxInfo: Decodable {
    let id: String
    let rank: Int
    let star: String
}

struct LotteInfo: Decodable {
    let id: String
    let rank: Int
    let star: String // ex: 8.8
}

struct CGVInfo: Decodable {
    let egg: String
    let id: String
    let rank: Int
    let specialTypes: [String]?
}

struct TrailerInfo: Decodable {
    let author: String
    let thumbnailUrl: String
    let title: String
    let youtubeId: String
}
