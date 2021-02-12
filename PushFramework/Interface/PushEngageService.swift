//
//  PushEngageService.swift
//  PushFramework
//
//  Created by Abhishek on 25/01/21.
//

import Foundation
import SwiftKeychainWrapper



@objcMembers
@objc public final class PushEngageService : NSObject {
    
    // MARK: - public static variable
    
    @objc public static let shared = PushEngageService()
    
    
    //MARK: - private variable
    private var application : UIApplication?
    private var dependencyProtocol : DependencyContainerProtocol
    //MARK: -private initialization method
    
    private override init() {
        dependencyProtocol = DependencyManger()
        super.init()
        self.dependencyProtocol.notificationProvider.delegate = self
    }
    
    @objc public var contentHandler : ((UNMutableNotificationContent) -> Void)?
    @objc public var userInfoHandler : (([AnyHashable : Any]) -> Void)?
    
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
        dependencyProtocol.applicationProvider.setDelegate(for: application)
    }
    
    @objc public func startNotificationServices() {
        guard let application = application else {
            return
        }
        dependencyProtocol.notificationProvider.startRemoteNotificationService(for: application)
    }
    
    @objc public func getApplication(for application : UIApplication) {
        self.application = application
    }
    
    @objc public func didReceiveNotificationExtensionRequest(_ request: UNNotificationRequest) {
       
        dependencyProtocol.notificationProvider.didReceiveNotificationExtensionRequest(request) { [weak self] result  in
                switch result {
                case .failure(let error):
                    assertionFailure(error.value)
                case .success(let content):
                    self?.contentHandler?(content)
                }
        }
    }
    
    @objc public func rediectController() {
        
    }
}

extension PushEngageService : UserInfoPassingDelegate {
    func get(userInfo: [AnyHashable : Any]) {
        userInfoHandler?(userInfo)
    }
}
