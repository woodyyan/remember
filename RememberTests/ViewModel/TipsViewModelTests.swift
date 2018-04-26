//
//  TipsViewModelTests.swift
//  RememberTests
//
//  Created by Songbai Yan on 10/03/2018.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import XCTest

class TipsViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let viewMdoel = TipsViewModel()
        for i in 0...13 {
            let text = viewMdoel.getTipText(i)
            XCTAssert(!text.string.isEmpty)
            XCTAssert((text.attributes(at: 0, effectiveRange: nil)[NSAttributedStringKey.font]! as! UIFont).pointSize == 12)
            XCTAssert(text.attributes(at: 0, effectiveRange: nil)[NSAttributedStringKey.foregroundColor] != nil)
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
