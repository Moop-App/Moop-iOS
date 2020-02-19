//
//  Movie.swift
//  Moop
//
//  Created by kor45cw on 2020/02/13.
//  Copyright © 2020 kor45cw. All rights reserved.
//

import RealmSwift

class Movie: Object {
    @objc dynamic var id = ""
    @objc dynamic var score = 0 // Rank 가중치 (낮을수록 높은 순위)
    @objc dynamic var title = ""
    @objc dynamic var posterURL = ""
    @objc dynamic var openDate = ""
    @objc dynamic var now = false
    @objc dynamic var age = 0
    let nationFilter = List<String>()
    let genres = List<String>()
    let boxOffice = RealmOptional<Int>()
    @objc dynamic var cgv: String?
    @objc dynamic var lotte: String?
    @objc dynamic var megabox: String?
    @objc dynamic var getDay = 0

    override static func primaryKey() -> String? {
        return "id"
    }
    
    // 쿼리의 성능을 최적화 할때 활용 / 검색이나 필터링에 쓰는 종류들만 추가할 것
//    override static func indexedProperties() -> [String] {
//        return ["title"]
//    }
    
    convenience init(response: MovieResponse) {
        self.init()
        id = response.id
        score = response.score
        title = response.title
        posterURL = response.posterUrl
        openDate = response.openDate
        now = response.now
        age = response.age
        nationFilter.append(objectsIn: response.nationFilter ?? [])
        genres.append(objectsIn: response.genres ?? [])
        boxOffice.value = response.boxOffice
        cgv = response.theater["C"]
        lotte = response.theater["L"]
        megabox = response.theater["M"]
        getDay = response.getDay
    }
}

extension Movie {
    var releaseDate: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.date(from: openDate) ?? Date()
    }
    
    var isBest: Bool {
        isOver(target: cgv, value: 96) ||
            isOver(target: lotte, value: 8.8) ||
            isOver(target: megabox, value: 8.5)
    }
    
    func isOver(target: String?, value: Double) -> Bool {
        guard let target = target, !target.isEmpty, target != "?", let starIntValue = Double(target) else { return false }
        return starIntValue >= value
    }
    
    var isNew: Bool {
        now && isIn(dayRange: [Int](-6...0))
    }
    
    var isDDay: Bool {
        !now && getDay != 999
    }
    
    var dDayText: String {
        getDay <= 0 ? "NOW" : "D-\(getDay)"
    }
    
    func isIn(dayRange: [Int]) -> Bool {
        dayRange.contains(getDay)
    }
    
    var ageType: AgeType {
        AgeType(ageValue: age)
    }
    
    var ageColor: UIColor {
        ageType.color
    }
    
    var ageBadgeText: String {
        ageType.text
    }
    
    var shareText: String {
        "제목: \(title)\n개봉일: \(openDate)\n\(ageBadgeText)"
    }
    
    var genreText: String? {
        genres.joined(separator: ", ")
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
