//
//  FilterData.swift
//  Moop
//
//  Created by kor45cw on 2019/11/11.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import Foundation
import kor45cw_Extension

struct FilterData {
    @UserDefaultCodable("Theater", defaultValue: TheaterType.allCases)
    static var theater: [TheaterType]
    
    @UserDefaultCodable("Age", defaultValue: AgeType.allCases)
    static var age: [AgeType]
    
    @UserDefault("BoxOffice", defaultValue: false)
    static var boxOffice: Bool
    
    @UserDefaultCodable("Nation", defaultValue: NationInfo.allCases)
    static var nation: [NationInfo]
}
