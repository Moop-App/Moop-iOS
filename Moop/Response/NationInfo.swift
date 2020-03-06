//
//  NationInfo.swift
//  Moop
//
//  Created by kor45cw on 2019/11/11.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import Foundation

enum NationInfo: String, Codable, CaseIterable {
    case korean = "한국"
    case etc = "기타"
    
    init(isKorean: Bool) {
        self = isKorean ? .korean : .etc
    }
}
