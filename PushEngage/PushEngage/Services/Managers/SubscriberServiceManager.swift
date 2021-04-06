//
//  SubscriberDatamanager.swift
//  PushFramework
//
//  Created by Abhishek on 25/02/21.
//

import Foundation
import SwiftKeychainWrapper

@objc public enum SegmentActions : Int {
    case update
    case remove
    case none
}

class SubscriberServiceManager :  SubscriberService {
    
    var datasourceProtocol : DataSourceProtocol
    var networkRouter : NetworkRouter
    var userDefault : UserDefaultProtocol
    
    init(_datasourceProtocol : DataSourceProtocol,
         _networkRouter : NetworkRouter,
         _userDefault : UserDefaultProtocol) {
        self.datasourceProtocol = _datasourceProtocol
        self.networkRouter = _networkRouter
        self.userDefault = _userDefault
    }
    
    func addSubscriber(completionHandler : ServiceCallBack? = nil) {
        let data = datasourceProtocol.getSubscriptionData()
        networkRouter.request(.subScriptionStatus(data),for : NetworkResponse.self) { [weak self] result in
            switch result {
            case .success(let data) :
                do {
                    let decodeData = try JSONDecoder().decode(HashResponse.self, from: data)
                    self?.userDefault.subscriberHash = decodeData.data.subscriberHash ?? ""
                    PELogger.debug(className: String(describing: SubscriberServiceManager.self), message: data.base64EncodedString())
                    let paramData = Utility.convert(data: data)
                    completionHandler?(.success(paramData?[ParsingConstants.data] as? Parameters))
                } catch {
                    PELogger.error(className: String(describing: SubscriberServiceManager.self), message: PEError.parsingError.value)
                    completionHandler?(.failure(PEError.parsingError))
                }
            case .failure(let error):
                PELogger.error(className: String(describing: SubscriberServiceManager.self), message: error.value)
                completionHandler?(.failure(error))
            }
        }
    }
    
    func updateSubsciber(completionHandler : @escaping ServiceCallWithMessage) {
        var data = datasourceProtocol.getSubscriptionData()
        data.subscription = nil
        data.geoInfo?.geobytescity = "meerut"
        let value = (userDefault.subscriberHash , data)
        networkRouter.request(.updateSubsciber(value),for : NetworkResponse.self) { result in
            switch result {
            case .success(let data):
                PELogger.debug(className: String(describing: SubscriberServiceManager.self), message: data.base64EncodedString())
                completionHandler(.success("updated subscriber successfully"))
            case .failure(let error):
                PELogger.error(className: String(describing: SubscriberServiceManager.self), message: error.value)
                completionHandler(.failure(error))
            }
        }
    }
    
    func checkSubscriber(completionHandler : @escaping ServiceCallBack) {
        networkRouter.request(.checkSubscriberHash(userDefault.subscriberHash),for : NetworkResponse.self) { result in
            switch result {
            case .success(let data):
                PELogger.debug(className: String(describing: SubscriberServiceManager.self), message: data.base64EncodedString())
                let paramData = Utility.convert(data: data)
                completionHandler(.success(paramData?[ParsingConstants.data] as? Parameters))
            case .failure(let error):
                PELogger.error(className: String(describing: SubscriberServiceManager.self), message: error.value)
                completionHandler(.failure(error))
            }
        }
    }
    
    func getSubscriber(for fields : [String],completionHandler : @escaping ServiceCallBack)  {
        networkRouter.request(.getSubscriberForfields((userDefault.subscriberHash , fields)),for : NetworkResponse.self) { result in
            switch result {
            case .success(let data):
                PELogger.debug(className: String(describing: SubscriberServiceManager.self), message: data.base64EncodedString())
                let paramData = Utility.convert(data: data)
                completionHandler(.success(paramData?[ParsingConstants.data] as? Parameters))
            case .failure(let error):
                PELogger.error(className: String(describing: SubscriberServiceManager.self), message: error.value)
                completionHandler(.failure(error))
            }
        }
    }
    
    func update(attributes: Parameters ,completionHandler : @escaping ServiceCallWithMessage) {
        networkRouter.request(.subscriberAttribute((userDefault.subscriberHash , attributes)),for : NetworkResponse.self) { (result) in
            switch result {
            case .success(let data):
                PELogger.debug(className: String(describing: SubscriberServiceManager.self), message: data.base64EncodedString())
                completionHandler(.success("Attribute updated successfully"))
            case .failure(let error):
                PELogger.error(className: String(describing: SubscriberServiceManager.self), message: error.value)
                completionHandler(.failure(error))
            }
        }
    }

    func getAttribute(completionHandler : @escaping ServiceCallBack) {
        networkRouter.request(.getSubsciberAttribute(userDefault.subscriberHash),for : NetworkResponse.self) { (result) in
            switch result {
            case .success(let data):
                let jsonDic = Utility.convert(data: data)
                completionHandler(.success(jsonDic?[ParsingConstants.data] as? Parameters))
                PELogger.debug(className: String(describing: SubscriberServiceManager.self), message: data.base64EncodedString())
            case .failure(let error):
                PELogger.error(className: String(describing: SubscriberServiceManager.self), message: error.value)
                completionHandler(.failure(error))
            }
        }
    }
    
    func updateSubscriberStatus(completionHandler : ServiceCallWithMessage? = nil) {
        var state : Int = 0
        if case .granted = userDefault.notificationPermissionState {
            state = 1
        }
        var bodyData = datasourceProtocol.getSubscriptionStatus()
        bodyData.isUnSubscribed = state
        networkRouter.request(.updateSubscriberStatus(bodyData),for : NetworkResponse.self) { (result) in
            switch result {
            case .success(let data):
                PELogger.debug(className: String(describing: SubscriberServiceManager.self), message: data.description)
                completionHandler?(.success("SubscriberStatus Update to \(state)"))
            case .failure(let error):
                completionHandler?(.failure(error))
                PELogger.error(className: String(describing: SubscriberServiceManager.self), message: error.value)
            }
        }
        
    }
    
    func addProfile(id : String, completionHandler : @escaping ServiceCallWithMessage) {
        var profileDetails = datasourceProtocol.getSubscriptionStatus()
        profileDetails.profileId = id
        networkRouter.request(.addProfile(profileDetails),for : NetworkResponse.self) { (result) in
            switch result {
            case .success(let data):
                PELogger.debug(className: String(describing: SubscriberServiceManager.self), message: data.description)
                completionHandler(.success("updated profile id \(id)"))
            case .failure(let error):
                PELogger.error(className: String(describing: SubscriberServiceManager.self), message: error.value)
                completionHandler(.failure(error))
            }
        }
    }
    
    func deleteAttribute(with values : [String], completionHandler : @escaping ServiceCallWithMessage) {
        networkRouter.request(.deleteAttributes((userDefault.subscriberHash, values)),for : NetworkResponse.self) { (result) in
            switch result {
            case .success(let data):
                PELogger.debug(className: String(describing: SubscriberServiceManager.self), message: data.description)
                completionHandler(.success(String(format: "Successfully deleted %@ attribites", values.count == 0 ? "all" : values.joined(separator: ","))))
            case .failure(let error):
                PELogger.error(className: String(describing: SubscriberServiceManager.self), message: error.value)
                completionHandler(.failure(error))
            }
        }
    }
    
    
    func upgradeSubscription(completion : @escaping (Bool) -> Void) {
        
        let value = ["endpoint" : userDefault.deviceToken ,
                     "project_id":Utility.getBundleIdentifier]
        networkRouter.request(.subscriberUpgrade(value as Parameters),for : NetworkResponse.self) { (result) in
            switch result {
            case .success:
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
    
    func updateTimeZone() {
        var timeZoneInfo = datasourceProtocol.getSubscriptionStatus()
        timeZoneInfo.timezone = Utility.timeOffSet
        networkRouter.request(.addTimeZone(timeZoneInfo),for : NetworkResponse.self) { (result) in
            switch result {
            case .success(let data):
                PELogger.debug(className: String(describing: SubscriberServiceManager.self), message: data.description)
            case .failure(let error):
                PELogger.error(className: String(describing: SubscriberServiceManager.self), message: error.value)
            }
        }
    }
    
    func update(segments : [String] , action : SegmentActions , completionHandler : @escaping ServiceCallWithMessage) {
        var subscriberInfo = datasourceProtocol.getSubscriptionStatus()
        subscriberInfo.deviceType = "iOS-device"
        subscriberInfo.segment = segments
        var route = PERouter.none
        switch action {
        case .remove:
            route = .removeSegment(subscriberInfo)
        case .update:
            route = .addSegments(subscriberInfo)
        default:
            break
        }
        networkRouter.request(route,for : NetworkResponse.self) { (result) in
            switch result {
            case .success(let data):
                PELogger.debug(className: String(describing: SubscriberServiceManager.self), message: data.description)
                let actionValue = action == .remove ? "removed" : "added"
                completionHandler(.success(String(format: "segmets %@ \(actionValue) successfully", segments.joined(separator: ","))))
            case .failure(let error):
                PELogger.error(className: String(describing: SubscriberServiceManager.self), message: error.value)
                completionHandler(.failure(error))
            }
        }
    }
    
    func update(dynamic segmentInfo : [Parameters], completionHandler : @escaping ServiceCallWithMessage) {
        do {
            let data = try JSONSerialization.data(withJSONObject: segmentInfo, options: .prettyPrinted)
            let encodedSegment = try JSONDecoder().decode([Segment].self, from: data)
            var dynamicInfo = datasourceProtocol.getSubscriptionStatus()
            dynamicInfo.segments = encodedSegment
            dynamicInfo.deviceToken = userDefault.deviceToken
            dynamicInfo.deviceTokenHash = nil
            networkRouter.request(.dynamicSegment(dynamicInfo),for : NetworkResponse.self) { (result) in
                switch result {
                case .success(let data):
                    PELogger.debug(className: String(describing: SubscriberServiceManager.self), message: data.description)
                    completionHandler(.success("Successfully added dynamic segemts"))
                case .failure(let error):
                    PELogger.error(className: String(describing: SubscriberServiceManager.self), message: error.value)
                    completionHandler(.failure(error))
                }
            }
        } catch let error {
            PELogger.error(className: String(describing: SubscriberServiceManager.self), message: error.localizedDescription)
            completionHandler(.failure(PEError.dataEncodeingFailed))
        }
        
    }
    
    func segmentHashArray(for segmentId : Int) {
        var segmentHashArrayInfo = datasourceProtocol.getSubscriptionStatus()
        segmentHashArrayInfo.segmentId = segmentId
        networkRouter.request(.segmentHashArray(segmentHashArrayInfo), for : NetworkResponse.self) { (result) in
            switch result {
            case .success(let data):
                PELogger.debug(className: String(describing: SubscriberServiceManager.self), message: data.description)
            case .failure(let error):
                PELogger.error(className: String(describing: SubscriberServiceManager.self), message: error.value)
            }
        }
    }
    
    func removeDynamic(for segments : [String]) {
        var segmentToRemove = datasourceProtocol.getSubscriptionStatus()
        segmentToRemove.segment = segments
        segmentToRemove.deviceType = "iOS-device"
        segmentToRemove.deviceTokenHash = nil
        segmentToRemove.deviceToken = userDefault.deviceToken
        networkRouter.request(.removeDynamicSegment(segmentToRemove),for : NetworkResponse.self) { (result) in
            switch result {
            case .success(let data):
                PELogger.debug(className: String(describing: SubscriberServiceManager.self), message: data.description)
            case .failure(let error):
                PELogger.error(className: String(describing: SubscriberServiceManager.self), message: error.value)
            }
        }
    }
    
    func updateTrigger(status : Bool , completionHandler : @escaping ServiceCallWithMessage) {
        var triggerStatusInfo = datasourceProtocol.getSubscriptionStatus()
        triggerStatusInfo.triggerStatus = status == true ? 1 : 0
        networkRouter.request(.updateTrigger(triggerStatusInfo),for : NetworkResponse.self) { (result) in
            switch result {
            case .success(let data):
                PELogger.debug(className: String(describing: SubscriberServiceManager.self), message: data.description)
                completionHandler(.success("trigger successfully updated to \(NSNumber(value: status))"))
            case .failure(let error):
                PELogger.error(className: String(describing: SubscriberServiceManager.self), message: error.value)
                completionHandler(.failure(error))
            }
        }
    }
}
