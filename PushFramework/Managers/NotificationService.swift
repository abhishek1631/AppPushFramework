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
    private var remoteNotificationRegisterStatus : Bool {
        return UIApplication.shared.isRegisteredForRemoteNotifications
    }
    
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
        notification.requestAuthorization(options: [.alert,.sound,.badge]) {  (grant, error) in
            if let error = error {
                print(error)
            } else {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    private func checkPermissionStatus() {
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
        checkPermissionStatus()
        DispatchQueue.main.async { [weak self] in
            switch self?.notificationPermission {
            case .notYetRequested :
                self?.requestPermission()
            case .denied:
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, completionHandler: nil)
            case .granted:
                print("Authoried")
            default:
                break
            }
        }
    }
}

