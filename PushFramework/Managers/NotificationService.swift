//
//  NotificationDataManager.swift
//  PushFramework
//
//  Created by Abhishek on 25/01/21.
//

import UserNotifications
import UIKit


class NotificationService: NSObject, UNUserNotificationCenterDelegate {
    
    // MARK: - private variable
    
    private var notification = UNUserNotificationCenter.current()
    private var notificationPermission : PermissonStatus = .notYetRequested
    private var options : UNAuthorizationOptions = [.alert , .sound , .badge]
    
    // MARK: - initialization
    
    override init() {
        super.init()
        notification.delegate = self
    }
    
    //foreground
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        logContent(of: notification)
        completionHandler([.banner , .sound , .badge])
    }
    
    //BackGround
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        logContent(of: response.notification)
        completionHandler()
    }
    
    func logContent(of notification : UNNotification) {
        print(notification.request.content.userInfo)
    }
    
}
// MARK: - Extension
extension NotificationService : NotificationProtocol {
    
    private func requestPermission() {
        notification.requestAuthorization(options: [.alert,.sound,.badge]) { [weak self] (grant, error) in
            if let error = error {
                self?.setPermissionStatus()
                print(error)
            } else {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                    self?.setPermissionStatus()
                }
            }
        }
    }
    
    private func setPermissionStatus() {
        notification.getNotificationSettings {[weak self] (settings) in
            switch settings.authorizationStatus {
            case .authorized:
                self?.notificationPermission = .granted
            case .denied:
                self?.notificationPermission = .denied
            case .notDetermined:
                self?.notificationPermission = .notYetRequested
            default:
                break
            }
        }
    }
    
    func startRemoteNotificationService() {
        
        if case .granted = notificationPermission {
            print("Granted")
        } else {
            DispatchQueue.main.async { [weak self] in
                if !UIApplication.shared.isRegisteredForRemoteNotifications {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, completionHandler: nil)
                } else {
                    self?.requestPermission()
                }
            }
        }
        
    }
}

