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
        return (cgv?.eggIsOver(96) ?? false) ||
            lotte?.starIsOver(8.8) ?? false ||
            megabox?.starIsOver(8.5) ?? false
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
    
    var ageColor: UIColor {
        switch ageValue {
        case 19...:
            return .red
        case 15..<19:
            return UIColor(hexString: "FFC107")
        case 12..<15:
            return .blue
        default:
            return .green
        }
    }
    
    var ageBadgeText: String {
        switch ageValue {
        case 19...:
            return "청불"
        case 15..<19:
            return "15세"
        case 12..<15:
            return "12세"
        default:
            return "전체"
        }
    }
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
    
    func starIsOver(_ target: Double) -> Bool {
        guard !star.isEmpty, let starIntValue = Double(star) else { return false }
        return starIntValue >= target
    }
}

struct LotteInfo: Decodable {
    let id: String
    let rank: Int
    let star: String // ex: 8.8
    
    func starIsOver(_ target: Double) -> Bool {
        guard !star.isEmpty, let starIntValue = Double(star) else { return false }
        return starIntValue >= target
    }
}

struct CGVInfo: Decodable {
    let egg: String
    let id: String
    let rank: Int
    let specialTypes: [String]?
    
    func eggIsOver(_ target: Int) -> Bool {
        guard !egg.isEmpty && egg != "?", let eggIntValue = Int(egg) else { return false }
        return eggIntValue >= target
    }
}

struct TrailerInfo: Decodable {
    let author: String
    let thumbnailUrl: String
    let title: String
    let youtubeId: String
}
