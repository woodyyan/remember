//
//  ThingStorageTests.swift
//  RememberTests
//
//  Created by Songbai Yan on 2018/4/19.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import XCTest
import CoreData

class ThingStorageTests: XCTestCase {
    
    private var storage:ThingStorage = ThingStorage(context: StorageTestUtil.setUpInMemoryManagedObjectContext())
    
    func testShouldGetOneThingAfterCreateOne() {
        let thing = ThingModel(content: "test")
        storage.create(thing)
        
        let things = storage.findAll()
        XCTAssertEqual(things.count, 1)
        XCTAssertEqual(things[0].content, "test")
    }
    
    func testShouldGetSortedTwoThingsAfterCreateTwo() {
        var thing1 = ThingModel(content: "test")
        thing1.index = 2
        var thing2 = ThingModel(content: "test")
        thing2.index = 1
        storage.create(thing1)
        storage.create(thing2)
        
        let things = storage.findAll()
        XCTAssertEqual(things.count, 2)
        XCTAssertEqual(things[0].index, 1)
        XCTAssertEqual(things[1].index, 2)
    }
    
    func testShouldFindZeroAfterDeleteOneThingGivenOneThingInDB() {
        let thing = ThingModel(content: "test")
        storage.create(thing)
        
        var things = storage.findAll()
        XCTAssertEqual(things.count, 1)
        
        storage.delete(thing)
        
        things = storage.findAll()
        XCTAssertEqual(things.count, 0)
    }
    
    func testShouldEditContentToTest1GivenPreviousContentIsTest() {
        var thing = ThingModel(content: "test")
        storage.create(thing)
        
        thing.content = "test1"
        storage.edit(thing)
        
        var things = storage.findAll()
        XCTAssertEqual(things.count, 1)
        XCTAssertEqual(things[0].content, "test1")
    }
    
    func testShouldSortAndSaveThings() {
        var thing1 = ThingModel(content: "test")
        thing1.index = 4
        var thing2 = ThingModel(content: "test")
        thing2.index = 3
        storage.create(thing1)
        storage.create(thing2)
        
        var things = storage.findAll()
        XCTAssertEqual(things[0].index, 3)
        XCTAssertEqual(things[1].index, 4)
        
        thing1.index = 0
        thing2.index = 1
        storage.save(sorted: [thing1, thing2])
        things = storage.findAll()
        XCTAssertEqual(things[0].index, 0)
        XCTAssertEqual(things[1].index, 1)
    }
}
