//
//  EndPointType.swift
//  PushFramework
//
//  Created by Abhishek on 17/02/21.
//

import Foundation

enum NotificationLifeAction {
    case viewed
    case clicked
}

public typealias Parameters = [String : Any]

enum PERouter {
    case subScriptionStatus(SubscriptionInfo)
    case getImage(String)
    case getSubscriberForfields((hash:String,fields:[String]))
    case checkSubscriberHash(String)
    case subscriberAttribute((hash : String,attributes :[String : Any]))
    case getSubsciberAttribute(String)
    case updateSubscriberStatus(SubscriberDetails)
    case addProfile(SubscriberDetails)
    case deleteAttributes((hash : String ,attributes :[String]))
    case subscriberUpgrade(Parameters)
    case addTimeZone(SubscriberDetails)
    case addSegments(SubscriberDetails)
    case removeSegment(SubscriberDetails)
    case dynamicSegment(SubscriberDetails)
    case segmentHashArray(SubscriberDetails)
    case removeDynamicSegment(SubscriberDetails)
    case updateTrigger(SubscriberDetails)
    case updateSubsciber((hash : String, info : SubscriptionInfo))
    
    //MARK: -
    case notificationCycleStatus((hash : String ,notificationId: String, action : NotificationLifeAction))
    case sponseredNotification(SponsoredPush)
    
    //MARK: -
    case triggerCampaigning(eventInfo : [String : Any])
    
    case none
    public func asURLRequest() throws -> URLRequest {
        
        //MARK: - HTTPMethod
        
        var method : HTTPMethod {
            switch self {
            case .subScriptionStatus,
                 .subscriberAttribute,
                 .updateSubscriberStatus,
                 .addProfile,
                 .addTimeZone,
                 .addSegments,
                 .removeSegment,
                 .dynamicSegment,
                 .segmentHashArray,
                 .removeDynamicSegment,
                 .updateTrigger,
                 .sponseredNotification:
                return .post
            case .getImage,
                 .getSubscriberForfields,
                 .checkSubscriberHash,
                 .getSubsciberAttribute,
                 .subscriberUpgrade,
                 .notificationCycleStatus:
                return .get
            case .deleteAttributes:
                return .delete
            case .updateSubsciber,
                 .triggerCampaigning:
                return .put
            default:
                return .get
            }
        }
        
        //MARK:- Parameters
        
        let params : Parameters? = {
            switch self {
            case .getSubscriberForfields(let fields):
                let queryParameterValue = fields.fields.joined(separator: ",")
                let parameter = ["fields": queryParameterValue]
                return parameter
            case .subscriberAttribute(let value):
                return value.attributes
            case .subscriberUpgrade(let value):
                let parameter = ["subscription" : value]
                return parameter
            case .updateTrigger, .addSegments , .removeSegment:
                let parameter = ["swv" : "0.0.4","bv" : Utility.getOSInfo]
                return parameter
            case .notificationCycleStatus(let notificationInfo):
                let parameter = ["device_token_hash" : notificationInfo.hash ,
                                 "tag" : notificationInfo.notificationId]
                return parameter
            case .triggerCampaigning(let eventInfo):
                let parameter = eventInfo
                return parameter
            default:
                return nil
            }
        }()
        
        //MARK:- URL
        
        let url : URL = {
            
            var relativePath : String?
            
            switch self {
            case .getImage(let path):
                let url = URL(string: path)!
                return url
            case .subScriptionStatus:
                relativePath = NetworkConstants.deviceTokenPath
            case .getSubscriberForfields(let fields):
                relativePath = String(format : NetworkConstants.getHashPath ,fields.hash)
            case .checkSubscriberHash(let hash):
                relativePath = String(format : NetworkConstants.checkSubscriberHash ,hash)
            case .subscriberAttribute(let attributeHash):
                relativePath = String(format: NetworkConstants.subscriberAttribute, attributeHash.hash)
            case .getSubsciberAttribute(let hash):
                relativePath = String(format: NetworkConstants.getSubscriberAttribute, hash)
            case .updateSubscriberStatus:
                relativePath = NetworkConstants.updateSubscriberStatus
            case .addProfile:
                relativePath = NetworkConstants.addProfileId
            case .deleteAttributes(let deleteInfo):
                relativePath = String(format: NetworkConstants.subscriberAttribute, deleteInfo.hash)
            case .subscriberUpgrade:
                relativePath = NetworkConstants.upgarde
            case .addTimeZone:
                relativePath = NetworkConstants.timeZone
            case .addSegments:
                relativePath = NetworkConstants.addSegment
            case .removeSegment:
                relativePath = NetworkConstants.removeSegment
            case .dynamicSegment:
                relativePath = NetworkConstants.dynamicAddSegment
            case .segmentHashArray:
                relativePath = NetworkConstants.segmentHashArray
            case .removeDynamicSegment:
                relativePath = NetworkConstants.dynamicRemoveSegment
            case .updateTrigger:
                relativePath = NetworkConstants.updateTrigger
            case .updateSubsciber(let hash):
                relativePath = String(format: NetworkConstants.updateSubscriber, hash.hash)
                
                //MARK: - Notification Cycle
                
            case .notificationCycleStatus(let action):
                if case .viewed = action.action {
                    relativePath = NetworkConstants.notificationView
                } else {
                    relativePath = NetworkConstants.notificationClicked
                }
            case .sponseredNotification:
                relativePath = NetworkConstants.sponsoreFetch
            default :
                break
            }
            var url = URL(string: NetworkConstants.baseURL)!
            if let relativePath = relativePath {
                url.appendPathComponent(relativePath)
            }
            return url
        }()
        
        //MARK:- HTTPHeader
        
        let header : HTTPHeaders = {
            var myHeaders: HTTPHeaders = Dictionary()
            //myHeaders[NetworkConstants.requestHeaderAuthorizationKey] = NetworkConstants.requestHeaderAuthorizationValue
            myHeaders[NetworkConstants.requestHeaderContentTypeKey] = NetworkConstants.requestHeaderContentTypeValue
            switch self {
            case .getImage,
                 .subScriptionStatus,
                 .getSubscriberForfields,
                 .checkSubscriberHash,
                 .subscriberAttribute,
                 .getSubsciberAttribute,
                 .updateSubscriberStatus,
                 .addProfile,.deleteAttributes,
                 .subscriberUpgrade,
                 .addTimeZone,
                 .addSegments,
                 .removeSegment,
                 .dynamicSegment,
                 .segmentHashArray,
                 .removeDynamicSegment,
                 .updateTrigger,
                 .updateSubsciber,
                 //MARK: - Trigger Campaigining
                 .triggerCampaigning:
                return myHeaders
            case .notificationCycleStatus(let actionStatus):
                if case .viewed = actionStatus.action {
                    myHeaders[NetworkConstants.requestHeaderRefererKey] = NetworkConstants.requestHeaderRefererValue
                }
                return myHeaders
            case .sponseredNotification:
                return myHeaders
            default:
                return Dictionary()
            }
        }()
        
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = header
        
        //MARK: - HttpBody into JSON.
        
        switch self {
        
        //MARK:- Subscriber APIs.
        
        case .subScriptionStatus(let value):
            try JSONParameterEncoder.encode(urlRequest: &urlRequest, with: value)
        case .getSubscriberForfields:
            try URLParameterEncoder.encode(urlRequest: &urlRequest, with: params ?? [:])
        case .subscriberAttribute:
            try JSONParameterEncoder.encode(urlRequest: &urlRequest, for: params ?? [:])
        case .deleteAttributes(let info):
            let data = try JSONSerialization.data(withJSONObject: info.attributes)
            urlRequest.httpBody = data
        case .updateSubscriberStatus(let status):
            try JSONParameterEncoder.encode(urlRequest: &urlRequest, with: status)
        case .addProfile(let profileDetails):
            try JSONParameterEncoder.encode(urlRequest: &urlRequest, with : profileDetails)
        case .subscriberUpgrade:
            try URLParameterEncoder.encode(urlRequest: &urlRequest, with: params ?? [:])
        case .addTimeZone(let timeZone):
            try JSONParameterEncoder.encode(urlRequest: &urlRequest, with: timeZone)
        case .addSegments(let segmentInfo):
            try JSONParameterEncoder.encode(urlRequest: &urlRequest, with: segmentInfo)
            try URLParameterEncoder.encode(urlRequest: &urlRequest, with: params ?? [:], isSortedDesc: true)
        case .removeSegment(let removingSegment):
            try JSONParameterEncoder.encode(urlRequest: &urlRequest, with: removingSegment)
            try URLParameterEncoder.encode(urlRequest: &urlRequest, with: params ?? [:], isSortedDesc: true)
        case .dynamicSegment(let segments):
            try JSONParameterEncoder.encode(urlRequest: &urlRequest, with: segments)
        case .segmentHashArray(let segmentArrayHash):
            try JSONParameterEncoder.encode(urlRequest: &urlRequest, with: segmentArrayHash)
        case .removeDynamicSegment(let removeSegment):
            try JSONParameterEncoder.encode(urlRequest: &urlRequest, with: removeSegment)
        case .updateTrigger(let triggerInfo):
            try JSONParameterEncoder.encode(urlRequest: &urlRequest, with: triggerInfo)
            try URLParameterEncoder.encode(urlRequest: &urlRequest, with: params ?? [:], isSortedDesc: true)
        case .updateSubsciber(let updatedInfo):
            try JSONParameterEncoder.encode(urlRequest: &urlRequest, with: updatedInfo.info)
            
            //MARK:- Notification cycle APIs.
            
        case .notificationCycleStatus:
            try URLParameterEncoder.encode(urlRequest: &urlRequest, with: params ?? [:])
        case .sponseredNotification(let sponserPostBack):
            try JSONParameterEncoder.encode(urlRequest: &urlRequest, with: sponserPostBack)
        
            //MARK: - Trigger Campaiginin
        
        case .triggerCampaigning:
            try JSONParameterEncoder.encode(urlRequest: &urlRequest, for: params ?? [:])
            
        default:
            break
        }
        return urlRequest
    }
    
}
