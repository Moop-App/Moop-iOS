//
//  AppDelegate.swift
//  Moop
//
//  Created by Chang Woo Son on 22/05/2019.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit
import Firebase
import Networking
import FBSDKCoreKit
#if DEBUG
import FLEX
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        librarySetup()
        debugSettings()
        ShortcutManager.shared.application(didFinishLaunchingWithOptions: launchOptions)
        NotificationManager.shared.register(application)
        return true
    }
    
    /// - Tag: PerformAction
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        ShortcutManager.shared.application(performActionFor: shortcutItem)
    }
    
    /// - Tag: DidBecomeActive
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEvents.activateApp()
        ShortcutManager.shared.applicationDidBecomeActive(rootViewController: window?.rootViewController)
    }
    
    /// - Tag: WillResignActive
    func applicationWillResignActive(_ application: UIApplication) {
        ShortcutManager.shared.applicationWillResignActive(application)
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        SpotlightManager.shared.application(continue: userActivity,
                                            rootViewController: window?.rootViewController)
        return true
    }
}

extension AppDelegate {
    private func librarySetup() {
        FirebaseApp.configure()
        AdManager.librarySetup()
        APISetupManager.setup()
        StoreKitManager.shared.setup()
    }
    
    private func debugSettings() {
        #if DEBUG
        FLEXManager.shared.showExplorer()
        #endif
    }
}
