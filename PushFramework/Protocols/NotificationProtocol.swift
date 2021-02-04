//
//  NotificationDataSource.swift
//  PushFramework
//
//  Created by Abhishek on 25/01/21.
//

import Foundation
import  UserNotifications

enum PermissonStatus {
    case granted
    case denied
    case notYetRequested
}

@objc protocol NotificationProtocol {
    func startRemoteNotificationService()
}
