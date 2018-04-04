//
//  PasteboardUtilsTests.swift
//  RememberTests
//
//  Created by Songbai Yan on 04/04/2018.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import XCTest

class PasteboardUtilsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testShoulddGetPasteboardContentWhenCopyAString() {
        UserDefaults.standard.set("", forKey: "pasteboardContent")
        UserDefaults.standard.synchronize()
        
        let content = "content"
        UIPasteboard.general.string = content;
        
        let result = PasteboardUtils.getPasteboardContent()
        
        XCTAssert(result == content)
    }
    
    func testShoulddGetPasteboardContentWhenCopyAnUrl() {
        let url = "http://google.com"
        UIPasteboard.general.url = URL.init(string: url);
        
        let result = PasteboardUtils.getPasteboardContent()
        
        XCTAssert(result == url)
    }
    
    func testShoulddGetNilPasteboardContentWhenNothingCopied() {
        let result = PasteboardUtils.getPasteboardContent()
        
        XCTAssert(result == nil)
    }
}
