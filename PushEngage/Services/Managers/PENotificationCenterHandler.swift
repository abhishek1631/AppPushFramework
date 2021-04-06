//
//  PENotificationCenterHandler.swift
//  PushFramework
//
//  Created by Abhishek on 23/03/21.
//

import Foundation
import UserNotifications

@objc public protocol NotifictaionResponse  {
    var userInfo : [AnyHashable : Any] { get }
    var actionTrigger : String { get  }
}

class UserNotificationRespone : NotifictaionResponse {
    
    var userInfo: [AnyHashable : Any] {
        return response.notification.request.content.userInfo
    }
    
    var actionTrigger: String {
        return response.actionIdentifier
    }
    
    private let response : UNNotificationResponse
    
    init(_response : UNNotificationResponse) {
        response = _response
    }
}

class PENotificationCenterHandler : NSObject, UNUserNotificationCenterDelegate {
    
    private var notificationCenter = UNUserNotificationCenter.current()
    weak var delegate : PENotificationCenterDelegate?
    
    override init() {
        super.init()
        notificationCenter.delegate = self
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        delegate?.PEUserNotificationCenter(center, willPresent: notification, withCompletionHandler: completionHandler)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let response = UserNotificationRespone(_response: response)
        delegate?.PEUserNotificationCenter(center, didReceive: response, withCompletionHandler: completionHandler)
    }
    
}
