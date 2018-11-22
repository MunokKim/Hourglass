//
//  NotificationViewController.swift
//  NotificationViewController
//
//  Created by 김문옥 on 08/11/2018.
//  Copyright © 2018 김문옥. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import CoreData

class NotificationViewController: UIViewController, UNNotificationContentExtension {
    
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
        
        let size = view.bounds.size
        preferredContentSize = CGSize(width: size.width, height: size.height/4)
        
        imageView.backgroundColor = UIColor(red:0.30, green:0.30, blue:0.30, alpha:1.00)
        imageView.layer.cornerRadius = imageView.layer.frame.width / 7
        imageView.clipsToBounds = true
    }
    
    func didReceive(_ notification: UNNotification) {
//        self.label?.text = notification.request.content.body
//        imageView.image = notification.request.content.
    }

    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        
        if response.notification.request.content.categoryIdentifier == "newCategory" {
            
            // Handle the actions for the expired timer.
            if response.actionIdentifier == "snooze" {
                // Invalidate the old timer and create a new one. . .
                
                let newContent = response.notification.request.content.mutableCopy() as! UNMutableNotificationContent
                let newTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                // 알림 요청
                let newRequest = UNNotificationRequest(identifier: response.notification.request.identifier, content: newContent, trigger: newTrigger)
                // 알림 요청을 알림센터에 추가
                UNUserNotificationCenter.current().add(newRequest) { error in
                    if let error = error {
                        print(error)
                    }
                }
                completion(.dismiss)
            }
            else if response.actionIdentifier == "complete" {
                
//                let workID = userInfo["workID"] as? Int16
//                let workStart = userInfo["workStart"] as? NSDate
//                let elapsedTime = userInfo["elapsedTime"] as? Int32
//                let remainingTime = userInfo["remaingTime"] as? Int32
                
                // App Groups 를 이용한 Extension 과 호스트 앱의 데이터 연동
                if let shareDefaults = UserDefaults(suiteName: "group.Munok.Hourglass") {
                    
                    shareDefaults.set(true, forKey: "isCompleted")
//                    shareDefaults.set(workID, forKey: "workID")
//                    shareDefaults.set(workStart, forKey: "workStart")
//                    shareDefaults.set(elapsedTime, forKey: "elapsedTime")
//                    shareDefaults.set(remainingTime, forKey: "remainingTime")
                    shareDefaults.set(NSDate(), forKey: "momentForNotiAction")
                }
                
                let innerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: imageView.frame.size.width, height: 0))
                innerView.layer.position = CGPoint(x: self.imageView.frame.width/2, y: self.imageView.frame.height)
                innerView.backgroundColor = UIColor(red:0.98, green:0.62, blue:0.28, alpha:0.75)
//                innerView.layer.cornerRadius = 0
                innerView.layer.cornerRadius = self.imageView.layer.frame.width / 3
                innerView.clipsToBounds = true
                imageView.addSubview(innerView)
                
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.75, animations: {
                        innerView.frame.size.height = self.imageView.frame.size.height
                        innerView.layer.position = CGPoint(x: self.imageView.frame.width/2, y: self.imageView.frame.height/2)
                        self.view.layoutIfNeeded()
                    }, completion: { _ in
                        completion(.dismissAndForwardAction)
                    })
                }
            }
        }
//        completion(.doNotDismiss)
    }
    
//    func saveTimeMeasurementInfo() {
//
//        // Core Data 영구 저장소에 TimeMeasurementInfo 데이터 추가하기
//        let timeMeasurementInfo = TimeMeasurementInfo(context: context)
//
//        timeMeasurementInfo.workStart = workStart
//        let now = NSDate()
//        timeMeasurementInfo.actualCompletion = now
//        timeMeasurementInfo.goalSuccessOrFailWhether = elapsedTime ?? 0 <= fetchResult.estimatedWorkTime // 목표 달성/실패 여부 = 소요시간 <= 작업예상시간
//        timeMeasurementInfo.successiveGoalAchievement = timeMeasurementInfo.goalSuccessOrFailWhether ? fetchResult.currentSuccessiveAchievementWhether + 1 : 0 // 연속목표달성
//        timeMeasurementInfo.estimatedWorkTime = fetchResult.estimatedWorkTime // 예상작업시간
//        timeMeasurementInfo.elapsedTime = elapsedTime ?? 0
//        timeMeasurementInfo.remainingTime = remainingTime ?? 0
//        timeMeasurementInfo.work = fetchResult // 어떤 작업에 해당하는 시간측정정보인지
//
//        do {
//            try context.save()
//
//            print("Context Save Success!")
//            print("timeMeasurementInfo >>>>>>>>>> \(timeMeasurementInfo)")
//            print("workInfo >>>>>>>>>> \(fetchResult)")
//
//            workResultInfo = timeMeasurementInfo
//
//        } catch let nserror as NSError {
//
//            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//        }
//    }
}
