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
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.content.categoryIdentifier == "newCategory" {
            // Handle the actions for the expired timer.
            if response.actionIdentifier == "snooze" {
                // Invalidate the old timer and create a new one. . .
                
            }
            else if response.actionIdentifier == "complete" {
                
                
            }
        }
    }
}
