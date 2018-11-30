//
//  AppDelegate.swift
//  Hourglass
//
//  Created by 김문옥 on 2018. 8. 3..
//  Copyright © 2018년 김문옥. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // sqlite 파일 위치 출력
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print("sqlite File Location : \(urls[urls.count-1] as URL)")
        
        // 내비게이션 바의 폰트 변경
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "GodoB", size: 18)!
        ]
        UINavigationBar.appearance().largeTitleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "GodoB", size: 30)!
        ]
        
        
        UIBarButtonItem.appearance().setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: "GodoM", size: 17)!
        ],for: UIControl.State.normal)

//        // 테마 적용
//        if UserDefaults.standard.bool(forKey: "themeSwitchState") {
//            application.statusBarStyle = .lightContent
//        } else {
//            application.statusBarStyle = .default
//        }
        
        // 유저에게 알림 허락(권한) 받기
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound], completionHandler: {didAllow, Error in
            print(didAllow)
            if didAllow {
                UserDefaults.standard.set(true, forKey: "alertSwitchState")
            } else {
                UserDefaults.standard.set(false, forKey: "alertSwitchState")
            }
        })
        
        // userDefaults 가 설정된 적이 한번도 없으면 기본값 설정하기
        if UserDefaults.standard.object(forKey: "alertSwitchState") == nil {
            
            UserDefaults.standard.set(false, forKey: "alertSwitchState")
            UserDefaults.standard.set(1, forKey: "alertTimeState")
            UserDefaults.standard.set(true, forKey: "soundSwitchState")
            UserDefaults.standard.set(false, forKey: "themeSwitchState")
            UserDefaults.standard.set(true, forKey: "vibrationSwitchState")
            UserDefaults.standard.set(0, forKey: "timeOverSoundState")
            UserDefaults.standard.set(0, forKey: "successSoundState")
            UserDefaults.standard.set(0, forKey: "failSoundState")
            UserDefaults.standard.set(true, forKey: "alwaysOnDisplaySwitchState")
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
        
        self.saveContext()
    }

    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Hourglass")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    static var persistentContainer: NSPersistentContainer {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }
    
    static var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

//    // 앱이 켜져 있는 상태(foreground)에서 푸시를 받았을 때 호출
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//
//        print("Test Foreground: \(notification.request.identifier)")
//        completionHandler([.alert, .sound])
//    }
//
//    // 앱이 켜져 있지는 않지만 백그라운드로 돌고 있는 상태에서 푸시를 클릭하고 들어왔을 때 혹은 알림이 dismiss 될 때 호출
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//
//        print("Test: \(response.notification.request.identifier)")
//
//        if response.notification.request.content.categoryIdentifier == "newCategory" {
//            // Handle the actions for the expired timer.
//            if response.actionIdentifier == "snooze" {
//                // Invalidate the old timer and create a new one. . .
//
//                let newContent = response.notification.request.content.mutableCopy() as! UNMutableNotificationContent
//                let newTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//                // 알림 요청
//                let newRequest = UNNotificationRequest(identifier: response.notification.request.identifier, content: newContent, trigger: newTrigger)
//                // 알림 요청을 알림센터에 추가
//                UNUserNotificationCenter.current().add(newRequest) { error in
//                    if let error = error {
//                        print(error)
//                    }
//                }
//                completionHandler()
//            }
//            else if response.actionIdentifier == "complete" {
//
//                //                self.resumeTimer?.invalidate()
//                //                self.resumeTimer = nil
//                //                self.pauseTimer?.invalidate()
//                //                self.pauseTimer = nil
//                //
//                //                self.saveTimeMeasurementInfo()
//                //
//                //                self.performSegue(withIdentifier: "WorkResultSegue", sender: nil)
//            }
//            completionHandler()
//        }
//        completionHandler()
//    }
}
