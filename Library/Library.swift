//: A UIKit based Playground for presenting user interface

import Foundation
import UIKit

public protocol Injectable {
    init()
    static var id:String { get }
}

public enum Injection {
    private static var singletons:[String:Injectable] = [:]
    private static var ids:[String:Injectable] = [:]
    public static func new<Type:Injectable>() -> Type {
        return Type()
    }
    public static func singleton<Type:Injectable>() -> Type {
        let singleton:Type = singletons[Type.id] as? Type ?? Type()
        singletons[Type.id] = singleton
        return singleton
    }
    public static func withId<Type:Injectable>(id:String) -> Type {
        let finalId = Type.id + id
        let ided = ids[finalId] as? Type ?? Type()
        ids[finalId] = ided
        return ided
    }
}

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
    public func observe(observer:@escaping Observer, errorObserver: ErrorObserver? = nil) -> Unobserver {
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

public enum Result<Type> {
    case success(Type)
    case error(Error)
}

open class ViewModel {
    public init() {

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


open class ArrayTableViewDataSource<Element>: NSObject, UITableViewDataSource {
    public init(data:[Element] = []) {
        self.data = data
        super.init()
    }

    public var data:[Element]

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.tableView(tableView, cellForElement: data[indexPath.row], atIndexPath: indexPath)
    }

    open func tableView(_ tableView:UITableView, cellForElement element:Element, atIndexPath indexPath:IndexPath) -> UITableViewCell {
        fatalError("Needs to be overwritten")
    }
}

