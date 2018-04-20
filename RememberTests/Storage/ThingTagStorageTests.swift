//
//  ThingTagStorageTests.swift
//  RememberTests
//
//  Created by Songbai Yan on 2018/4/20.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import XCTest

class ThingTagStorageTests: XCTestCase {
    
    private let storage = ThingTagStorage(context: StorageTestUtil.setUpInMemoryManagedObjectContext())
    
    func testShouldSaveThingTagSuccessfully() {
        let model = ThingTagModel(thingId: "1", tagId: "2")
        storage.save(for: model)
        
        let thingTags = storage.findThingTagsBy(tagId: "2")
        
        XCTAssertEqual(thingTags.count, 1)
    }
    
    func testShouldFindThingTagsGivenThingId() {
        let model = ThingTagModel(thingId: "1", tagId: "2")
        storage.save(for: model)
        
        let thingTags = storage.findThingTagsBy(thingId: "1")
        
        XCTAssertEqual(thingTags.count, 1)
    }
}
