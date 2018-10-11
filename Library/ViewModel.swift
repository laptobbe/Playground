//
//  ViewModel.swift
//  Library
//
//  Created by Tobias Brander on 2018-10-11.
//  Copyright © 2018 Tobias Brander. All rights reserved.
//

import Foundation

open class ViewModel : Injectable {
    public static var id: String = UUID().uuidString
    required public init() {
        
    }
    private var observations = [Unobserver]()
    public func remember(_ unobserver: Unobserver) {
        observations.append(unobserver)
    }
    public func mapObservable<Type, NewType>(observable:Observable<Type>, mapper:@escaping (Type)->(NewType)) -> Observable<NewType> {
        let new = Observable<NewType>()
        remember(observable.observe(observer: { (value) in
            new.value = mapper(value)
        }))
        return new
    }
    public func wrapObservable<Type>(observable:Observable<Type>) -> Observable<Type> {
        let new = Observable<Type>()
        remember(observable.observe(observer: { (value) in
            new.value = value
        }))
        return new
    }
    
    public func mergeObservables<A, B>(a:Observable<A>, b:Observable<B>) -> Observable<(A,B)> {
        let new = Observable<(A,B)>()
        func check() {
            if let a = a.value, let b = b.value {
                new.value = (a, b)
            }
        }
        remember(a.observe(observer: { _ in
            if(new.value == nil) {
                check()
            }
        }))
        remember(b.observe(observer: { _ in
            if(new.value == nil) {
                check()
            }
        }))
        return new
    }
    
    deinit {
        for unobserver in observations {
            unobserver.unobserve()
        }
    }
}
