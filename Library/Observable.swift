//
//  Observable.swift
//  Library
//
//  Created by Tobias Brander on 2018-10-11.
//  Copyright © 2018 Tobias Brander. All rights reserved.
//

import Foundation

public struct Unobserver {
    let unobserve:()->()
}

public class Observable<Type> {
    public typealias Observer = (Type) -> ()
    public typealias ErrorObserver = (Error) -> ()
    
    public init(callbackQueue:DispatchQueue = DispatchQueue.main, value:Type? = nil) {
        self.callbackQueue = callbackQueue
        self.value = value
    }
    
    private let syncQueue = DispatchQueue.init(label: "Observer\(Type.self)\(Date().timeIntervalSince1970)")
    private let callbackQueue:DispatchQueue
    private var observers:[String:Observer] = [:]
    private var errorObservers:[String:ErrorObserver] = [:]
    
    public var error:Error? = nil {
        didSet {
            guard let error = self.error else {
                return
            }
            
            let errorObservers = self.syncQueue.sync(execute: {return self.errorObservers })
            callbackQueue.async {
                for observer in errorObservers.values {
                    observer(error)
                }
            }
        }
    }
    
    public var value:Type? = nil {
        didSet {
            guard let value = self.value else {
                return
            }
            
            let observers = self.syncQueue.sync(execute: { return self.observers })
            callbackQueue.async {
                for observer in observers.values {
                    observer(value)
                }
            }
        }
    }
    
    @discardableResult
    public func observe(_ observer:@escaping Observer, errorObserver: ErrorObserver? = nil) -> Unobserver {
        let id = UUID.init().uuidString
        if let value = self.value {
            callbackQueue.async {
                observer(value)
            }
        }
        if let error = self.error, let errorObserver = errorObserver {
            callbackQueue.async {
                errorObserver(error)
            }
        }
        self.syncQueue.sync {
            observers[id] = observer
            errorObservers[id] = errorObserver
        }
        return Unobserver(unobserve:{ self.unobserve(id: id) })
    }
    
    private func unobserve(id:String) {
        syncQueue.sync {
            observers.removeValue(forKey: id)
            errorObservers.removeValue(forKey: id)
        }
    }
}
