//
//  PasteboardUtilTests.swift
//  RememberTests
//
//  Created by Songbai Yan on 2018/4/26.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import XCTest

class PasteboardUtilTests: XCTestCase {
    
    func testShouldGetContentWhenPasteboardHasStringFirstTime() {
        UserDefaults.standard.set("", forKey: "pasteboardContent")
        UserDefaults.standard.synchronize()
        UIPasteboard.general.string = "test"
        
        let content = PasteboardUtils.getPasteboardContent()
        XCTAssertEqual(content, "test")
    }
    
    func testShouldGetNilWhenPasteboardHasStringSecondTime() {
        UserDefaults.standard.set("test", forKey: "pasteboardContent")
        UserDefaults.standard.synchronize()
        UIPasteboard.general.string = "test"
        
        let content = PasteboardUtils.getPasteboardContent()
        XCTAssertNil(content)
    }
    
    func testShouldGetNilWhenPasteboardHasNothing() {
        UIPasteboard.general.string = ""
        
        let content = PasteboardUtils.getPasteboardContent()
        XCTAssertNil(content)
    }
}
