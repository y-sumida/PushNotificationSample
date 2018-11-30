//
//  AppDelegate.swift
//  PushNotificationSample
//
//  Created by Yuki Sumida on 2018/11/24.
//  Copyright © 2018年 Yuki Sumida. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.sound, .alert, .badge], completionHandler: { (granted, error) in
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        })
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension AppDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var token = ""
        deviceToken.forEach {
            token.append(String(format: "%02.2hhx", arguments: [$0]))
        }
        print("deviceToken: ", token)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // リモートPUSHが"届いた"ときに呼ばれる
        // 通知をタップした時ではない
        handleNotification(userInfo: userInfo)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // 通知をタップした
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        handleNotification(userInfo: response.notification.request.content.userInfo)
        completionHandler()
    }

    // Foregroundで通知を受けた
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // 画面遷移とか、アラート表示とかする
        // 必要に応じて.alertを指定することでアプリ起動中にPUSH通知を表示させることもできる
        completionHandler(.alert)
    }

    func handleNotification(userInfo: [AnyHashable: Any]) {
        guard let dict = userInfo as? [String: Any] else { return }
        do {
            let json = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let notification = try JSONDecoder().decode(PushNotificationPayload.self, from: json)
            dump(notification)
        } catch let e {
            // エラー処理
            print(e)
        }

        let state = UIApplication.shared.applicationState
        switch state {
        case .active: print("active")// アクティブな時
        case .background: print("background")// バックグラウンドの時
        case .inactive: print("inactive")// "バックグラウンドで"通知をタップした時
        }
    }
}
