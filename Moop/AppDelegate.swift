//
//  AppDelegate.swift
//  Moop
//
//  Created by Chang Woo Son on 22/05/2019.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import Firebase
import FTLinearActivityIndicator
import AlamofireNetworkActivityIndicator
import SDWebImage

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        Fabric.with([Crashlytics.self])
        UIApplication.configureLinearNetworkActivityIndicatorIfNeeded()
        NetworkActivityIndicatorManager.shared.isEnabled = true
        return true
    }
}

