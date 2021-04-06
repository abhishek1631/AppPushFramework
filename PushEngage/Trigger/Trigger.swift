//
//  Trigger.swift
//  PushEngage
//
//  Created by Abhishek on 06/04/21.
//

import Foundation

final class Trigger {
    
    static let shared = Trigger()
    
    init() {
        print("Trigger")
    }
    
    public func name() {
        print("Abhishek")
    }
}
