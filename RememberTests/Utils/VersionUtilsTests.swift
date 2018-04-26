//
//  VersionUtilsTests.swift
//  RememberTests
//
//  Created by Songbai Yan on 2018/4/26.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import XCTest

class VersionUtilsTests: XCTestCase {
    
    func testShouldGetVersionSuccessfully() {
        let version = VersionUtils.getCurrentVersion()
        let items = version.split(separator: ".")
        XCTAssert(items.count == 3)
        let number1 = Int(items[0])
        let number2 = Int(items[1])
        let number3 = Int(items[2])
        XCTAssertNotNil(number1)
        XCTAssertNotNil(number2)
        XCTAssertNotNil(number3)
    }
}
