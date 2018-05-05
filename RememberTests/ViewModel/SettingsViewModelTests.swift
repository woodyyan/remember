//
//  SettingsViewModelTests.swift
//  RememberTests
//
//  Created by Songbai Yan on 2018/4/26.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import XCTest

class SettingsViewModelTests: XCTestCase {
    private var viewModel: SettingsViewModel!
    
    override func setUp() {
        let thingStorage = StubThingStorage()
        thingStorage.things.append(ThingModel(content: "test1"))
        thingStorage.things.append(ThingModel(content: "test2"))
        viewModel = SettingsViewModel(thingStorage: thingStorage)
    }
   
    func testShouldGetAllThingCount() {
        let count = viewModel.getAllThingCount()
        
        XCTAssertEqual(count, 2)
    }
}
