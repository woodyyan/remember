//
//  EditThingViewModelTests.swift
//  RememberTests
//
//  Created by Songbai Yan on 2018/4/26.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import XCTest

class EditThingViewModelTests: XCTestCase {
    
    private let thingStorage = StubThingStorage()
    private var viewModel: EditThingViewModel!
    
    override func setUp() {
        viewModel = EditThingViewModel(thingStorage: thingStorage)
        thingStorage.things.removeAll()
    }
    
    func testShouldEditThing() {
        var thing = ThingModel(content: "test")
        thingStorage.things.append(thing)
        
        thing.content = "123"
        viewModel.edit(thing)
        
        XCTAssertEqual(thingStorage.things[0].content, "123")
    }
    
    func testShouldDeleteThing() {
        let thing = ThingModel(content: "test")
        thingStorage.things.append(thing)
        
        viewModel.delete(thing)
        
        XCTAssertEqual(thingStorage.things.count, 0)
    }
}
