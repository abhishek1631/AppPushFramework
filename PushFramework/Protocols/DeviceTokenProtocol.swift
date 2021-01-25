//
//  DeviceTokenProtocol.swift
//  PushFramework
//
//  Created by Abhishek on 25/01/21.
//

import Foundation


protocol DeviceTokenProtocol {
    func getDeviceToken() -> String?
    func setDeviceToken(token : String)
}
