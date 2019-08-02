//
//  TrailerInfo.swift
//  Moop
//
//  Created by kor45cw on 02/08/2019.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import Foundation

struct TrailerInfo: Decodable {
    let author: String
    let thumbnailUrl: String
    let title: String
    let youtubeId: String
}
