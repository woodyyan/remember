//
//  VoiceInputViewModelTests.swift
//  RememberTests
//
//  Created by Songbai Yan on 2018/4/26.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import XCTest

class VoiceInputViewModelTests: XCTestCase {
    
    let viewModel = VoiceInputViewModel(thingStorage: StubThingStorage())
    
    func testExample() {
        let thing = viewModel.saveThing("content")
        
        XCTAssertEqual(thing.content, "content")
        XCTAssertFalse(thing.id.isEmpty)
        XCTAssert(thing.index == 0)
        XCTAssertFalse(thing.isNew)
    }
}
