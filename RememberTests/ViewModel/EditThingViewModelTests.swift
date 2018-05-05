//
//  EditThingViewModelTests.swift
//  RememberTests
//
//  Created by Songbai Yan on 2018/4/26.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import XCTest

class EditThingViewModelTests: XCTestCase {
    
    private let viewModel = EditThingViewModel(thingStorage: StubThingStorage())
    
    func testShouldEditThing() {
        let thing = ThingModel(content: "test")
        viewModel.edit(thing)
    }
}
