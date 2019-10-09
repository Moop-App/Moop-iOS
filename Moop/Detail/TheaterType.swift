//
//  TheaterType.swift
//  Moop
//
//  Created by kor45cw on 2019/10/09.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import Foundation

enum TheaterType: Int, Codable {
    case cgv = 0
    case lotte
    case megabox
    case naver
    
    var title: String {
        switch self {
        case .cgv:
            return "CGV"
        case .lotte:
            return "LOTTE"
        case .megabox:
            return "MegaBox"
        case .naver:
            return "Naver"
        }
    }
    
    init(type: String) {
        switch type {
        case "C": self = .cgv
        case "L": self = .lotte
        case "M": self = .megabox
        default: self = .cgv
        }
    }
    
    static var allCases: [TheaterType] {
        return [.cgv, .lotte, .megabox]
    }
}
