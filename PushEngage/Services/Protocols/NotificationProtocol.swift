//
//  NotificationDataSource.swift
//  PushFramework
//
//  Created by Abhishek on 25/01/21.
//

import Foundation
import  UserNotifications
import UIKit

protocol NotificationProtocol {
    func startRemoteNotificationService(for application : UIApplication)
    func setNotificationCategories(_ categories: Set<UNNotificationCategory>)
    var notificationPermissionStatus : Variable<PermissonStatus> { get }
}
