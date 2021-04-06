//
//  WeakSet.swift
//  PushFramework
//
//  Created by Abhishek on 22/02/21.
//

import Foundation

final class WeakSet<T> :  ExpressibleByArrayLiteral {
    
    private let _mutex = NSObject()

    convenience required init(arrayLiteral elements: T...) {
            self.init(elements)
    }
    
    fileprivate var _contents = NSMutableSet()
    
    var count : Int {
        return _contents.count
    }
    
    init(){}
    
    init<S: Sequence>(_ sequence: S) where S.Iterator.Element == T {
        for element in sequence {
            _contents.add(WeakReference(element))
        }
    }
    
    func add(_ object : T ) {
        add(WeakReference(object))
    }
    
    func add(_ reference: WeakReference<T>) {
        return synchronized(_mutex) {
            //Remove the existing ref first, this is delicate, because a lingering reference might exist
            //for which the reference is nil, but it is still in the set nonetheless
            _contents.remove(reference)
            _contents.add(reference)
        }
    }
    
    func remove(_ object : T) {
        remove(WeakReference(object))
    }
    
    func remove(_ reference : WeakReference<T>) {
        _contents.remove(reference)
    }
    
    func contains(_ object : T) -> Bool {
        let ref = WeakReference(object)
        return contains(ref) && ref.target != nil
    }
    
    func contains(_ reference: WeakReference<T>) -> Bool {
        return _contents.contains(reference)
    }
    
    func compress() -> Bool {
        var removedElement = false
        for element in _contents.copy() as! NSSet {
            if let ref = element as? WeakReference<T>, ref.target != nil {
                //Keep
            } else {
                //Remove
                _contents.remove(element)
                removedElement = true
            }
        }
        return removedElement
    }
}

extension WeakSet : Sequence {

    public typealias Iterator = WeakSetIterator<T>

     func makeIterator() -> Iterator {
        //Should be synchronized because of the copy
        return synchronized(_mutex) {
            let copy = _contents.copy() as! NSSet
            return WeakSetIterator(copy.makeIterator())
        }
    }
    
    var allObject : [T] {
        return self.map {
            return $0
        }
    }
}

final class WeakSetIterator<T> : IteratorProtocol {
    
    private var iterator : NSFastEnumerationIterator
    
    fileprivate init(_ iterator : NSFastEnumerationIterator) {
        self.iterator = iterator
    }
    
    func next() -> T? {
        while let obj = iterator.next() {
            if let ref  = obj as? WeakReference<T> , let target = ref.target {
                return target
            }
        }
        return nil
    }
    
}

