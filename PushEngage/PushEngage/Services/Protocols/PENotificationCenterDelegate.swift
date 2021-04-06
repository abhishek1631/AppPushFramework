//
//  PENotificationCenterDelegate.swift
//  PushFramework
//
//  Created by Abhishek on 23/03/21.
//

import Foundation
import UserNotifications

protocol PENotificationCenterDelegate : class {
    func PEUserNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: ((UNNotificationPresentationOptions) -> Void)?)
    
    func PEUserNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: NotifictaionResponse,
                                withCompletionHandler completionHandler: (() -> Void)?)
}
