//
//  Permission.swift
//  PushFramework
//
//  Created by Abhishek on 21/02/21.
//

import Foundation

struct SubscriberDetails : Codable {
    
    var siteID: Int?
    var deviceToken : String? = nil
    var deviceTokenHash: String?
    var isUnSubscribed: Int? = nil
    var triggerStatus : Int? = nil
    var profileId : String? = nil
    var timezone : String? = nil
    var deviceType : String? = nil
    var segment : [String]? = nil
    var segments : [Segment]? = nil
    var segmentId : Int? = nil
    
    enum CodingKeys: String, CodingKey {
        case siteID = "site_id"
        case deviceTokenHash = "device_token_hash"
        case isUnSubscribed = "IsUnSubscribed"
        case triggerStatus = "triggerStatus"
        case profileId = "profile_id"
        case timezone = "timezone"
        case deviceType = "device_type"
        case segment = "segment"
        case segments = "segments"
        case deviceToken = "device_token"
        case segmentId = "segment_id"
        
    }
}

struct Segment: Codable {
    let name: String
    let duration: Int
    
    enum CodingKeys : String , CodingKey {
        case name
        case duration
    }
}

