//
//  Injectable.swift
//  Library
//
//  Created by Tobias Brander on 2018-10-11.
//  Copyright © 2018 Tobias Brander. All rights reserved.
//

import Foundation

public protocol Injectable {
    init()
}

public enum Injection {
    private static var singletons:[String:Injectable] = [:]
    private static var ids:[String:Injectable] = [:]
    public static func new<Type:Injectable>() -> Type {
        return Type()
    }
    public static func singleton<Type:Injectable>() -> Type {
        let key = String(describing: Type.self)
        let singleton:Type = singletons[key] as? Type ?? Type()
        singletons[key] = singleton
        return singleton
    }
    public static func withId<Type:Injectable>(id:String) -> Type {
        let key = String(describing: Type.self)
        let finalId = key + id
        let ided = ids[finalId] as? Type ?? Type()
        ids[finalId] = ided
        return ided
    }
}
