//
//  Constants.swift
//  PushFramework
//
//  Created by Abhishek on 17/02/21.
//

struct NetworkConstants {
    // MARK: - Request Timeout
    static let requestTimeout = 180.0

    static let accessTokenExpired: Int = 401

    // MARK: - API Parameters
    // MARK: - Keys
    static let requestParameterModeKey = "mode"
    static let requestParameterFormatKey = "format"
    
    // MARK: - Values
    static let requestParameterFormatValue = "json"

    // MARK: - API Headers
    // MARK: - Keys
    static let requestHeaderContentTypeKey = "Content-Type"
    static let requestHeaderAuthorizationKey = "Authorization"
    static let requestHeaderRefererKey = "referer"

    // MARK: - Values
    static let requestHeaderAuthorizationValue = "Bearer "
    static let requestHeaderContentTypeValue = "application/json"
    static let requestHeaderContentTypeValueForcharSet = "application/x-www-form-urlencoded; charset=utf-8"
    static let requestHeaderRefererValue = "https://pushengage.com/service-worker.js"

    // MARK: - BASE URL
    
    //This is for staging
    static let baseURL = "https://staging-dexter.pushengage.com"
    static let triggerCampaignBaseURL = "https://x9dlvh1zcg.execute-api.us-east-1.amazonaws.com"

    //MARK: - URL relative - path
    static let deviceTokenPath = "/p/v1/subscriber/add"
    static let getHashPath = "/p/v1/subscriber/%@/"
    static let checkSubscriberHash = "/p/v1/subscriber/check/%@"
    static let subscriberAttribute = "/p/v1/subscriber/%@/attributes"
    static let getSubscriberAttribute = "/p/v1/subscriber/%@/attributes"
    static let updateSubscriberStatus = "/p/v1/subscriber/updatesubscriberstatus"
    static let addProfileId = "/p/v1/subscriber/profile-id/add"
    static let upgarde = "/p/v1/subscriber/upgrade"
    static let timeZone = "/p/v1/subscriber/timezone/add"
    static let addSegment = "/p/v1/subscriber/segments/add"
    static let removeSegment = "/p/v1/subscriber/segments/remove"
    static let dynamicAddSegment = "/p/v1/subscriber/dynamicSegments/add"
    static let segmentHashArray = "/p/v1/subscriber/segments/segmentHashArray"
    static let dynamicRemoveSegment = "/p/v1/subscriber/dynamicSegments/remove"
    static let updateTrigger = "/p/v1/subscriber/updatetriggerstatus"
    static let updateSubscriber = "/p/v1/subscriber/%@"
    
    //MARK:- Notification relative path
    static let notificationView = "/p/v1/notification/view"
    static let notificationClicked = "/p/v1/notification/click"
    static let sponsoreFetch = "/p/v1/notification/fetch"
    
    //MARK: - Trigger Campaign relative path
    static let triggerRecords = "/beta/streams/staging-trigger/records"
}

struct PayloadConstants {
    
    static let attachmentKey = "attachment-url"
    static let deeplinkingKey = "deep-linking"
    static let sponsored = "sponsored"
}

struct  InfoPlistConstants {
    static let PushEngageInAppEnabled = "PushEngageInAppEnabled"
    static let locationWhenInUse = "NSLocationAlwaysAndWhenInUseUsageDescription"
    static let loactionAllow = "NSLocationWhenInUseUsageDescription"
    static let pushEngageAppGroupKey = "PushEngage_App_Group_Key"
}

struct UserDefaultConstant {
    
    static let deviceToken = "deviceToken"
    static let subscriberHash = "subscriberHash"
    static let permissionState = "notitficationPermission"
    static let appId = "AppId"
    static let country = "country"
    static let state = "state"
    static let city = "city"
    static let notificationId = "notificationId"
    
}

struct ParsingConstants {
    static let data = "data"
}

