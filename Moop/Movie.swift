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
    let boxOfficeScore = RealmOptional<Int>()
    @objc dynamic var cgv: String?
    @objc dynamic var lotte: String?
    @objc dynamic var megabox: String?
    @objc dynamic var getDay = 0

    @objc dynamic var boxOffice: BoxOffice?
    let showTm = RealmOptional<Int>()
    let nations = List<String>()
    let directors = List<String>()
    let actors = List<String>()
    let companies = List<String>()
    
    @objc dynamic var cgvInfo: Theater?
    @objc dynamic var lotteInfo: Theater?
    @objc dynamic var megaboxInfo: Theater?
    @objc dynamic var naverInfo: Theater?
    @objc dynamic var imdb: Theater?
    @objc dynamic var rt: Theater?
    @objc dynamic var mc: Theater?
    @objc dynamic var plot: String?
    
    let trailers = List<Trailer>()
    
    @objc dynamic var isUpdatedDetailInfo: Bool = false
    @objc dynamic var isAlarm: Bool = false
    
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
        boxOfficeScore.value = response.boxOffice
        cgv = response.theater["C"]
        lotte = response.theater["L"]
        megabox = response.theater["M"]
        getDay = response.getDay
    }
    
    convenience init(response: MovieDetailResponse) {
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
        
        boxOffice = response.boxOffice.map(BoxOffice.init)
        showTm.value = response.showTm
        nations.append(objectsIn: response.nations?.compactMap { $0 } ?? [])
        directors.append(objectsIn: response.directors?.compactMap { $0 } ?? [])
        actors.append(objectsIn: response.actors?.compactMap { $0 } ?? [])
        companies.append(objectsIn: response.companies?.compactMap { $0 } ?? [])
        
        cgvInfo = response.cgv.map(Theater.init)
        lotteInfo = response.lotte.map(Theater.init)
        megaboxInfo = response.megabox.map(Theater.init)
        naverInfo = response.naver.map(Theater.init)
        imdb = response.imdb.map(Theater.init)
        rt = response.rt.map(Theater.init)
        mc = response.mc.map(Theater.init)
        
        plot = response.plot

        trailers.append(objectsIn: response.trailers.map(Trailer.init))
        isUpdatedDetailInfo = true
    }
    
    func set(detailResponse: MovieDetailResponse) {
        boxOffice = detailResponse.boxOffice.map(BoxOffice.init)
        showTm.value = detailResponse.showTm
        nations.append(objectsIn: detailResponse.nations?.compactMap { $0 } ?? [])
        directors.append(objectsIn: detailResponse.directors?.compactMap { $0 } ?? [])
        actors.append(objectsIn: detailResponse.actors?.compactMap { $0 } ?? [])
        companies.append(objectsIn: detailResponse.companies?.compactMap { $0 } ?? [])
        
        cgvInfo = detailResponse.cgv.map(Theater.init)
        lotteInfo = detailResponse.lotte.map(Theater.init)
        megaboxInfo = detailResponse.megabox.map(Theater.init)
        naverInfo = detailResponse.naver.map(Theater.init)
        imdb = detailResponse.imdb.map(Theater.init)
        rt = detailResponse.rt.map(Theater.init)
        mc = detailResponse.mc.map(Theater.init)
        
        plot = detailResponse.plot

        trailers.append(objectsIn: detailResponse.trailers.map(Trailer.init))
        isUpdatedDetailInfo = true
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
    
    var genreText: String {
        genres.joined(separator: ", ")
    }
    
    var nationText: String {
        nations.joined(separator: ", ")
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


class BoxOffice: Object {
    @objc dynamic var rank: Int = 0
    @objc dynamic var audiCnt: Int = 0
    @objc dynamic var audiAcc: Int = 0
    
    convenience init(response: BoxOfficeResponse) {
        self.init()
        rank = response.rank
        audiCnt = response.audiCnt
        audiAcc = response.audiAcc
    }
}

class Theater: Object {
    @objc dynamic var id: String?
    @objc dynamic var star: String = ""
    @objc dynamic var url: String?
    
    convenience init(response: TheaterResponse) {
        self.init()
        id = response.id
        star = response.star
        url = response.url
    }
}

class Trailer: Object {
    @objc dynamic var author = ""
    @objc dynamic var thumbnailURL = ""
    @objc dynamic var title = ""
    @objc dynamic var youtubeId = ""
    
    convenience init(response: TrailerResponse) {
        self.init()
        author = response.author
        thumbnailURL = response.thumbnailUrl
        title = response.title
        youtubeId = response.youtubeId
    }
}
