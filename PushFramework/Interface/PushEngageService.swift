//
//  PushEngageService.swift
//  PushFramework
//
//  Created by Abhishek on 25/01/21.
//

import Foundation
import SwiftKeychainWrapper

public enum PermissionToStartNotification : CaseIterable {
    case allow
    case denied
}

public class PushEngageService {
    
    public static let shared = PushEngageService()
    
    private let notificationService : NotificationProtocol
    private let deviceTokenManager : DeviceTokenProtocol
    
    private init() {
        self.notificationService = NotificationService()
        self.deviceTokenManager = DeviceTokenManager()
    }
   
    public func getUser(permission : PermissionToStartNotification) {
        switch permission {
        case .allow:
            notificationService.startRemoteNotificationService()
        case .denied:
            print("denied")
        }
    }
    
    public func getDeviceToken(token : Data) {
        let token = token
            .map{String(format: "%02.2hhx", $0)}
            .joined()
        deviceTokenManager.setDeviceToken(token: token)
    }
    
    public func startNotificationServices() {
        notificationService.startRemoteNotificationService()
    }
    
}
