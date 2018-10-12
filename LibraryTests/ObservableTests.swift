//
// Created by Tobias Brander on 2018-10-11.
// Copyright (c) 2018 Tobias Brander. All rights reserved.
//

import XCTest
@testable import Library

class ObservableTests : XCTestCase {
    private enum TestError : Error {
        case AnError
    }

    func testError() {
        let expectation = XCTestExpectation()
        let observable = Observable<Bool>()

        observable.observe({ (type: Bool) in

        }, errorObserver: { error in
            expectation.fulfill()
        })
        observable.error = TestError.AnError

        wait(for: [expectation], timeout: 10.0)
    }

    func testValue() {
        let expectation = XCTestExpectation()
        let observable = Observable<Bool>()

        observable.observe({ (type: Bool) in
            expectation.fulfill()
        }, errorObserver: { error in

        })
        observable.value = true

        wait(for: [expectation], timeout: 10.0)
    }

    func testMultipleValue() {
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 2
        let observable = Observable<Bool>()

        observable.observe({ (type: Bool) in
            expectation.fulfill()
        }, errorObserver: { error in

        })
        observable.value = true
        observable.value = false

        wait(for: [expectation], timeout: 10.0)
    }

    func testMultipleValueSameValue() {
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 2
        let observable = Observable<Bool>()

        observable.observe({ (type: Bool) in
            expectation.fulfill()
        }, errorObserver: { error in

        })
        observable.value = true
        observable.value = true

        wait(for: [expectation], timeout: 10.0)
    }

    func testMultipleError() {
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 2
        let observable = Observable<Bool>()

        observable.observe({ (type: Bool) in

        }, errorObserver: { error in
            expectation.fulfill()
        })
        observable.error = TestError.AnError
        observable.error = TestError.AnError

        wait(for: [expectation], timeout: 10.0)
    }

    func testValueAndError() {
        let valueExpectation = XCTestExpectation()
        let errorExpectation = XCTestExpectation()

        let observable = Observable<Bool>()

        observable.observe({ (type: Bool) in
            valueExpectation.fulfill()
        }, errorObserver: { error in
            errorExpectation.fulfill()
        })
        observable.value = true
        observable.error = TestError.AnError

        wait(for: [valueExpectation, errorExpectation], timeout: 10.0)
    }

    func testInitialValue() {
        let valueExpectation = XCTestExpectation()

        let observable = Observable<Bool>(value: true)

        observable.observe({ (type: Bool) in
            valueExpectation.fulfill()
        }, errorObserver: { error in

        })

        wait(for: [valueExpectation], timeout: 10.0)
    }

    func testGetLatestValue() {
        let valueExpectation = XCTestExpectation()

        let observable = Observable<Bool>(value: true)
        observable.value = false
        observable.observe({ (type: Bool) in
            if(type == false) {
                valueExpectation.fulfill()
            }
        }, errorObserver: { error in

        })

        wait(for: [valueExpectation], timeout: 10.0)
    }
}
