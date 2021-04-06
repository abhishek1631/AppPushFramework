//
//  PermissionListenerImpl.swift
//  PushFramework
//
//  Created by Abhishek on 23/02/21.
//

import Foundation

class ListenerImpl: Listener , CustomStringConvertible {
    
    public let name: String
    
    public init(name: String) {
        self.name = name
    }
    
    public var description: String {
        return "Listener(\(self.name))"
    }
    
    func permission<S>(_ service: S, didFinishWithSucess status : PermissonStatus) where S : PermissionProtocol {
        print("\(self) received permision result: \(status)")
    }
}
