//
//  ThingStorageTests.swift
//  RememberTests
//
//  Created by Songbai Yan on 2018/4/19.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import XCTest

class ThingStorageTests: XCTestCase {
    
    private let storage = ThingStorage()
    
    override func setUp() {
        super.setUp()
        let thing = ThingModel(content: "test")
        storage.create(thing)
    }
    
    func testExample() {
        let thing = ThingModel(content: "test")
        storage.create(thing)
        
        let things = storage.findAll()
        print(things.count)
        XCTAssertEqual(things.count, 1)
    }
}
