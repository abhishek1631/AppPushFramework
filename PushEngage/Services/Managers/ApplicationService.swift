//
//  ApplicationService.swift
//  PushFramework
//
//  Created by Abhishek on 03/02/21.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

class ApplicationService: NSObject, UIApplicationDelegate {
    
    var userDefault : UserDefaultProtocol
    var networkDatasource : SubscriberService
    
     init(_userDefault : UserDefaultProtocol,
          _networkDatasource : SubscriberService) {
        self.userDefault = _userDefault
        self.networkDatasource = _networkDatasource
    }
    
    private func operations(with token: String) {
        let existingDeviceToken = userDefault.deviceToken
        if existingDeviceToken.isEmpty && userDefault.appId != nil {
            userDefault.deviceToken = token
            networkDatasource.addSubscriber(completionHandler: nil)
        } else if token != existingDeviceToken && userDefault.appId != nil {
            userDefault.deviceToken = token
            networkDatasource.addSubscriber(completionHandler: nil)
//            networkDatasource.upgradeSubscription { [weak self] (response) in
//                self?.userDefault.deviceToken = token
//            }
        }
    }
    
    // if device don't allow then also it is providing the device token.
    // if internet is not available while requesting for the remote notification then also this delegate call happens
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        PELogger.debug(className: String(describing: ApplicationService.self), message: token)
        operations(with : token)
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        PELogger.debug(className: String(describing: ApplicationService.self), message: error.localizedDescription)
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        PELogger.debug(className: String(describing: ApplicationService.self), message: userInfo.debugDescription)
        completionHandler(.noData)
    }
}

extension ApplicationService : ApplicationProtocol {
    
    func setDelegate(for application: UIApplication) {
        application.delegate = self
    }
}
