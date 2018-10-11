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
