//
//  APISetupManager.swift
//  Networking
//
//  Created by kor45cw on 17/08/2019.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import FTLinearActivityIndicator
import AlamofireNetworkActivityIndicator

public struct APISetupManager {
    public static func setup() {
        UIApplication.configureLinearNetworkActivityIndicatorIfNeeded()
        NetworkActivityIndicatorManager.shared.isEnabled = true
    }
    
    internal static let currentRequestURL = URL(string: "\(Config.baseURL)/now/list.json")!
    internal static let futureRequestURL = URL(string: "\(Config.baseURL)/plan/list.json")!
}
