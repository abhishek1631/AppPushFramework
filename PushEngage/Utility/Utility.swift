//
//  Utility.swift
//  PushFramework
//
//  Created by Abhishek on 25/02/21.
//

import Foundation
import UIKit

struct Utility {
    
    static var getBundleIdentifier : String {
        return Bundle.main.bundleIdentifier ?? ""
    }
    
    static var getApplicationName : String {
        let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        return appName ?? ""
    }
    
    static var getPhoneName : String {
        return UIDevice.current.model
    }
    
    static var getOSInfo : String {
        let os = ProcessInfo().operatingSystemVersion
        return String(os.majorVersion) + "." + String(os.minorVersion) + "." + String(os.patchVersion)
    }
    
    static var getAppVersionInfo : String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        return version + "(" + build + ")"
    }
    
    static var timeOffSet : String {
        let timeZone = TimeZone(secondsFromGMT: TimeZone.autoupdatingCurrent.secondsFromGMT())
        let timeZoneIdentifier = timeZone!.identifier
        let timeOffset = String(timeZoneIdentifier.dropFirst(3))
        var offset = ""
        for (index , value) in timeOffset.enumerated() {
            offset.append(value)
            if timeOffset.count - index == 3 {
                offset.append(":")
            }
        }
        return offset
    }
    
    static func convert(data : Data)  -> Parameters?  {
        do {
            let jsonDic =  try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return jsonDic as? Parameters
        } catch {
            PELogger.debug(className: String(describing: Utility.self), message: PEError.dataEncodeingFailed.value)
            return nil
        }
    }
    
    
    static var totalScrWidthHeight : String {
        return "\(UIScreen.main.bounds.width) x \(UIScreen.main.bounds.height)"
    }
    
    static var inAppPermissionStatus : Bool {
        let permissionValue = Bundle.main.object(forInfoDictionaryKey: InfoPlistConstants.PushEngageInAppEnabled) as? Bool
        return permissionValue ?? false
    }
    
    static var isLocationPrivcyEnabled : Bool {
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            let dictinory = NSDictionary(contentsOfFile: path)
            let isArrayOfKeycontains = dictinory?.allKeys.compactMap { key -> String? in
                if let value = key as? String {
                    return value
                } else {
                    return nil
                }
            }.contains{ (value) -> Bool in
                if value == InfoPlistConstants.loactionAllow || value == InfoPlistConstants.locationWhenInUse {
                    return true
                } else {
                    return false
                }
            }
            return isArrayOfKeycontains ?? false
        } else {
            return false
        }
    }
    
    
    static var getAppGroupInfo : String {
        if let appGroup = Bundle.main.object(forInfoDictionaryKey: InfoPlistConstants.pushEngageAppGroupKey) as? String {
            return appGroup
        } else {
            return String(format: "group.%@.pushEngage", Utility.getBundleIdentifier)
        }
    }
}
