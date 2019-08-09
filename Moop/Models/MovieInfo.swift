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
    
    var releaseDate: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.date(from: openDate) ?? Date()
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
        // [.megabox] -> 메가박스 있는 것이면 뭐든
        // [.cgv, .megabox] -> 롯데시네마만 있는것 제외
        switch types.count {
        case 2:
            let removeTarget = TheaterType.allCases.filter { !types.contains($0) }.first!
            return !onlyOne(theater: removeTarget)
        case 1:
            return self.contain(theater: types.first!)
        default:
            return true
        }
    }
    
    func onlyOne(theater: TheaterType) -> Bool {
        switch theater {
        case .cgv:
            return cgv != nil && lotte == nil && megabox == nil
        case .lotte:
            return cgv == nil && lotte != nil && megabox == nil
        case .megabox:
            return cgv == nil && lotte == nil && megabox != nil
        case .naver: return false
        }
    }
    
    func contain(theater: TheaterType) -> Bool {
        switch theater {
        case .cgv:
            return cgv != nil
        case .lotte:
            return lotte != nil
        case .megabox:
            return megabox != nil
        case .naver:
            return false
        }
    }
    
    func contain(ages: [AgeType]) -> Bool {
        return ages.contains(self.ageType)
    }
}
