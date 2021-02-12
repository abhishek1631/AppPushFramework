//
//  DependencyContainerProtocol.swift
//  PushFramework
//
//  Created by Abhishek on 12/02/21.
//

import Foundation

protocol DependencyContainerProtocol {
    var notificationProvider : NotificationProtocol { get  set}
    var applicationProvider : ApplicationProtocol {  get }
}

