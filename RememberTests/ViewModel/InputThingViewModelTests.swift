//
//  InputThingViewModelTests.swift
//  RememberTests
//
//  Created by Songbai Yan on 2018/4/26.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import XCTest

class InputThingViewModelTests: XCTestCase {
    private let viewModel = InputThingViewModel(thingStorage: StubThingStorage())
    
    func testShouldCreateThingSuccessfully() {
        let thing = viewModel.createThing(with: "test")
        
        XCTAssertTrue(thing.isNew)
        XCTAssertEqual(thing.content, "test")
        XCTAssertFalse(thing.id.isEmpty)
        XCTAssertEqual(thing.index, 0)
    }
}
