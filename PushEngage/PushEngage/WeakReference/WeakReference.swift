//
//  WeakReference.swift
//  PushFramework
//
//  Created by Abhishek on 22/02/21.
//

import Foundation

//MARK:- Alternate of @synchronized

@discardableResult
func synchronized<T>(_ object: Any, block: () throws -> T) rethrows -> T {
    objc_sync_enter(object)
    defer {
        objc_sync_exit(object)
    }
    return try block()
}

/**
 Wrapper around an object reference to prevent it being strongly retained.
 */

final class WeakReference<T> : NSObject {
    
    ///Target object, which may be nil if deallocated.
    var target : T? {
        return _targetObj as? T
    }
    
    /// Internal weak reference.
    private weak var _targetObj : AnyObject?
    
    /// Internal storage of memory address.
    private let _memoryAddress : Int
    
    /// Initialization of the memory for target object.
    init(_ target: T) {
        self._memoryAddress = unsafeBitCast(target as AnyObject, to: Int.self)
        self._targetObj = target as AnyObject
        super.init()
    }
    
    override var hash: Int {
        return _memoryAddress
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let ref =  object as? WeakReference {
            return self._memoryAddress == ref._memoryAddress
        }
        return false
    }
}
