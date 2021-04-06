//
//  LocationInfoProtocol.swift
//  PushFramework
//
//  Created by Abhishek on 15/03/21.
//

import Foundation

protocol LocationInfoProtocol {
    var locationInfoObserver : Variable<GeoLocationInfo> { get set }
}
