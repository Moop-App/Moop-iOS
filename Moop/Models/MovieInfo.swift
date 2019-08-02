//
//  MovieInfo.swift
//  Moop
//
//  Created by Chang Woo Son on 23/05/2019.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import Foundation
import UIKit

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

extension MovieInfo {
    var rank: Double {
        var count = 0
        var rank = 0
        if let cgvRank = cgv?.rank {
            rank += cgvRank
            count += 1
        }
        if let lotteRank = lotte?.rank {
            rank += lotteRank
            count += 1
        }
        if let megaboxRank = megabox?.rank {
            rank += megaboxRank
            count += 1
        }
        return Double(rank) / Double(count)
    }
    
    var getDay: Int {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        guard let date = formatter.date(from: openDate) else { return 999 }
        let today = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) ?? Date()
        let components = calendar.dateComponents([.day], from: today, to: date)
        return components.day ?? 999
    }
    
    var isBest: Bool {
        return (cgv?.isOver(96) ?? false) ||
            lotte?.isOver(8.8) ?? false ||
            megabox?.isOver(8.5) ?? false
    }
    
    var isNew: Bool {
        return isNow && isIn(dayRange: [Int](-6...0))
    }
    
    var isDDay: Bool {
        return !isNow && getDay != 999
    }
    
    var dDayText: String {
        return getDay <= 0 ? "NOW" : "D-\(getDay)"
    }
    
    func isIn(dayRange: [Int]) -> Bool {
        return dayRange.contains(getDay)
    }
    
    var ageType: AgeType {
        return AgeType(ageValue: ageValue)
    }
    
    var ageColor: UIColor {
        return ageType.color
    }
    
    var ageBadgeText: String {
        return ageType.text
    }
    
    var shareText: String {
        return "제목: \(title)\n개봉일: \(openDate)\n\(ageBadgeText)"
    }
    
    func contain(types: [TheaterType]) -> Bool {
        for type in types {
            switch type {
            case .cgv:
                if self.cgv == nil { return false }
            case .lotte:
                if self.lotte == nil { return false }
            case .megabox:
                if self.megabox == nil { return false }
            }
        }
        return true
    }
}
