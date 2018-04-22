//
//  AboutViewModelTests.swift
//  Remember
//
//  Created by Songbai Yan on 14/06/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import XCTest

class AboutViewModelTests: XCTestCase {
    var viewModel = AboutViewModel()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testShouldGetSloganCorrectly() {
        let slogan = viewModel.getSlogan()
        
        XCTAssert(slogan == "Remember the things you often forget")
    }
    
    func testShouldGetAppNameCorrectly(){
        let appName = viewModel.getAppName()
        
        XCTAssert(appName == "Remember")
    }
    
    func testShouldGetVersionInfoCorrectly() {
        let versionInfo = viewModel.getVersionInfo()
        
        XCTAssert(versionInfo.hasPrefix("Version: V"))
        XCTAssert(versionInfo.contains("."))
        XCTAssert(versionInfo.components(separatedBy: ".").count >= 2)
    }
    
    func testShouldGetCurrentVersionCorrectly() {
        let version = VersionUtils.getCurrentVersion()
        
        XCTAssert(version.contains("."))
        XCTAssert(version.components(separatedBy: ".").count >= 2)
    }
}
