//
//  Subscription.swift
//  PushFramework
//
//  Created by Abhishek on 21/02/21.
//

import Foundation

import Foundation

// MARK: - SubscriptionInfo
struct SubscriptionInfo : Codable {
    let siteID: Int
    let browserInfo: BrowserInfo
    var subscription: Subscription?
    let subscriptionURL: String?
    var geoInfo: GeoInfo?
    let tokenRefresh: Bool
    let optinType: Int?

    enum CodingKeys: String, CodingKey {
        case siteID = "site_id"
        case browserInfo = "browser_info"
        case subscription
        case subscriptionURL = "subscription_url"
        case geoInfo = "geo_info"
        case tokenRefresh = "token_refresh"
        case optinType = "optin_type"
    }
}

// MARK: - BrowserInfo
struct BrowserInfo: Codable {
    let deviceType : String
    let browserVersion, userAgent, language: String?
    let totalScrWidthHeight, availableScrWidthHeight: String?
    let colourResolution: Int?
    let host, device: String?
    let peRefURL: String?

    enum CodingKeys: String, CodingKey {
        case deviceType = "device_type"
        case browserVersion = "browser_version"
        case userAgent = "user_agent"
        case language
        case totalScrWidthHeight = "total_scr_width_height"
        case availableScrWidthHeight = "available_scr_width_height"
        case colourResolution = "colour_resolution"
        case host, device
        case peRefURL = "pe_ref_url"
    }
}

// MARK: - GeoInfo
struct GeoInfo: Codable {
    var geobytestimezone, geobytescountry, geobytesinternet, geobytesregion: String?
    var geobytescode, geobytescity, geobytesfqcn, geobytesipaddress: String?
}

// MARK: - Subscription
struct Subscription: Codable {
    let endpoint, projectID: String

    enum CodingKeys: String, CodingKey {
        case endpoint
        case projectID = "project_id"
    }
}

// MARK: - HashResponse 

struct HashResponse: Codable {
    let errorCode: Int
    let data: DataClass

    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case data
    }
}

// MARK: - DataClass
struct DataClass: Codable {
    let subscriberHash: String?
    let gatewayEndpoint: String?

    enum CodingKeys: String, CodingKey {
        case subscriberHash = "subscriber_hash"
        case gatewayEndpoint = "gateway_endpoint"
    }
}

