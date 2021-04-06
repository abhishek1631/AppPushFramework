//
//  DataManager.swift
//  PushFramework
//
//  Created by Abhishek on 25/02/21.
//

import Foundation
import SwiftKeychainWrapper


class DataManager:  DataSourceProtocol {
    
    var userDefault : UserDefaultProtocol
    
    init(_userDefault : UserDefaultProtocol) {
        self.userDefault = _userDefault
    }
    
    func getSubscriptionData() -> SubscriptionInfo {
        let subcriptionInfo = SubscriptionInfo(siteID: 49438,
                                               browserInfo: BrowserInfo(deviceType: "iOS-device",
                                                                        browserVersion: Utility.getOSInfo,
                                                                        userAgent: nil,
                                                                        language: Locale.current.languageCode,
                                                                        totalScrWidthHeight: Utility.totalScrWidthHeight,
                                                                        availableScrWidthHeight: Utility.totalScrWidthHeight,
                                                                        colourResolution: nil,
                                                                        host: nil,
                                                                        device: Utility.getPhoneName,
                                                                        peRefURL: nil),
                                               subscription: Subscription(endpoint: userDefault.deviceToken,
                                                                          projectID: Utility.getBundleIdentifier),
                                               subscriptionURL: Utility.getApplicationName,
                                               geoInfo: GeoInfo(geobytestimezone: Utility.timeOffSet, geobytescountry: userDefault.geoLocationCountry, geobytesinternet: nil, geobytesregion: userDefault.geoLocationState, geobytescode: nil, geobytescity: userDefault.geoLocationCity, geobytesfqcn: nil, geobytesipaddress: nil),
                                               tokenRefresh: false,
                                               optinType: nil)
        return subcriptionInfo
    }
    
    func getSubscriptionStatus() -> SubscriberDetails {
        let status = SubscriberDetails(siteID: 49438,
                                      deviceTokenHash: userDefault.subscriberHash)
        return status
    }
    
    func getPostBackSubscriptionData() -> SponsoredPush {
        let sponsoredPush = SponsoredPush(tag: "S-27-12", postback: Postback(isSponsored: 1, network: "taboola", publisher: "pushengage1-new", siteSubdomain: "demo", siteURL: "https://www.pushengage.com", deviceType: "ios-device", deviceTokenHash: "557cd36e4cfd0e6dbd3115de228c27b8513c80f8550aaafa7d8f94323b36ea47", userAgent: nil))
        return sponsoredPush
    }
}
