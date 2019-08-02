//
//  AgeType.swift
//  Moop
//
//  Created by kor45cw on 02/08/2019.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit

enum AgeType: Int, Codable, CaseIterable {
    case over19 = 0
    case over15
    case over12
    case all
    case unknown
    
    init(ageValue: Int) {
        switch ageValue {
        case 19...: self = .over19
        case 15..<19: self = .over15
        case 12..<15: self = .over12
        case 0...: self = .all
        default: self = .unknown
        }
    }
}

extension AgeType {
    var color: UIColor {
        switch self {
        case .over19:
            return .red
        case .over15:
            return UIColor(hexString: "FFC107")
        case .over12:
            return .blue
        default:
            return .green
        }
    }
    
    var text: String {
        switch self {
        case .over19:
            return "청불"
        case .over15:
            return "15세"
        case .over12:
            return "12세"
        case .all:
            return "전체"
        case .unknown:
            return "미정"
        }
    }
}
