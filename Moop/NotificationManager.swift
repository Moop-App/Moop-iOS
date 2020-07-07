//
//  NotificationManager.swift
//  Moop
//
//  Created by Chang Woo Son on 2019/06/22.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit
import FirebaseMessaging
import UserNotifications

class NotificationManager: NSObject {
    static let shared = NotificationManager()
    let gcmMessageIDKey = "gcm.message_id"
    
    private override init() { }
    
    func register() {
        // [START set_messaging_delegate]
        Messaging.messaging().delegate = self
        // [END set_messaging_delegate]
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (_, error) in
            guard error == nil else { return }
            DispatchQueue.main.async(execute: {
                UIApplication.shared.registerForRemoteNotifications()
            })
        }
    }
    
    public func addNotification(item: Movie?) {
        guard let item = item else { return }
        let content = UNMutableNotificationContent()
        content.title = "오늘개봉작".localized
        content.body = "\(item.title)\n\("뭅에서확인하세요".localized)"
        content.sound = UNNotificationSound.default
        content.summaryArgument = "개봉한 영화 목록".localized
        content.summaryArgumentCount = 5
        
        let triggerDate = Calendar.current.dateComponents([.year,.month,.day], from: item.releaseDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: item.id, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    public func removeNotification(item: Movie?) {
        guard let item = item else { return }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [item.id])
    }
    
    public func isAuthroized(completionHandler: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            completionHandler([.authorized, .provisional].contains(settings.authorizationStatus))
        }
    }
    
    public func unregisterNotification() {
        UIApplication.shared.unregisterForRemoteNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}

extension NotificationManager: MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        // let dataDict:[String: String] = ["token": fcmToken]
        // NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([.alert, .sound])
    }
    
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        // TODO: Notification click event
        // let identifier = response.notification.request.identifier
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
//        guard let currentViewController = UIApplication.shared.windows.first?.rootViewController else { return }
//
//        let settingsViewController = UIViewController()
//        settingsViewController.view.backgroundColor = .gray
//        currentViewController.present(settingsViewController, animated: true, completion: nil)
//    }
}
