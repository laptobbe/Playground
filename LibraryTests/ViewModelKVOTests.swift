//
// Created by Tobias Brander on 2018-10-11.
// Copyright (c) 2018 Tobias Brander. All rights reserved.
//

import XCTest
@testable import Library

class ViewModelKVOTests : XCTestCase {

    func testUILabelMapping() {
        let label = UILabel()
        let expectation = XCTKVOExpectation(keyPath: "text", object: label, expectedValue:"Test")
        let o1 = Observable<String?>()
        let viewModel = ViewModel()

        viewModel.syncTo(object: label, keyPath:\UILabel.text, observable: o1)

        o1.value = "Test"
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testUILabelBackgroundColorMapping() {
        let label = UILabel()
        let color = UIColor.red
        let expectation = XCTKVOExpectation(keyPath: "backgroundColor", object: label, expectedValue:color)
        let o1 = Observable<UIColor?>()
        let viewModel = ViewModel()
        
        viewModel.syncTo(object: label, keyPath:\UILabel.backgroundColor, observable: o1)
        
        o1.value = color
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testUILabelReverseMapping() {
        let label = UILabel()
        let expectation = XCTestExpectation()
        let o1 = Observable<String?>()
        let viewModel = ViewModel()
        
        o1.observe({ (value: String?) in
            if value == "Test" {
                expectation.fulfill()
            }
        })
        
        viewModel.syncFrom(object: label, keyPath:\UILabel.text, observable: o1)
        label.text = "Test"
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testUILabelTwoWayMapping() {
        let label = UILabel()
        let expectation = XCTestExpectation()
        let expectation2 = XCTKVOExpectation(keyPath: "text", object: label, expectedValue:"Test2")
        let o1 = Observable<String?>()
        let viewModel = ViewModel()
        
        o1.observe({ (value: String?) in
            if value == "Test" {
                expectation.fulfill()
            }
        })
        
        viewModel.syncTwoWay(object: label, keyPath:\UILabel.text, observable: o1)
        label.text = "Test"
        o1.value = "Test2"
        
        wait(for: [expectation, expectation2], timeout: 0.1)
    }

    func testUITextViewMapping() {
        let textView = UITextView()
        let expectation = XCTKVOExpectation(keyPath: "text", object: textView, expectedValue:"Test")
        let o1 = Observable<String?>()
        let viewModel = ViewModel()

        viewModel.syncTo(object: textView, keyPath:\UITextView.text, observable: o1)

        o1.value = "Test"
        wait(for: [expectation], timeout: 0.1)
    }

    func testUITextViewReverseMapping() {
        let textView = UITextView()
        let expectation = XCTestExpectation()
        let o1 = Observable<String?>()
        let viewModel = ViewModel()

        o1.observe({ (value: String?) in
            if value == "Test" {
                expectation.fulfill()
            }
        })

        viewModel.syncFrom(object: textView, keyPath:\UITextView.text, observable: o1)
        textView.text = "Test"

        wait(for: [expectation], timeout: 0.1)
    }

    func testUITextFieldMapping() {
        let textField = UITextField()
        let expectation = XCTKVOExpectation(keyPath: "text", object: textField, expectedValue:"Test")
        let o1 = Observable<String?>()
        let viewModel = ViewModel()
        
        viewModel.syncTo(object: textField, keyPath:\UITextField.text, observable: o1)
        
        o1.value = "Test"
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testUITextFieldReverseMapping() {
        let textField = UITextField()
        let expectation = XCTestExpectation()
        let o1 = Observable<String?>()
        let viewModel = ViewModel()
        
        o1.observe({ (value: String?) in
            if value == "Test" {
                expectation.fulfill()
            }
        })
        
        viewModel.syncFrom(object: textField, keyPath:\UITextField.text, observable: o1)
        textField.text = "Test"
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    

}
