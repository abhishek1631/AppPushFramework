//
//  NotificationLifeCycleService.swift
//  PushFramework
//
//  Created by Abhishek on 18/03/21.
//

import Foundation

typealias NotificationCallMessage = (Result<String , PEError>) -> Void
typealias NotificationCallResponse<T : Codable> = (Result<T , PEError>) -> Void

protocol NotificationLifeCycleService {
    func notificationLifecycleUpdate(with action :NotificationLifeAction , deviceHash : String ,notificationId : String , completionHandler : NotificationCallMessage?)
    func sponseredNotification<T : Codable>(for type : T.Type , completionHandler : @escaping NotificationCallResponse<T>)
    func canceled() 
}
