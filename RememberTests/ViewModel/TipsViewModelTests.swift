//
//  TipsViewModelTests.swift
//  RememberTests
//
//  Created by Songbai Yan on 10/03/2018.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import XCTest

class TipsViewModelTests: XCTestCase {
    
    private let viewMdoel = TipsViewModel()
    
    func testShouldGetAllTipsSuccessfully() {
        
        for i in 0...13 {
            let text = viewMdoel.getTipText(i)
            XCTAssert(!text.string.isEmpty)
            XCTAssert((text.attributes(at: 0, effectiveRange: nil)[NSAttributedStringKey.font]! as! UIFont).pointSize == 12)
            XCTAssert(text.attributes(at: 0, effectiveRange: nil)[NSAttributedStringKey.foregroundColor] != nil)
        }
    }
    
    func testShouldGet14ForAllTips() {
        let count = viewMdoel.getTipCount()
        
        XCTAssertEqual(count, 14)
    }
}
