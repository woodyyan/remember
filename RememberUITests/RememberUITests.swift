//
//  RememberUITests.swift
//  RememberUITests
//
//  Created by Songbai Yan on 14/11/2016.
//  Copyright © 2016 Songbai Yan. All rights reserved.
//

import XCTest

class RememberUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAllItemsExistInAboutPage() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
//        let app = XCUIApplication()
//        app.navigationBars["丁丁记事"].buttons["about"].tap()
//        
//        let tablesQuery = app.tables
//        var isExists = tablesQuery.staticTexts["记住你容易忘记的小事"].exists
//        XCTAssert(isExists)
//        
//        isExists = tablesQuery.staticTexts["版本号：V1.9"].exists
//        XCTAssert(isExists)
//        isExists = tablesQuery.staticTexts["丁丁记事是一个帮助你记住平时容易忘记的小事的轻量级备忘录，你可以非常快速而简单的记录一切容易忘记的小事，当你忘记它们的时候，可以很方便的从这里找到它们。"].exists
//        XCTAssert(isExists)
//        isExists = app.buttons["反馈"].exists
//        XCTAssert(isExists)
//        isExists = app.buttons["微博"].exists
//        XCTAssert(isExists)
    }
}
