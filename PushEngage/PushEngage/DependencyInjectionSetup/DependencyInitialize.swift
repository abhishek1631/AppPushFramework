//
//  DependencyInitialize.swift
//  PushFramework
//
//  Created by Abhishek on 26/02/21.
//

import Foundation

//MARK: -private class for Dependency Initialization
internal final class DependencyInitialize {
    
    private var container : Container
    
    init() {
        
        container = Container()
            
            //MARK: -LocationProtocol
            
            .register(LocationInfoProtocol.self) { _  in
                LocationManager()
            }
            
            //MARK:- UserDefaultProtocol
            
            .register(UserDefaultProtocol.self) {_ in
                UserDefaultManager()
            }
            
            //MARK:- NetworkRouter
            
            .register(NetworkRouter.self) { _ in
                Router()
            }
            
            //MARK:- PEPayloadProtocol
            
            .register(PEPayloadProtocol.self) { _ in
                PayLoadManager()
            }
            
            //MARK:- NotificationProtocol
            
            .register(NotificationProtocol.self) { _ in
                NotificationService()
            }
            
            //MARK:- DataSourceProtocol
            
            .register(DataSourceProtocol.self) { resolver in
                let  userDefault = resolver.resolve(UserDefaultProtocol.self)
                return DataManager(_userDefault: userDefault)
            }
            
            //MARK:- SubscriberService
            
            .register(SubscriberService.self) { resolver in
                let datasource = resolver.resolve(DataSourceProtocol.self)
                let networkRouter = resolver.resolve(NetworkRouter.self)
                let userDefault = resolver.resolve(UserDefaultProtocol.self)
                return SubscriberServiceManager(_datasourceProtocol: datasource,
                                          _networkRouter: networkRouter,
                                          _userDefault: userDefault)
            }
            
            //MARK:- ApplicationProtocol
            
            .register(ApplicationProtocol.self) { resolve in
                let userDefault = resolve.resolve(UserDefaultProtocol.self)
                let networkDatasource = resolve.resolve(SubscriberService.self)
                return ApplicationService(_userDefault: userDefault,
                                          _networkDatasource: networkDatasource)
            }
            
            //MARK:- NotificationLifeCycleService
        
            .register(NotificationLifeCycleService.self) { resolver in
                let networkRouter = resolver.resolve(NetworkRouter.self)
                let datasource = resolver.resolve(DataSourceProtocol.self)
                return NotificationLifeCycleManager(_networkRouter: networkRouter,
                                                    _datasource: datasource)
            }
            
            //MARK:- NotificationExtensionProtocol
            
            .register(NotificationExtensionProtocol.self) { resolver in
                let networkRouter = resolver.resolve(NetworkRouter.self)
                let payLoad = resolver.resolve(PEPayloadProtocol.self)
                let notificationService = resolver.resolve(NotificationProtocol.self)
                let userDefaultService = resolver.resolve(UserDefaultProtocol.self)
                let notificationCycleService = resolver.resolve(NotificationLifeCycleService.self)
                return NotificationExtensionManager(_networkService: networkRouter,
                                                    _payLoadService: payLoad,
                                                    _notificationService: notificationService,
                                                    _notifcationLifeCycleService: notificationCycleService,
                                                    _userDefaultDatasource: userDefaultService)
            }
        
    }
    
    func getNotificationLifeCycleService() -> NotificationLifeCycleService {
        return container.resolve(NotificationLifeCycleService.self)
    }
    
    func getApplicationService() -> ApplicationProtocol {
        return container.resolve(ApplicationProtocol.self)
    }
    
    func getNotificationService() -> NotificationProtocol {
        return container.resolve(NotificationProtocol.self)
    }
    
    func getNotificationExtension() -> NotificationExtensionProtocol {
        return container.resolve(NotificationExtensionProtocol.self)
    }
    
    func getNetworkDataService() -> SubscriberService {
        return container.resolve(SubscriberService.self)
    }
    
    func getUserDefaultService() -> UserDefaultProtocol {
        return container.resolve(UserDefaultProtocol.self)
    }
    
    func getLocationService() -> LocationInfoProtocol {
        return container.resolve(LocationInfoProtocol.self)
    }
}
