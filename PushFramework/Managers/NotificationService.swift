//
//  NotificationDataManager.swift
//  PushFramework
//
//  Created by Abhishek on 25/01/21.
//

import UserNotifications
import UIKit
import MobileCoreServices

protocol UserInfoPassingDelegate : class {
    func get(userInfo : [AnyHashable : Any])
}


class NotificationService: NSObject, UNUserNotificationCenterDelegate {
    
    // MARK: - private variable
    
    private var notification = UNUserNotificationCenter.current()
    private var notificationPermission : PermissonStatus = .notYetRequested
    
    private var options : UNAuthorizationOptions = [.alert , .sound , .badge]
    
    weak var delegate : UserInfoPassingDelegate?
    
    
    // MARK: - initialization
    
    override init() {
        super.init()
        notification.delegate = self
    }
    
    //foreground
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        logContent(of: notification)
        completionHandler([.alert, .sound , .badge])
    }
    
    //BackGround
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        logContent(of: response.notification)
        delegate?.get(userInfo: response.notification.request.content.userInfo )
        completionHandler()
    }
    
    
    private func logContent(of notification : UNNotification) {
        print("user info data:- ",notification.request.content.userInfo)
    }
}
// MARK: - Extension
extension NotificationService : NotificationProtocol {
    
    func didReceiveNotificationExtensionRequest(_ request: UNNotificationRequest, withMutableNotificationContentHandler: @escaping (Result<UNMutableNotificationContent, PEError>) -> Void) {
        guard let updatedContent = (request.content.mutableCopy() as?  UNMutableNotificationContent) else {
            withMutableNotificationContentHandler(.failure(.contentNotFound))
            return
        }
        if let attachmentString = updatedContent.userInfo["attachment-url"] as? String , let attachmentUrl = URL(string: attachmentString){
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let downloadTask = session.downloadTask(with: attachmentUrl) { (url,_,error) in
                if let error = error {
                    print(error.localizedDescription )
                } else if let urlName = url {
                    do {
                        let attachment = try UNNotificationAttachment(identifier: attachmentString, url: urlName, options: [UNNotificationAttachmentOptionsTypeHintKey : kUTTypePNG])
                        updatedContent.attachments = [attachment]
                        withMutableNotificationContentHandler(.success(updatedContent))
                    } catch {
                        withMutableNotificationContentHandler(.failure(.downloadAttachmentfailed))
                    }
                }
            }
            downloadTask.resume()
        }
    }
    
    private func requestPermission(for application : UIApplication) {
        notification.requestAuthorization(options: [.alert,.sound,.badge]) {  (grant, error) in
            if let error = error {
                print(error)
            } else {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
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
    
    func startRemoteNotificationService(for application : UIApplication) {
        checkPermissionStatus()
        DispatchQueue.main.async { [weak self] in
            switch self?.notificationPermission {
            case .notYetRequested :
                self?.requestPermission(for: application)
            case .denied:
                print("redirect")
            case .granted:
                print("Authoried")
            default:
                break
            }
        }
    }
    
}

