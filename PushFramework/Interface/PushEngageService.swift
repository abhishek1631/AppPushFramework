//
//  PushEngageService.swift
//  PushFramework
//
//  Created by Abhishek on 25/01/21.
//

import Foundation
import SwiftKeychainWrapper

@objc public class PushEngageService : NSObject {
    
    // MARK: - public static variable
    
    @objc public static let shared = PushEngageService()
    
    
    //MARK: - private variable
    
    private let notificationService : NotificationProtocol
    private let deviceTokenManager : DeviceTokenProtocol
    private let applicationManager : ApplicationProtocol
    
    //MARK: -private initialization method
    
    private override init() {
        self.notificationService = NotificationService()
        self.deviceTokenManager = DeviceTokenManager()
        self.applicationManager = ApplicationService()
    }
    
    //MARK: - public methods
    
    @objc public func setDelegate(for application : UIApplication) {
        applicationManager.setDelegate(for: application)
    }
    
    @objc public func startNotificationServices() {
        notificationService.startRemoteNotificationService()
    }
}
