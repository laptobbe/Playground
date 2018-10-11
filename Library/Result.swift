//
//  Result.swift
//  Library
//
//  Created by Tobias Brander on 2018-10-11.
//  Copyright © 2018 Tobias Brander. All rights reserved.
//

import Foundation

public enum Result<Type> {
    case success(Type)
    case error(Error)
}
