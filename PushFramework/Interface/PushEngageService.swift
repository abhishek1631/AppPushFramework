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
    private var application : UIApplication?
    //MARK: -private initialization method
    
    private override init() {
        self.notificationService = NotificationService()
        self.deviceTokenManager = DeviceTokenManager()
        self.applicationManager = ApplicationService()
    }
    
    @objc public var contentHandler : ((UNMutableNotificationContent) -> Void)?
    
    //MARK: - public methods
    
    @objc public func getAppId() -> String {
        return ""
    }
    
    @objc public func setAppId(appId : String) {
        
    }
    
    @objc public func setDelegate() {
        guard let application = application else {
            return
        }
        applicationManager.setDelegate(for: application)
    }
    
    @objc public func startNotificationServices() {
        guard let application = application else {
            return
        }
        notificationService.startRemoteNotificationService(for: application)
    }
    
    @objc public func getApplication(for application : UIApplication) {
        self.application = application
    }
    
    @objc public func didReceiveNotificationExtensionRequest(_ request: UNNotificationRequest) {
       
        notificationService.didReceiveNotificationExtensionRequest(request) { [weak self] result  in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let content):
                    self?.contentHandler?(content)
                }
        }
    }
}
