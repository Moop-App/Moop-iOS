//
//  CGVInfo.swift
//  Moop
//
//  Created by kor45cw on 02/08/2019.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import Foundation

struct CGVInfo: Decodable, BestCheckDelegate {
    let egg: String
    let id: String
    let rank: Int
    let specialTypes: [String]?
    
    func isOver(_ target: Double) -> Bool {
        guard !egg.isEmpty && egg != "?", let eggIntValue = Double(egg) else { return false }
        return eggIntValue >= target
    }
}
