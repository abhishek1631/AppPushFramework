//
//  PermissionListener.swift
//  PushFramework
//
//  Created by Abhishek on 23/02/21.
//

import Foundation

protocol Listener {
    func permission<S: PermissionProtocol>(_ service : S , didFinishWithSucess status : PermissonStatus)
}
