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
import SwiftIcons

class NotificationViewController: UIViewController, UNNotificationContentExtension {
    
    @IBOutlet var iconView: UIView!
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var checkImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
        
        let size = view.bounds.size
        preferredContentSize = CGSize(width: size.width, height: size.height/4)
        
        iconView.backgroundColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1.00)
        
        iconView.layer.shadowColor = UIColor.lightGray.cgColor
        iconView.layer.shadowRadius = 2.0
        iconView.layer.shadowOpacity = 0.5
        iconView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        iconView.layer.masksToBounds = false
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        iconView.layer.cornerRadius = iconImageView.layer.frame.width / 2.66
//        iconView.clipsToBounds = true
    }
    
    func didReceive(_ notification: UNNotification) {
//        self.label?.text = notification.request.content.body
        let userInfo = notification.request.content.userInfo
        
        if let iconNumber = userInfo["iconNumber"] as? Int32, let iconCase = IcofontType(rawValue: Int(iconNumber)) {
            iconImageView.setIcon(icon: .icofont(iconCase), textColor: UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1.00), backgroundColor: .clear, size: nil)
        }
    }

    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        
//        let userInfo = response.notification.request.content.userInfo
        
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
                
                let innerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
                innerView.layer.position = CGPoint(x: self.iconView.frame.width/2, y: self.iconView.frame.height/2)
                innerView.backgroundColor = UIColor(red:0.98, green:0.62, blue:0.28, alpha:1.00)
//                innerView.layer.cornerRadius = 0
                innerView.layer.cornerRadius = self.iconView.layer.frame.width / 2
                innerView.clipsToBounds = true
                iconView.insertSubview(innerView, at: 0)
                
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 1, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                        
                        innerView.frame.size.width = self.iconView.frame.size.width
                        innerView.frame.size.height = self.iconView.frame.size.height
                        innerView.layer.position = CGPoint(x: self.iconView.frame.width/2, y: self.iconView.frame.height/2)
                        innerView.layer.cornerRadius = innerView.layer.frame.width / 2.66
                        self.view.layoutIfNeeded()
                        
                    }, completion: { _ in
                        completion(.dismissAndForwardAction)
                    })
                }
            }
        }
//        completion(.doNotDismiss)
    }
}
