//
//  PushEngageService.swift
//  PushFramework
//
//  Created by Abhishek on 25/01/21.
//

import UIKit
import  SwiftKeychainWrapper


internal enum RegistraionStatus {
    case registered
    case notRegistered
}

@objcMembers
@objc public final class PushEngageService : NSObject {

    //MARK: - private variable
    private static let shared = PushEngageService()
    private static var dependency = DependencyInitialize()
    private static var applicationService = dependency.getApplicationService()
    private static var notificationService =  dependency.getNotificationService()
    private static var notificationExtensionService = dependency.getNotificationExtension()
    private static var networkService = dependency.getNetworkDataService()
    private static var userDefaultService = dependency.getUserDefaultService()
    private static var locationService = dependency.getLocationService()
    private static var notificationLifeCycleService = dependency.getNotificationLifeCycleService()
    
    //MARK: - Dependency Injection for the view model in PushEngageServices
    
    private static let viewModel = PEViewModel(_applicationService: applicationService, _notificationService: notificationService, _notificationExtensionService: notificationExtensionService, _subscriberService: networkService, _userDefaultService: userDefaultService, _notificationLifeCycleService: notificationLifeCycleService,_locationService: locationService)
    
    //MARK: -private initialization method
    
    ///  Initialzation of the PushEngageService  object with the Registering the protocols with there specififc services.
    private override init() {
        // Registration in dependency container should be done with
        super.init()
    }
    
    //MARK: - public handlers
    @objc public static var userInfoHandler : ((NotifictaionResponse) -> Void)?
    //MARK: - public methods
    
    @objc public static func getAppId() -> String? {
        return viewModel.getAppId()
    }
    
    @objc public static func setAppId(appId : String) {
        NotificationService.delegate = shared
        viewModel.setAppId(appId: appId)
    }
    
    @objc public static func setDelegate() {
        viewModel.setDelegate()
    }
    
    @objc public static func startNotificationServices() {
        viewModel.startNotificationServices()
    }
    
    @objc public static func getApplication(for application : UIApplication, with launchOptions : [UIApplication.LaunchOptionsKey: Any]?) {
        viewModel.getApplication(for: application, with: launchOptions)
    }
    
    /// Description:- This method provides the Notification service extension feature to modify the content  to the application.
    /// - Parameter request: Parameter is passed from the parent application so that method can modifiy the content.
    @objc public static func didReceiveNotificationExtensionRequest(_ request: UNNotificationRequest , bestContentHandler :UNMutableNotificationContent) {
        viewModel.didReceiveNotificationExtensionRequest(request, bestContentHandler: bestContentHandler)
    }
    
    //MARK: - update Subsciber Attributes
    
    @objc public static  func update(attribute : Parameters, completionHandler :((_ response : String? , _ error : Error?) -> ())? ) {
        viewModel.update(attribute: attribute) { (message, error) in
            completionHandler?(message , error)
        }
    }
    
    @objc public enum CallType : Int {
        case getAttribute
        case addProfile
        case deleteAttribute
        case updateSegments
        case updateDynamicSegments
    }
    
    @objc public static func push(type : CallType,
                                  parameter : Any? ,
                                  for segmentAction : SegmentActions = .none,
                                  completionHandler : ((_ response : [String : Any]? , _ message : String? , _ error : Error?) -> ())?) {
        
        switch type {
        case .getAttribute:
            viewModel.getAttribute { (value, error) in
                completionHandler?(value , nil , error)
            }
        case .addProfile:
            guard let param = parameter as? String else {
                completionHandler?(nil, nil, PEError.incorrectParameter)
                return
            }
            viewModel.addProfile(for: param) { (message, error) in
                completionHandler?(nil , message , error)
            }
        case .deleteAttribute:
            guard let param = parameter as? [String] else {
                completionHandler?(nil, nil, PEError.incorrectParameter)
                return
            }
            viewModel.deleteAttribute(values: param) { (message, error) in
                completionHandler?(nil , message , error)
            }
        case .updateSegments:
            guard let param = parameter as? [String] else {
                completionHandler?(nil, nil, PEError.incorrectParameter)
                return
            }
            viewModel.update(segments: param, with: segmentAction) { (message, error) in
                completionHandler?(nil , message , error)
            }
        case .updateDynamicSegments:
            guard let param = parameter as? [[String : Any]] else {
                completionHandler?(nil, nil, PEError.incorrectParameter)
                return
            }
            viewModel.update(dynamic: param) { (message, error) in
                completionHandler?(nil , message , error)
            }
        }
        
        
    }
    
    //MARK:- get-subscriber-attributes
    
    @objc public static func getAttribute(completionHandler : @escaping(_ info : [String : Any]?, _ error: Error?) -> ()) {
        viewModel.getAttribute { (response, error) in
            completionHandler(response , error)
        }
    }
    
    //MARK:- add-profile-id
    
    @objc public static func addProfile(for id : String, completionHandler :((_ response : String? , _ error : Error?) -> ())?) {
        viewModel.addProfile(for: id) { (message, error) in
            completionHandler?(message , error)
        }
    }
    
    //MARK: - delete Attributes
    
    @objc public static func deleteAttribute(values : [String], completionHandler :((_ response : String? , _ error : Error?) -> ())?) {
        viewModel.deleteAttribute(values: values) { (message, error) in
            completionHandler?(message,error)
        }
    }
    
    //MARK: - update segments
    
    @objc public static func update(segments : [String] , with action : SegmentActions, completionHandler :((_ response : String? , _ error : Error?) -> ())?) {
        viewModel.update(segments: segments, with: action) { (message, error) in
            completionHandler?(message , error)
        }
    }
    
    //MARK: - update dynamic segments
    
    @objc public static func update(dynamic segments : [[String : Any]], completionHandler :((_ response : String? , _ error : Error?) -> ())?) {
        viewModel.update(dynamic: segments) { (message, error) in
            completionHandler?(message , error)
        }
    }
    
    //MARK: - update segment hash Array
    
    @objc public static func updateHashArray(for segmentId : Int) {
        viewModel.updateHashArray(for: segmentId)
    }
    
    //MARK: - removeDynamic
    
    @objc public static func removeDynamic(for segments : [String]) {
        viewModel.removeDynamic(for: segments)
    }
    
    //MARK: - update trigger status
    
    @objc public static func updateTrigger(status : Bool , completionHandler :((_ response : String? , _ error : Error?) -> ())?) {
        viewModel.updateTrigger(status: status) { (message, error) in
            completionHandler?(message, error)
        }
    }
    
    //MARK: - get subscriber details
    
    @objc public static func getSubscriberDetails(for fields: [String],completionHandler :((_ response : [String : Any]? , _ error : Error?) -> ())?) {
        viewModel.getSubscriberDetails(for: fields) { (response, error) in
            completionHandler?(response , error)
        }
    }
    
    //MARK:- check device token from subscriber hash
    
    @objc public static func checkSubscriber(completionHandler : ((_ response : [String : Any]?, _ error : Error?)->())?) {
        viewModel.checkSubscriber { (response, error) in
            completionHandler?(response , error)
        }
    }
    
    //MARK: -update subsciber info with subscriber hash
    
    @objc public static func updateSubsciber(completionHandler :((_ response : String? , _ error : Error?) -> ())?) {
        viewModel.updateSubsciber { (message, error) in
            completionHandler?(message , error)
        }
    }
    
    //MARK: - best attempt handled
    
    @objc public static func serviceExtensionTimeWillExpire(_ request : UNNotificationRequest ,content: UNMutableNotificationContent?) -> UNMutableNotificationContent? {
        return viewModel.serviceExtensionTimeWillExpire(request, content: content)
    }
}

extension PushEngageService : CustomUserDataHandlerDelegate {
    func get(for response: NotifictaionResponse) {
        Self.userInfoHandler?(response)
        Self.viewModel.notificationLifecycleUpdate(with: .clicked,deviceHash: Self.userDefaultService
                                                                                                .subscriberHash,
                                                                                   notificationId: "4",
                                                                                   completionHandler: nil)
    }
    
}
