//
//  AppDelegate.swift
//  Home Aid
//
//  Created by Albrecht Oster on 23.02.18.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.alert, .sound]) { (granted, error) in }

        BeaconManager.shared.startMonitoringGeoRegion()
        BeaconManager.shared.approachingDoor {
            HomeAidManager.shared.openDoor(completion: { (error) in
                let content = UNMutableNotificationContent()
                content.sound = .default()

                if (error != nil) {
                    content.title = NSLocalizedString("beaconManager.doorInRangeError.title", comment: "")
                    content.body = NSLocalizedString("beaconManager.doorInRangeError.body", comment: "")

                } else {
                    content.title = NSLocalizedString("beaconManager.doorInRangeNotification.title", comment: "")
                    content.body = NSLocalizedString("beaconManager.doorInRangeNotification.body", comment: "")
                }

                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 20, repeats: false)
                let request = UNNotificationRequest(identifier: "doorInRange", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            })
        }

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
