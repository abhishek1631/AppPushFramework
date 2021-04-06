//
//  PermissionManager.swift
//  PushFramework
//
//  Created by Abhishek on 23/02/21.
//

import Foundation

class PermissionManager : PermissionProtocol {
    public typealias Observer = Listener

    func permissionStatus(status : PermissonStatus) {
        self.broadCastPermissionStatus(status: status)
    }
    
    private func broadCastPermissionStatus(status : PermissonStatus) {
        notifyObservers {
            $0.permission(self, didFinishWithSucess: status)
        }
    }
}
