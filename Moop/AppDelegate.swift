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
        ShortcutManager.shared.application(didFinishLaunchingWithOptions: launchOptions)
        RemoteNotificationManager.shared.register(application)
        return true
    }
    
    /// - Tag: PerformAction
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        ShortcutManager.shared.application(performActionFor: shortcutItem)
    }
    
    /// - Tag: DidBecomeActive
    func applicationDidBecomeActive(_ application: UIApplication) {
        ShortcutManager.shared.applicationDidBecomeActive(rootViewController: window?.rootViewController)
    }
    
    /// - Tag: WillResignActive
    func applicationWillResignActive(_ application: UIApplication) {
        ShortcutManager.shared.applicationWillResignActive(application)
    }

}

