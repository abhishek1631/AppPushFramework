//
//  NotificationExtensionProtocol.swift
//  PushFramework
//
//  Created by Abhishek on 16/02/21.
//

import UserNotifications


protocol NotificationExtensionProtocol {
    func didReceiveNotificationExtensionRequest(_ request: UNNotificationRequest,bestContentHandler : UNMutableNotificationContent)
    func serviceExtensionTimeWillExpire(_ request : UNNotificationRequest ,content: UNMutableNotificationContent?) -> UNMutableNotificationContent?
}
