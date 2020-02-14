//
//  MovieTimeData.swift
//  Moop
//
//  Created by kor45cw on 2020/02/14.
//  Copyright © 2020 kor45cw. All rights reserved.
//

import Foundation
import kor45cw_Extension

struct MovieTimeData {
    @UserDefault("CurrentUpdatedTime", defaultValue: "")
    static var currentUpdatedTime: String
    
    @UserDefault("FutureUpdatedTime", defaultValue: "")
    static var futureUpdatedTime: String
}
