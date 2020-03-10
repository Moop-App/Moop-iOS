//
//  UserData.swift
//  Moop
//
//  Created by kor45cw on 2020/03/09.
//  Copyright © 2020 kor45cw. All rights reserved.
//

import Foundation
import kor45cw_Extension

struct UserData {
    @UserDefault("Ad_Free", defaultValue: false)
    static var isAdFree: Bool
    
    @UserDefault("Detail_View_Count", defaultValue: 0)
    static var detailViewCount: Int
    
    @UserDefault("First_Review_Date", defaultValue: Date())
    static var firstReviewDate: Date
}
