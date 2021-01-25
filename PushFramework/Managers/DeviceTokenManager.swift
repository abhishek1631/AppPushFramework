//
//  DeviceTokenManager.swift
//  PushFramework
//
//  Created by Abhishek on 25/01/21.
//

import Foundation
import SwiftKeychainWrapper


class DeviceTokenManager : DeviceTokenProtocol {
    
    func getDeviceToken() -> String? {
        return KeychainWrapper.standard.string(forKey: .deviceTokenKey)
    }
    
    func setDeviceToken(token: String) {
        KeychainWrapper.standard[.deviceTokenKey] = token
    }

}



