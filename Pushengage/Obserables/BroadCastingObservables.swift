//
//  Observable.swift
//  PushFramework
//
//  Created by Abhishek on 22/02/21.
//

import Foundation
import ObjectiveC

public func associatedValue<T>(for object : Any, key : UnsafeRawPointer, defaultValue: @autoclosure () -> T) -> T {
    return synchronized(object) {
        if let nonNilValue = objc_getAssociatedObject(object, key) {
            guard let typeSafeValue = nonNilValue  as? T else {
                fatalError("Unexpected: different kind of value already exists for key '\(key)': \(nonNilValue)")
            }
            return typeSafeValue
        } else {
            let newValue = defaultValue()
            objc_setAssociatedObject(object, key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            assert(objc_getAssociatedObject(object, key) != nil, "Associated values are not supported for object: \(object)")
            assert(objc_getAssociatedObject(object, key) is T, "Associated value could not be cast back to specified type: \(String(describing: T.self))")
            return newValue
        }
    }
}

private var observerSetKey = "app.com.pushengage.PushFramework.Observable.ObserverSet"

protocol Observable : class {
    
    associatedtype Observer
    
    var observers : [Observer] {get}
    
    func addObserver(_ observer : Observer) -> ObserverToken
    
    func removeObserver(_ observer : Observer)
    
    func notifyObservers(_ clousre : (Observer) -> Void)
}

extension Observable {
    
    private var observerSet : WeakSet<Observer> {
        return associatedValue(for: self, key: &observerSetKey, defaultValue: WeakSet<Observer>())
    }
    
    var observers : [Observer] {
        return observerSet.allObject
    }
    
    func addObserver(_ observer : Observer) -> ObserverToken {
        observerSet.add(observer)
        let ref = WeakReference(observer)
        let result = ObserverToken { [weak self] in
            self?.removeObserver(ref)
        }
        return result
    }
    
    func removeObserver(_ observer: Observer) {
            observerSet.remove(observer)
    }
    
    func notifyObservers(_ clousre : (Observer) -> Void) {
        for observer in observers {
            clousre(observer)
        }
    }
    
    private func removeObserver(_ reference : WeakReference<Observer>) {
        observerSet.remove(reference)
    }
}



struct ObserverToken : CustomStringConvertible {
    
    private let removalBlock : () -> Void
    private let identifier = UUID()
    
    fileprivate init(removalBlock : @escaping () -> Void) {
        
        self.removalBlock = removalBlock
    }
    
    func deregister() {
        removalBlock()
    }
    
    var description: String {
        return "ObserverToken(\(self.identifier))"
    }
    
}
