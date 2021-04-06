//
//  UserDefaultManager.swift
//  PushFramework
//
//  Created by Abhishek on 19/02/21.
//

import Foundation


class  UserDefaultManager: UserDefaultProtocol {
    
    
    private let userDefaultSharedContainer = UserDefaults(suiteName: Utility.getAppGroupInfo)
    
    var deviceToken : String {
        get {
            return userDefaultSharedContainer?.string(forKey: UserDefaultConstant.deviceToken) ?? ""
        }
        
        set (value) {
            userDefaultSharedContainer?.set(value, forKey: UserDefaultConstant.deviceToken)
        }
    }
    
    var subscriberHash: String {
        get {
            return userDefaultSharedContainer?.string(forKey: UserDefaultConstant.subscriberHash) ?? ""
        }
        
        set(value) {
            userDefaultSharedContainer?.set(value, forKey: UserDefaultConstant.subscriberHash)
        }
    }
    
    var notificationPermissionState: PermissonStatus {
        get {
            let rawValue = userDefaultSharedContainer?.string(forKey: UserDefaultConstant.permissionState) ?? "notYetRequested"
            return PermissonStatus(rawValue: rawValue) ?? PermissonStatus.notYetRequested
        }
        
        set (value) {
            userDefaultSharedContainer?.set(value.rawValue, forKey: UserDefaultConstant.permissionState)
        }
    }
    
    var appId: String? {
        get {
            return userDefaultSharedContainer?.string(forKey: UserDefaultConstant.appId)
        }
        
        set (value){
            userDefaultSharedContainer?.setValue(value, forKey: UserDefaultConstant.appId)
        }
    }
    
    var geoLocationCountry : String? {
        get {
            return userDefaultSharedContainer?.string(forKey: UserDefaultConstant.country)
        } set (value){
            userDefaultSharedContainer?.setValue(value, forKey: UserDefaultConstant.country)
        }
    }
    
    var geoLocationState : String? {
        get {
            return userDefaultSharedContainer?.string(forKey: UserDefaultConstant.state)
        } set (value){
            userDefaultSharedContainer?.setValue(value, forKey: UserDefaultConstant.state)
        }
    }
    
    var geoLocationCity : String? {
        get {
            return userDefaultSharedContainer?.string(forKey: UserDefaultConstant.city)
        } set (value){
            userDefaultSharedContainer?.setValue(value, forKey: UserDefaultConstant.city)
        }
    }
}

extension UserDefaults {
    
    static func decodedObject<T: Codable>(type: T.Type, key: String) -> T? {
        guard let data = standard.data(forKey: key) else {
            return nil
        }
        let info = try? JSONDecoder().decode(T.self, from: data)
        return info
    }
}
