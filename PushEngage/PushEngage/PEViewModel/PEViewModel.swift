//
//  PEViewModel.swift
//  PushFramework
//
//  Created by Abhishek on 02/04/21.
//

import Foundation
import UserNotifications
import UIKit

class PEViewModel {
    
    private var applicationService : ApplicationProtocol
    private var notificationService : NotificationProtocol
    private var networkService : SubscriberService
    private var userDefaultService : UserDefaultProtocol
    private var notificationLifeCycleService : NotificationLifeCycleService
    private var notificationExtensionService : NotificationExtensionProtocol
    private var locationService : LocationInfoProtocol
    private var application : UIApplication?
    private var launchOptions : [UIApplication.LaunchOptionsKey: Any]?
    private var notificationPermissionStatus = Variable<PermissonStatus>(.notYetRequested)
    private var geoLocationInfo = Variable<GeoLocationInfo>((nil , nil , nil))
    private let disposeBag = DisposeBag()
    
    public var userInfoHandler : ((NotifictaionResponse) -> Void)?
    
    init(_applicationService : ApplicationProtocol,
         _notificationService : NotificationProtocol,
         _notificationExtensionService : NotificationExtensionProtocol,
         _subscriberService : SubscriberService,
         _userDefaultService : UserDefaultProtocol,
         _notificationLifeCycleService : NotificationLifeCycleService,
         _locationService : LocationInfoProtocol) {
        self.applicationService = _applicationService
        self.notificationService = _notificationService
        self.networkService = _subscriberService
        self.userDefaultService = _userDefaultService
        self.notificationLifeCycleService = _notificationLifeCycleService
        self.notificationExtensionService = _notificationExtensionService
        self.locationService = _locationService
        setupBinding()
        NotificationCenter.default.addObserver(self, selector: #selector(updateTimeZone), name: UIApplication.significantTimeChangeNotification, object: nil)
    }
    
    deinit {
        disposeBag._dispose()
        NotificationCenter.default.removeObserver(self, name: UIApplication.significantTimeChangeNotification, object: nil)
    }
    
    func setupBinding() {
        notificationService.notificationPermissionStatus.bind(to: notificationPermissionStatus).disposed(by: disposeBag)
        notificationPermissionStatus.subscribe { [weak self] (status) in
            PELogger.info(className: String(describing: PEViewModel.self), message: status.rawValue)
            guard let self = self else {
                return
            }
            let subscriberStatusCheck = (self.userDefaultService.subscriberHash.isEmpty
                                         ,status != self.userDefaultService.notificationPermissionState)
            self.userDefaultService.notificationPermissionState = status
            if subscriberStatusCheck == (false , true) {
                //MARK:- Subscriber status update
                self.prerequesiteNetworkCallCheck {
                    self.updateSubscriberStatus(completionHandler: nil)
                }
            }
            PELogger.debug(className: String(describing: PushEngageService.self), message: status.rawValue)
        }.disposed(by: disposeBag)
        
        //MARK:- Observer for location update.
        
        locationService.locationInfoObserver.bind(to: geoLocationInfo).disposed(by: disposeBag)
        geoLocationInfo.subscribe {[weak self] (geoInfo) in
            self?.userDefaultService.geoLocationCountry = geoInfo.country
            self?.userDefaultService.geoLocationCity = geoInfo.locality
            self?.userDefaultService.geoLocationState = geoInfo.state
        }.disposed(by: disposeBag)
        
    }
    
    func getAppId() -> String? {
        return userDefaultService.appId
    }
    
    func setAppId(appId : String) {
        userDefaultService.appId = appId
    }
    
    func setDelegate() {
        guard let application = application else {
            return
        }
        applicationService.setDelegate(for: application)
    }
    
    func startNotificationServices() {
        guard let application = application,
              userDefaultService.appId != nil else {
            return
        }
        notificationService.startRemoteNotificationService(for: application)
    }
    
    func getApplication(for application : UIApplication, with launchOptions : [UIApplication.LaunchOptionsKey: Any]?) {
        self.application = application
        self.launchOptions = launchOptions
    }
    
    
    //MARK: - private methods
    
    private func checkForRegisterationStatus() -> RegistraionStatus {
        let caseToCheck = (userDefaultService.appId?.isEmpty , userDefaultService.subscriberHash.isEmpty)
        if case (false , false) = caseToCheck {
            return .registered
        } else {
            return .notRegistered
        }
    } //MARK: - private methods
    
    func prerequesiteNetworkCallCheck(block : () -> Void) {
        if userDefaultService.notificationPermissionState != .notYetRequested {
            let registerationStatus = checkForRegisterationStatus()
            switch registerationStatus {
            case .notRegistered:
                let alert = UIAlertController(title: "Registration failed", message: "Please provide proper APP key", preferredStyle: .alert)
                let action = UIAlertAction(title: "Dismiss", style: .cancel)
                alert.addAction(action)
                DispatchQueue.main.async { [weak self] in
                    self?.application?.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
                }

            case .registered:
                block()
            }
        }
    }
    
    @objc func updateTimeZone() {
        prerequesiteNetworkCallCheck {
            networkService.updateTimeZone()
        }
    }
    
    func getDeviceHash() -> String {
        return userDefaultService.subscriberHash
    }
    
    func getNotificationPermissionStatus() -> PermissonStatus {
        return userDefaultService.notificationPermissionState
    }
    
    func setNotificationPermissionStatus(status : PermissonStatus) {
        userDefaultService.notificationPermissionState = status
    }
    
    func notificationLifecycleUpdate(with action :NotificationLifeAction ,
                                     deviceHash : String ,
                                     notificationId : String ,
                                     completionHandler :((_ response : String? , _ error : Error?) -> ())?) {
        prerequesiteNetworkCallCheck {
            notificationLifeCycleService.notificationLifecycleUpdate(with: action,
                                                                     deviceHash: deviceHash,
                                                                     notificationId: notificationId) { result in
                switch result {
                case.success(let message):
                    PELogger.info(className: String(describing: PEViewModel.self) , message: message)
                    completionHandler?(message , nil)
                case .failure(let error):
                    PELogger.error(className: String(describing: PEViewModel.self) , message: error.value)
                    completionHandler?(nil, error)
                }
            }
        }
    }
    
    
    // Description:- This method provides the Notification service extension feature to modify the content  to the application.
    /// - Parameter request: Parameter is passed from the parent application so that method can modifiy the content.
    func didReceiveNotificationExtensionRequest(_ request: UNNotificationRequest , bestContentHandler :UNMutableNotificationContent) {
        notificationExtensionService.didReceiveNotificationExtensionRequest(request, bestContentHandler: bestContentHandler)
    }
    
    func updateSubscriberStatus(completionHandler :((_ response : String? , _ error : Error?) -> ())?) {
        prerequesiteNetworkCallCheck {
            networkService.updateSubscriberStatus { result in
                switch result {
                case.success(let message):
                    PELogger.info(className: String(describing: PEViewModel.self) , message: message)
                    completionHandler?(message , nil)
                case .failure(let error):
                    PELogger.error(className: String(describing: PEViewModel.self) , message: error.value)
                    completionHandler?(nil, error)
                }
            }
        }
    }
    
    //MARK: - update Subsciber Attributes
    
     func update(attribute : Parameters, completionHandler :((_ response : String? , _ error : Error?) -> ())? ) {
        prerequesiteNetworkCallCheck {
            networkService.update(attributes: attribute) { result in
                switch result {
                case.success(let message):
                    PELogger.info(className: String(describing: PEViewModel.self) , message: message)
                    completionHandler?(message , nil)
                case .failure(let error):
                    PELogger.error(className: String(describing: PEViewModel.self) , message: error.value)
                    completionHandler?(nil, error)
                }
            }
        }
        
    }
    
    //MARK:- get-subscriber-attributes
    
    func getAttribute(completionHandler : @escaping(_ info : [String : Any]?, _ error: Error?) -> ()) {
        prerequesiteNetworkCallCheck {
            networkService.getAttribute { (result) in
                switch result {
                case .success(let values):
                    PELogger.info(className: String(describing: PEViewModel.self) , message: values?.debugDescription ?? "")
                    completionHandler(values , nil)
                case .failure(let error):
                    PELogger.error(className: String(describing: PEViewModel.self) , message: error.value)
                    completionHandler(nil , error)
                }
            }
        }
    }
    
    //MARK:- add-profile-id
    
    func addProfile(for id : String, completionHandler :((_ response : String? , _ error : Error?) -> ())?) {
        prerequesiteNetworkCallCheck {
            networkService.addProfile(id: id) { result  in
                switch result {
                case.success(let message):
                    PELogger.info(className: String(describing: PEViewModel.self) , message: message)
                    completionHandler?(message , nil)
                case .failure(let error):
                    PELogger.error(className: String(describing: PEViewModel.self) , message: error.value)
                    completionHandler?(nil, error)
                }
            }
        }
    }
    
    //MARK: - delete Attributes
    
    func deleteAttribute(values : [String], completionHandler :((_ response : String? , _ error : Error?) -> ())?) {
        prerequesiteNetworkCallCheck {
            networkService.deleteAttribute(with: values) { result in
                switch result {
                case.success(let message):
                    PELogger.info(className: String(describing: PEViewModel.self) , message: message)
                    completionHandler?(message , nil)
                case .failure(let error):
                    PELogger.error(className: String(describing: PEViewModel.self) , message: error.value)
                    completionHandler?(nil, error)
                }
            }
        }
    }
    
    //MARK: - update segments
    
    func update(segments : [String] , with action : SegmentActions, completionHandler :((_ response : String? , _ error : Error?) -> ())?) {
        prerequesiteNetworkCallCheck {
            networkService.update(segments: segments , action : action) { result in
                switch result {
                case.success(let message):
                    PELogger.info(className: String(describing: PEViewModel.self) , message: message)
                    completionHandler?(message , nil)
                case .failure(let error):
                    PELogger.error(className: String(describing: PEViewModel.self) , message: error.value)
                    completionHandler?(nil, error)
                }
            }
        }
    }
    
    //MARK: - update dynamic segments
    
    func update(dynamic segments : [[String : Any]], completionHandler :((_ response : String? , _ error : Error?) -> ())?) {
        prerequesiteNetworkCallCheck {
            networkService.update(dynamic: segments) { result in
                switch result {
                case.success(let message):
                    PELogger.info(className: String(describing: PEViewModel.self) , message: message)
                    completionHandler?(message , nil)
                case .failure(let error):
                    PELogger.error(className: String(describing: PEViewModel.self) , message: error.value)
                    completionHandler?(nil, error)
                }
            }
        }
    }
    
    //MARK: - update segment hash Array
    
    func updateHashArray(for segmentId : Int) {
        prerequesiteNetworkCallCheck {
            networkService.segmentHashArray(for: segmentId)
        }
    }
    
    //MARK: - removeDynamic
    
   func removeDynamic(for segments : [String]) {
        prerequesiteNetworkCallCheck {
            networkService.removeDynamic(for: segments)
        }
    }
    
    //MARK: - update trigger status
    
  func updateTrigger(status : Bool , completionHandler :((_ response : String? , _ error : Error?) -> ())?) {
        prerequesiteNetworkCallCheck {
            networkService.updateTrigger(status: status) { result in
                switch result {
                case.success(let message):
                    PELogger.info(className: String(describing: PEViewModel.self) , message: message)
                    completionHandler?(message , nil)
                case .failure(let error):
                    PELogger.error(className: String(describing: PEViewModel.self) , message: error.value)
                    completionHandler?(nil, error)
                }
            }
        }
    }
    
    //MARK: - get subscriber details
    
   func getSubscriberDetails(for fields: [String],completionHandler :((_ response : [String : Any]? , _ error : Error?) -> ())?) {
        prerequesiteNetworkCallCheck {
            networkService.getSubscriber(for: fields) { (result) in
                switch result {
                case.success(let response):
                    PELogger.info(className: String(describing: PEViewModel.self) , message: response?.debugDescription ?? "")
                    completionHandler?(response , nil)
                case .failure(let error):
                    PELogger.error(className: String(describing: PEViewModel.self) , message: error.value)
                    completionHandler?(nil, error)
                }
            }
        }
    }
    
    //MARK:- check device token from subscriber hash
    
    func checkSubscriber(completionHandler : ((_ response : [String : Any]?, _ error : Error?)->())?) {
        prerequesiteNetworkCallCheck {
            networkService.checkSubscriber { result in
                switch result {
                case .success(let response):
                    PELogger.info(className: String(describing: PEViewModel.self) , message: response?.debugDescription ?? "")
                    completionHandler?(response , nil)
                case .failure(let error):
                    PELogger.error(className: String(describing: PEViewModel.self) , message: error.value)
                    completionHandler?(nil , error)
                }
            }
        }
    }
    
    //MARK: -update subsciber info with subscriber hash
    
    func updateSubsciber(completionHandler :((_ response : String? , _ error : Error?) -> ())?) {
        prerequesiteNetworkCallCheck {
            networkService.updateSubsciber { result in
                switch result {
                case.success(let message):
                    PELogger.info(className: String(describing: PEViewModel.self) , message: message)
                    completionHandler?(message , nil)
                case .failure(let error):
                    PELogger.error(className: String(describing: PEViewModel.self) , message: error.value)
                    completionHandler?(nil, error)
                }
            }
        }
    }
    
    //MARK: - best attempt handled
    
    func serviceExtensionTimeWillExpire(_ request : UNNotificationRequest ,content: UNMutableNotificationContent?) -> UNMutableNotificationContent? {
        return notificationExtensionService.serviceExtensionTimeWillExpire(request, content: content)
    }
    
}
