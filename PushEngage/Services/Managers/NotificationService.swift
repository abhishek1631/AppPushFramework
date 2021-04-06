//
//  NotificationDataManager.swift
//  PushFramework
//
//  Created by Abhishek on 25/01/21.
//

import UserNotifications
import UIKit

protocol CustomUserDataHandlerDelegate : class {
    func get(for response: NotifictaionResponse)
}

class NotificationService: PENotificationCenterDelegate {
    
    //MARK: - public variables
    
    var notificationPermissionStatus = Variable<PermissonStatus>(.notYetRequested)
    public static weak var delegate : CustomUserDataHandlerDelegate?
    // MARK: - private variables
    
    private var notificationCenter = UNUserNotificationCenter.current()
    
    private var PENotificationDelegate : PENotificationCenterHandler
    
    private var notificationDefault = NotificationCenter.default
    
    private weak var application : UIApplication?
    
    
    // MARK: - initialization
    
     init() {
        PENotificationDelegate = PENotificationCenterHandler()
        notificationDefault.addObserver(self,
                                        selector: #selector(willEnterForeground),
                                        name: UIApplication.willEnterForegroundNotification,
                                        object: nil)
        PENotificationDelegate.delegate = self
    }
    
    deinit {
        notificationDefault.removeObserver(UIApplication.willEnterForegroundNotification)
    }
    
    @objc func willEnterForeground() {
        checkPermissionStatus()
    }
    
    func PEUserNotificationCenter(_ center: UNUserNotificationCenter,
                                  willPresent notification: UNNotification,
                                  withCompletionHandler completionHandler: ((UNNotificationPresentationOptions) -> Void)?) {
        PELogger.info(className: String(describing: NotificationService.self), message: notification
                                                                                        .request
                                                                                        .content
                                                                                        .userInfo
                                                                                        .description )
        completionHandler?([.alert, .sound , .badge])
    }
    
    func PEUserNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: NotifictaionResponse,
                                withCompletionHandler completionHandler : (() -> Void)?) {
        PELogger.info(className: String(describing: NotificationService.self), message: response.userInfo.debugDescription )
        deepLinking(for: response)
        completionHandler?()
    }
    
    
    private func deepLinking(for response : NotifictaionResponse) {
        if let link = response.userInfo[PayloadConstants.deeplinkingKey] as? String,
           link.contains("https") || link.contains("http") {
            let url = URL(string: link)
            if Utility.inAppPermissionStatus == true {
                loadWKWevView(with: url)
            } else {
                loadWithSafari(url: url)
            }
        } else {
            NotificationService.delegate?.get(for: response)
        }
    }

    private func loadWKWevView(with url : URL?) {
        if let link = url {
            let wkWebView = WKWebViewController(url: link, title: Utility.getApplicationName)
            let nav = UINavigationController(rootViewController: wkWebView)
            DispatchQueue.main.async { [weak self] in
                self?.application?.windows.first?.rootViewController?.present(nav, animated: true, completion: nil)
            }
        }
    }
    
    private func loadWithSafari(url : URL?) {
        guard let link = url else {
            return
        }
        if  UIApplication.shared.canOpenURL(link)  {
            UIApplication.shared.open(link) { (reponse) in
                PELogger.info(className:String(describing: NotificationService.self) , message: reponse.description)
            }
        }
    }
}
// MARK: - Extension
extension NotificationService : NotificationProtocol {
    
    func setNotificationCategories(_ categories: Set<UNNotificationCategory>) {
        notificationCenter.setNotificationCategories(categories)
    }
    
    
    private func requestPermission(for application : UIApplication) {
        notificationCenter.requestAuthorization(options: [.alert,.sound,.badge]) {  (grant, error) in
            if let error = error {
                PELogger.error(className:String(describing: NotificationService.self) , message: error.localizedDescription)
            } else {
                DispatchQueue.main.async { [weak self] in
                    application.registerForRemoteNotifications()
                    self?.checkPermissionStatus()
                }
            }
        }
    }
    
    private func checkPermissionStatus() {
        
        notificationCenter.getNotificationSettings {[weak self] (settings) in
            switch settings.authorizationStatus {
            case .authorized:
                self?.notificationPermissionStatus.value = .granted
            case .denied:
                self?.notificationPermissionStatus.value = .denied
            case .notDetermined:
                self?.notificationPermissionStatus.value = .notYetRequested
            default:
                break
            }
        }
    }
    
    func startRemoteNotificationService(for application : UIApplication) {
        self.application = application
        checkPermissionStatus()
        DispatchQueue.main.async { [weak self] in
            switch self?.notificationPermissionStatus.value {
            case .notYetRequested :
                self?.requestPermission(for: application)
            case .denied:
                PELogger.info(className: String(describing: NotificationService.self), message: "denied")
            case .granted:
                PELogger.info(className: String(describing: NotificationService.self), message: "Authorised")
            default:
                break
            }
        }
    }
    
}
