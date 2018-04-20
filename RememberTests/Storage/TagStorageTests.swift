//
//  TagStorageTests.swift
//  RememberTests
//
//  Created by Songbai Yan on 2018/4/20.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import XCTest

class TagStorageTests: XCTestCase {
    
    private var tagStorage = TagStorage(context: StorageTestUtil.setUpInMemoryManagedObjectContext())
    
    func testShouldSaveNewTagSuccessfully() {
        let tag = TagModel(name: "test")
        tagStorage.save(for: tag)
        
        let result = tagStorage.find(by: "test")
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.name, "test")
    }
    
    func testShouldDeleteTagSuccessfully() {
        let tag = TagModel(name: "test")
        tagStorage.save(for: tag)
        tagStorage.delete(tag)
        
        let result = tagStorage.find(by: "test")
        XCTAssertNil(result)
    }
    
    func testShouldFindAllSortedTagsSuccessfully() {
        var tag1 = TagModel(name: "test1")
        tag1.index = 1
        var tag2 = TagModel(name: "test2")
        tag2.index = 2
        tagStorage.save(for: tag1)
        tagStorage.save(for: tag2)
        
        let tags = tagStorage.findAll()
        
        XCTAssertEqual(tags.count, 2)
        XCTAssertEqual(tags[0].index, 2)
        XCTAssertEqual(tags[0].name, "test2")
        XCTAssertEqual(tags[1].index, 1)
        XCTAssertEqual(tags[1].name, "test1")
    }
    
    func testShouldGetTagGivenName() {
        let tag = TagModel(name: "test")
        tagStorage.save(for: tag)
        
        let tagModel = tagStorage.find(by: "test")
        
        XCTAssertNotNil(tagModel)
        XCTAssertEqual(tagModel?.name, "test")
    }
    
    func testShouldGetTagsGivenIds() {
        let tag = TagModel(name: "test")
        let id = tag.id
        tagStorage.save(for: tag)
        
        let tags = tagStorage.getTags(by: [id!])
        
        XCTAssertEqual(tags.count, 1)
        XCTAssertEqual(tags[0].name, "test")
    }
    
    func testShouldUpdateIndexWhenIndexChanged() {
        var tag = TagModel(name: "test")
        tagStorage.save(for: tag)
        
        tag.index = 5
        tagStorage.updateIndex(for: tag)
        let tagModel = tagStorage.find(by: "test")
        
        XCTAssertEqual(tagModel?.index, 5)
    }
}
