//
//  UserDefaultProtocol.swift
//  PushFramework
//
//  Created by Abhishek on 19/02/21.
//

import Foundation

protocol UserDefaultProtocol {
    
    var deviceToken : String { get set }
    var subscriberHash : String { get set }
    var notificationPermissionState : PermissonStatus { get set }
    var appId : String? { get set }
    var geoLocationCountry : String? { get set }
    var geoLocationState : String? { get set }
    var geoLocationCity : String? { get set }
}
