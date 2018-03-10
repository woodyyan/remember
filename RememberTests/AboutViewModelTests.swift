//
//  AboutViewModelTests.swift
//  Remember
//
//  Created by Songbai Yan on 14/06/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import XCTest

class AboutViewModelTests: XCTestCase {
    var viewModel:AboutViewModel!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        viewModel = AboutViewModel()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testShouldGetSloganCorrectly() {
        let slogan = viewModel.getSlogan()
        
        XCTAssert(slogan == "记住你容易忘记的小事")
    }
    
    func testShouldGetAppNameCorrectly(){
        let appName = viewModel.getAppName()
        
        XCTAssert(appName == "丁丁记事")
    }
    
    func testShouldGetDescriptionCorrectly() {
        let text = "丁丁记事是一个帮助你记住平时容易忘记的小事的轻量级备忘录，你可以非常快速而简单的记录一切的小事，当你忘记它们的时候，可以很方便的从这里找到它们。"
        
        let description = viewModel.getDescription()
        
        XCTAssert(description == text)
    }
    
    func testShouldGetGettingStarted(){
        let gettingStarted = viewModel.getGettingStarted()
        
        XCTAssert(!gettingStarted.isEmpty)
    }
    
    func testShouldGetCurrentVersionCorrectly() {
        let versionInfo = viewModel.getVersionInfo()
        
        XCTAssert(versionInfo.hasPrefix("版本号：V"))
        XCTAssert(versionInfo.contains("."))
        XCTAssert(versionInfo.components(separatedBy: ".").count >= 2)
    }
}
