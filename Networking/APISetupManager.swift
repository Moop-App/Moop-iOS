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
    
    internal static let currentRequestURL = "\(Config.baseURL)/\(Config.Version.v2.rawValue)/now/list.json"
    internal static let futureRequestURL = "\(Config.baseURL)/\(Config.Version.v2.rawValue)/plan/list.json"
    internal static let locationRequestURL = "\(Config.baseURL)/\(Config.Version.v1.rawValue)/code.json"
    internal static let currentLastUpdatedTimeRequestURL = "\(Config.baseURL)/\(Config.Version.v2.rawValue)/now/lastUpdateTime.json"
    internal static let futureLastUpdatedTimeRequestURL = "\(Config.baseURL)/\(Config.Version.v2.rawValue)/plan/lastUpdateTime.json"
}
