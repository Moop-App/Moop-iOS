//
//  MovieResponse.swift
//  Moop
//
//  Created by Chang Woo Son on 23/05/2019.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import Foundation
import UIKit

struct MovieResponse: Decodable {
    let id: String
    let score: Int
    let title: String
    let posterUrl: String
    let openDate: String
    let now: Bool
    let age: Int
    let nationFilter: [String]?
    let genres: [String]?
    let boxOffice: Int?
    let theater: [String: String]
}

extension MovieResponse {
    var getDay: Int {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        guard let date = formatter.date(from: openDate) else { return 999 }
        let today = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) ?? Date()
        let components = calendar.dateComponents([.day], from: today, to: date)
        return components.day ?? 999
    }
}
