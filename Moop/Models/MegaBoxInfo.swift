//
//  MegaBoxInfo.swift
//  Moop
//
//  Created by kor45cw on 02/08/2019.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import Foundation

struct MegaBoxInfo: Decodable, BestCheckDelegate {
    let id: String
    let rank: Int
    let star: String
    
    func isOver(_ target: Double) -> Bool {
        guard !star.isEmpty, let starIntValue = Double(star) else { return false }
        return starIntValue >= target
    }
}
