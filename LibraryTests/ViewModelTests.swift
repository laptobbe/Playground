//
// Created by Tobias Brander on 2018-10-11.
// Copyright (c) 2018 Tobias Brander. All rights reserved.
//

import XCTest
@testable import Library

class ViewModelTests : XCTestCase {
    private enum TestError : Error {
        case AnError
    }
    func testMapObservableObservations() {
        let observable = Observable<Bool>(value: true)
        let viewModel = ViewModel()
        viewModel.mapObservable(observable: observable) { (type: Bool) -> (String) in
            return "\(type)"
        }
        XCTAssertEqual(viewModel.observations.count, 1)
    }

    func testMapTwoObservableObservations() {
        let observable = Observable<Bool>(value: true)
        let viewModel = ViewModel()
        viewModel.mapObservable(observable: observable) { (type: Bool) -> (String) in
            return "\(type)"
        }
        viewModel.mapObservable(observable: observable) { (type: Bool) -> (String) in
            return "\(type)"
        }
        XCTAssertEqual(viewModel.observations.count, 2)
    }

    func testWrapObservableObservations() {
        let observable = Observable<Bool>(value: true)
        let viewModel = ViewModel()
        viewModel.wrapObservable(observable: observable)
        XCTAssertEqual(viewModel.observations.count, 1)
    }

    func testMergeObservablesObservations() {
        let o1 = Observable<Bool>(value: true)
        let o2 = Observable<Bool>(value: false)
        let viewModel = ViewModel()
        viewModel.mergeObservables(a: o1, b: o2)
        XCTAssertEqual(viewModel.observations.count, 2)
    }

    func testMapObservableValue() {
        let expectation = XCTestExpectation()
        let observable = Observable<Bool>(value: true)
        let viewModel = ViewModel()

        viewModel.mapObservable(observable: observable) { (type: Bool) -> (String) in
            return "\(type)"
        }.observe({ (value: String) in
            if(value == "true") {
                expectation.fulfill()
            }
        })

        wait(for: [expectation], timeout: 10.0)
    }

    func testMapObservableErrorPassThough() {
        let expectation = XCTestExpectation()
        let observable = Observable<Bool>()
        let viewModel = ViewModel()

        let mapped = viewModel.mapObservable(observable: observable) { (type: Bool) -> (String) in
            return "\(type)"
        }
        mapped.observe({ (type: String) in
            XCTFail()
        }, errorObserver: { error in
            if case TestError.AnError = error {
                expectation.fulfill()
            }
        })
        observable.error = TestError.AnError

        wait(for: [expectation], timeout: 0.1)
    }

    func testWrapObservableErrorPassThough() {
        let expectation = XCTestExpectation()
        let observable = Observable<Bool>()
        let viewModel = ViewModel()

        let wrapped = viewModel.wrapObservable(observable: observable)

        wrapped.observe({ (type: Bool) in
            XCTFail()
        }, errorObserver: { error in
            if case TestError.AnError = error {
                expectation.fulfill()
            }
        })
        observable.error = TestError.AnError

        wait(for: [expectation], timeout: 0.1)
    }

    func testMergeObservablesErrorPassThrough() {
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 2
        let o1 = Observable<Bool>()
        let o2 = Observable<Bool>()
        let viewModel = ViewModel()
        let merged = viewModel.mergeObservables(a: o1, b: o2)
        merged.observe({ type in
            XCTFail()
         }, errorObserver: { error in
            expectation.fulfill()
        })

        o1.error = TestError.AnError
        o2.error = TestError.AnError

        wait(for: [expectation], timeout: 0.1)
    }

    func testMergeObservablesCalledOnce() {
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        let o1 = Observable<Bool>()
        let o2 = Observable<Bool>()
        let viewModel = ViewModel()
        let merged = viewModel.mergeObservables(a: o1, b: o2)
        merged.observe({ (v1, v2) in
            if v1 && v2 {
                expectation.fulfill()
            }
        })

        o1.value = true
        o2.value = true

        wait(for: [expectation], timeout: 0.1)
    }

    func testMapFilterObservableValue() {
        let expectation = XCTestExpectation()
        let observable = Observable<Bool>(value: false)
        let viewModel = ViewModel()

        viewModel.mapFilterObservable(observable: observable) { (type: Bool) -> (String?) in
            return type == true ? "true" : nil
        }.observe({ (value: String) in
            if(value == "true") {
                expectation.fulfill()
            } else if(value == "false") {
                XCTFail()
            }
        })

        observable.value = true

        wait(for: [expectation], timeout: 10.0)
    }
}
