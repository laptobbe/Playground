//
//  ViewModel.swift
//  Library
//
//  Created by Tobias Brander on 2018-10-11.
//  Copyright © 2018 Tobias Brander. All rights reserved.
//

import Foundation

open class ViewModel : Injectable {
    required public init() {
        
    }
    public private(set) var observations = [Unobserver]()
    public private(set) var kvoObservers = [NSObject]()

    public func remember(_ unobserver: Unobserver) {
        observations.append(unobserver)
    }
    
    func remember<Value>(_ kvoObserver:KVO<Value>) {
        kvoObservers.append(kvoObserver)
    }
    
    deinit {
        for unobserver in observations {
            unobserver.unobserve()
        }
    }
}

extension ViewModel {
    @discardableResult
    public func mapObservable<Type, NewType>(observable:Observable<Type>, mapper:@escaping (Type)->(NewType)) -> Observable<NewType> {
        let (new, unobserver) = observable.map(mapper: mapper)
        remember(unobserver)
        return new
    }
    
    @discardableResult
    public func mapFilterObservable<Type, NewType>(observable:Observable<Type>, mapper:@escaping (Type)->(NewType?)) -> Observable<NewType> {
        let (new, unobserver) = observable.mapFilter(mapper: mapper)
        remember(unobserver)
        return new
    }
    
    @discardableResult
    public func wrapObservable<Type>(observable:Observable<Type>) -> Observable<Type> {
        let new = Observable<Type>()
        remember(observable.observe({ (value) in
            new.value = value
        }, errorObserver: { error in
            new.error = error
        }))
        return new
    }
    
    @discardableResult
    public func mergeObservables<A, B>(a:Observable<A>, b:Observable<B>) -> Observable<(A,B)> {
        let new = Observable<(A,B)>()
        func check() {
            if let a = a.value, let b = b.value {
                new.value = (a, b)
            }
            if let aError = a.error {
                new.error = aError
            }
            if let bError = b.error {
                new.error = bError
            }
        }
        remember(a.observe({ _ in
            if(new.value == nil) {
                check()
            }
        }, errorObserver: { error in
            check()
        }))
        remember(b.observe({ _ in
            if(new.value == nil) {
                check()
            }
        }, errorObserver: { error in
            check()
        }))
        return new
    }
}

extension ViewModel {
    func syncTo<Value:Equatable>(object:NSObject, keyPath:String, observable:Observable<Value>) {
        remember(observable.observe ({ (value: Value) in
            if let current = object.value(forKeyPath: keyPath) as? Value, current != value {
                object.setValue(value, forKeyPath: keyPath)
            }
        }))
    }
    
    func syncFrom<Value:Equatable>(object:NSObject, keyPath:String, observable:Observable<Value>) {
        remember(KVO(object:object, observable: observable, keyPath: keyPath))
    }
    
    func syncTwoWay<Value:Equatable>(object:NSObject, keyPath:String, observable:Observable<Value>) {
        syncTo(object: object, keyPath: keyPath, observable: observable)
        syncFrom(object: object, keyPath: keyPath, observable: observable)
    }
    
    func syncTo<Value:Equatable, Object:NSObject>(object:Object, keyPath:KeyPath<Object, Value>, observable:Observable<Value>) {
        syncTo(object: object, keyPath: NSExpression(forKeyPath: keyPath).keyPath, observable: observable)
    }
    
    func syncFrom<Value:Equatable, Object:NSObject>(object:Object, keyPath:KeyPath<Object, Value>, observable:Observable<Value>) {
        syncFrom(object: object, keyPath: NSExpression(forKeyPath: keyPath).keyPath, observable: observable)
    }
    
    func syncTwoWay<Value:Equatable, Object:NSObject>(object:Object, keyPath:KeyPath<Object, Value>, observable:Observable<Value>) {
        syncTwoWay(object: object, keyPath: NSExpression(forKeyPath: keyPath).keyPath, observable: observable)
    }
}

class KVO<Value> : NSObject {
    
    let object:NSObject
    let observable:Observable<Value>
    let keyPath: String
    
    init(object:NSObject, observable: Observable<Value>, keyPath: String) {
        self.observable = observable
        self.keyPath = keyPath
        self.object = object
        super.init()
        object.addObserver(self, forKeyPath: keyPath, context:nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let keyPath = keyPath, let newObject = object as? NSObject, let newValue = newObject.value(forKeyPath: keyPath) as? Value {
            observable.value = newValue
        }
    }
    
    deinit {
        object.removeObserver(self, forKeyPath: self.keyPath)
    }
}
