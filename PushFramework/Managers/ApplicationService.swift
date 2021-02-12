//
//  ApplicationService.swift
//  PushFramework
//
//  Created by Abhishek on 03/02/21.
//

import Foundation
import UIKit

class ApplicationService: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("Device token :- ",token)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("value", userInfo)
        completionHandler(.noData)
    }
}

extension ApplicationService : ApplicationProtocol {
    
    func setDelegate(for application: UIApplication) {
        application.delegate = self
    }
}
