//
//  Postback.swift
//  PushFramework
//
//  Created by Abhishek on 25/03/21.
//

import Foundation

// MARK: - SponsoredPush

struct SponsoredPush : Codable {
    var tag: String
    var postback: Postback
}

// MARK: - Postback
struct Postback: Codable {
    var isSponsored: Int
    var network, publisher, siteSubdomain: String?
    var siteURL: String?
    var deviceType : String?
    var deviceTokenHash : String
    var userAgent: String?

    enum CodingKeys: String, CodingKey {
        case isSponsored = "is_sponsored"
        case network, publisher
        case siteSubdomain = "site_subdomain"
        case siteURL = "site_url"
        case deviceType = "device_type"
        case deviceTokenHash = "device_token_hash"
        case userAgent = "user_agent"
    }
}




// MARK: - SponsoredResponse
struct SponsoredResponse: Codable {
    var errorCode: Int
    var data: [Datum]

    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case data
    }
}

// MARK: - Datum
struct Datum: Codable {
    var title: String
    var options: Options
}

// MARK: - Options
struct Options: Codable {
    var body: String
    var icon: String
    var tag: String
    var data: String
    var requireInteraction: Bool
}
