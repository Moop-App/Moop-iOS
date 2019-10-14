//
//  Int+Extension.swift
//  Moop
//
//  Created by kor45cw on 2019/10/09.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import Foundation

extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value:self)) ?? ""
    }
    
    var ordinal: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter.string(from: NSNumber(value: self))
    }
}
