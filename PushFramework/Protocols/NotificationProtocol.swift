//
//  NotificationDataSource.swift
//  PushFramework
//
//  Created by Abhishek on 25/01/21.
//

import Foundation
import  UserNotifications
import UIKit

enum PermissonStatus {
    case granted
    case denied
    case notYetRequested
}

protocol NotificationProtocol {
    func startRemoteNotificationService(for application : UIApplication)
    func didReceiveNotificationExtensionRequest(_ request: UNNotificationRequest, withMutableNotificationContentHandler: @escaping (Result<UNMutableNotificationContent, PEError>) -> Void)
}
