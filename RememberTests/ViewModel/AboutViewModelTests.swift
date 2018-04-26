//
//  AboutViewModelTests.swift
//  RememberTests
//
//  Created by Songbai Yan on 2018/4/26.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import XCTest

class AboutViewModelTests: XCTestCase {
    
    private let viewModel = AboutViewModel()
   
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
