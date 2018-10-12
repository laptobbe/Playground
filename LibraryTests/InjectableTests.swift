//
//  InjectableTests.swift
//  LibraryTests
//
//  Created by Tobias Brander on 2018-10-11.
//  Copyright © 2018 Tobias Brander. All rights reserved.
//

import XCTest
@testable import Library

class InjectableTests: XCTestCase {

    private final class TestInjectable: Injectable {

    }
    
    func testSingletonInjectable() {
        let i1:TestInjectable = Injection.singleton()
        let i2:TestInjectable = Injection.singleton()
        
        XCTAssert(i1 === i2)
    }
    
    func testNewInjectable() {
        let i1:TestInjectable = Injection.new()
        let i2:TestInjectable = Injection.new()

        XCTAssertFalse(i1 === i2)
    }

    func testNewVsSingleton() {
        let i1:TestInjectable = Injection.new()
        let i2:TestInjectable = Injection.singleton()

        XCTAssertFalse(i1 === i2)
    }

    func testByIdVsNew() {
        let i1:TestInjectable = Injection.withId(id: "bla")
        let i2:TestInjectable = Injection.singleton()

        XCTAssertFalse(i1 === i2)
    }

    func testById() {
        let i1:TestInjectable = Injection.withId(id: "bla")
        let i2:TestInjectable = Injection.withId(id: "bla")

        XCTAssert(i1 === i2)
    }
}
