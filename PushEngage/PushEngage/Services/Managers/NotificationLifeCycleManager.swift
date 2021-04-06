//
//  NotificationLifeCycleManager.swift
//  PushFramework
//
//  Created by Abhishek on 19/03/21.
//

import Foundation

class NotificationLifeCycleManager : NotificationLifeCycleService {
    
    
    let networkRouter : NetworkRouter
    let datasource : DataSourceProtocol
    
    init(_networkRouter : NetworkRouter,
         _datasource : DataSourceProtocol) {
        self.networkRouter = _networkRouter
        self.datasource = _datasource
    }
    
    func notificationLifecycleUpdate(with action :NotificationLifeAction , deviceHash : String ,notificationId : String , completionHandler : NotificationCallMessage?) {
        let fetchNotificationInfo = (hash: deviceHash, notificationId: notificationId , action : action)
        networkRouter.request(.notificationCycleStatus(fetchNotificationInfo), for : NetworkResponse.self) { result in
            switch result {
            case .success(let data):
                PELogger.debug(className: String(describing: NotificationLifeCycleManager.self), message: data.base64EncodedString())
                completionHandler?(.success("Notification viewed successfully"))
            case .failure(let error):
                PELogger.error(className: String(describing: NotificationLifeCycleManager.self), message: error.value)
                completionHandler?(.failure(error))
            }
        }
    }
    
    func sponseredNotification<T : Codable>(for type : T.Type , completionHandler : @escaping NotificationCallResponse<T>) {
        let sponseredData = datasource.getPostBackSubscriptionData()
        networkRouter.request(.sponseredNotification(sponseredData),for : T.self) { (result) in
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(T.self, from: data)
                    completionHandler(.success(response))
                } catch  {
                    completionHandler(.failure(.parsingError))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func canceled()  {
        networkRouter.cancel()
    }
}
