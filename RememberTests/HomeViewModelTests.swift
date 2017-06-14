//
//  HomeViewModelTest.swift
//  Remember
//
//  Created by Songbai Yan on 14/06/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import XCTest

class HomeViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testShoulddGetPasteboardContentWhenCopyAString() {
        let content = "content"
        UIPasteboard.general.string = content;
        
        let result = HomeViewModel.getPasteboardContent()
        
        XCTAssert(result == content)
    }
    
    func testShoulddGetPasteboardContentWhenCopyAnUrl() {
        let url = "http://google.com"
        UIPasteboard.general.url = URL.init(string: url);
        
        let result = HomeViewModel.getPasteboardContent()
        
        XCTAssert(result == url)
    }
    
    func testShoulddGetNilPasteboardContentWhenNothingCopied() {
        let result = HomeViewModel.getPasteboardContent()
        
        XCTAssert(result == nil)
    }
}
