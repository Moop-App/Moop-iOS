//
//  FilterModel.swift
//  Moop
//
//  Created by kor45cw on 2020/05/01.
//  Copyright © 2020 kor45cw. All rights reserved.
//

import Foundation

enum FilterSection: CaseIterable {
    case theater
    case age
    case boxOffice
    case nations
    
    var title: String {
        switch self {
        case .theater: return "Theaters".localized
        case .age: return "Age".localized
        case .boxOffice: return "BoxOffice".localized
        case .nations: return "Nations".localized
        }
    }
    
    var contents: [Item] {
        switch self {
        case .theater: return [.header, .cgv, .lotte, .megabox]
        case .age: return [.header, .over19, .over15, .over12, .all, .notDetermined]
        case .boxOffice: return [.header, .boxOffice]
        case .nations: return [.header, .korean, .etc]
        }
    }
    
    enum Item {
        case header
        case cgv, lotte, megabox
        case over19, over15, over12, all, notDetermined
        case boxOffice
        case korean, etc
        
        var title: String {
            switch self {
            case .cgv: return "CGV".localized
            case .lotte: return "LOTTE".localized
            case .megabox: return "MegaBox".localized
            case .over19: return "청불".localized
            case .over15: return "15세".localized
            case .over12: return "12세".localized
            case .all: return "전체".localized
            case .notDetermined: return "미정".localized
            case .boxOffice: return "박스오피스 순으로 정렬하기".localized
            case .korean: return "한국".localized
            case .etc: return "기타".localized
            default: return ""
            }
        }
    }
}
