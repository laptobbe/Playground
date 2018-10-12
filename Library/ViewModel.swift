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
    public private(set) var observations = [Unobserver]()

    public func remember(_ unobserver: Unobserver) {
        observations.append(unobserver)
    }

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
    
    deinit {
        for unobserver in observations {
            unobserver.unobserve()
        }
    }
}
