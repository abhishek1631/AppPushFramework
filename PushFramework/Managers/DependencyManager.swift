//
//  DependencyManager.swift
//  PushFramework
//
//  Created by Abhishek on 12/02/21.
//

import Foundation

struct DependencyManger : DependencyContainerProtocol {
    
    var notificationProvider: NotificationProtocol = NotificationService()
    var applicationProvider: ApplicationProtocol = ApplicationService()
}
