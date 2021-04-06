//
//  PermissionProtocol.swift
//  PushFramework
//
//  Created by Abhishek on 23/02/21.
//

import Foundation

protocol PermissionProtocol : Observable where Observer == Listener {
    
    func permissionStatus(status : PermissonStatus)
}
