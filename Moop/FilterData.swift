//
//  FilterData.swift
//  Moop
//
//  Created by kor45cw on 2019/11/11.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import Foundation

struct FilterData {
    @UserDefaultCodable(.theater, defaultValue: TheaterType.allCases)
    static var theater: [TheaterType]
    
    @UserDefaultCodable(.age, defaultValue: AgeType.allCases)
    static var age: [AgeType]
    
    @UserDefault(.boxOffice, defaultValue: false)
    static var boxOffice: Bool
    
    @UserDefaultCodable(.nation, defaultValue: NationInfo.allCases)
    static var nation: [NationInfo]
}
