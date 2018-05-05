//
//  TagManagementViewModelTests.swift
//  RememberTests
//
//  Created by Songbai Yan on 2018/4/26.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import XCTest

class TagManagementViewModelTests: XCTestCase {
    
    private let thingTagStorage = StubThingTagStorage()
    private let tagStorage = StubTagStorage()
    
    private var viewModel: TagManagementViewModel!
    
    override func setUp() {
        viewModel = TagManagementViewModel(tagStorage: tagStorage, thingTagStorage: thingTagStorage)
        thingTagStorage.thingTags.removeAll()
        tagStorage.tags.removeAll()
    }
    
    func testShouldReturnFalseGivenTagNotExist() {
        let exist = viewModel.exists("test")
        
        XCTAssertFalse(exist)
    }
    
    func testShouldReturnTrueGivenTagExists() {
        let exist = viewModel.exists("tag")
        
        XCTAssertFalse(exist)
    }

    func testShouldDeleteThingTagSuccessfully() {
        let thingTag = ThingTagModel(thingId: "1", tagId: "2")
        thingTagStorage.thingTags.append(thingTag)
        viewModel.deleteThingTag(thingTag)
        XCTAssertEqual(thingTagStorage.thingTags.count, 0)
    }
    
    func testShouldSaveThingTagSuccessfully() {
        viewModel.saveThingTag(ThingTagModel(thingId: "1", tagId: "2"))
        
        XCTAssertEqual(thingTagStorage.thingTags.count, 1)
        XCTAssertEqual(thingTagStorage.thingTags[0].tagId, "2")
        XCTAssertEqual(thingTagStorage.thingTags[0].thingId, "1")
    }
    
    func testShouldUpdateIndexSuccessfully() {
        var tag = TagModel(name: "tag")
        tagStorage.tags.append(tag)
        
        XCTAssertEqual(tag.index, 0)
        tag.index = 1
        viewModel.updateIndex(for: tag)
        
        XCTAssertEqual(tagStorage.tags[0].index, 1)
    }
    
    func testShouldSaveTagAndThingTagSuccessfully() {
        viewModel.saveTagAndThingTag("tag", thingId: "1")
        
        let tag = tagStorage.tags[0]
        let thingTag = thingTagStorage.thingTags[0]
        XCTAssertEqual(tag.name, "tag")
        XCTAssertEqual(thingTag.thingId, "1")
        XCTAssertEqual(thingTag.tagId, tag.id)
    }
    
    func testShouldGetSeletedTagsGivenThing() {
        var tag1 = TagModel(name: "tag1")
        tag1.id = "1"
        var tag2 = TagModel(name: "tag2")
        tag2.id = "2"
        tagStorage.tags.append(tag1)
        tagStorage.tags.append(tag2)
        
        let thingTag = ThingTagModel(thingId: "1", tagId: "1")
        thingTagStorage.thingTags.append(thingTag)
        
        var thing = ThingModel(content: "thing")
        thing.id = "1"
        let tags = viewModel.getSelectedTags(by: thing)
        
        XCTAssertEqual(tags.count, 1)
        XCTAssertEqual(tags[0].name, "tag1")
    }
    
    func testShouldGetEmptyArrayWhenNoSelectedTags() {
        var tag1 = TagModel(name: "tag1")
        tag1.id = "1"
        tagStorage.tags.append(tag1)
        
        var thing = ThingModel(content: "thing")
        thing.id = "1"
        let tags = viewModel.getSelectedTags(by: thing)
        
        XCTAssertEqual(tags.count, 0)
    }
    
    func testShouldGetUnselectedTagGivenThing() {
        var tag1 = TagModel(name: "tag1")
        tag1.id = "1"
        var tag2 = TagModel(name: "tag2")
        tag2.id = "2"
        tagStorage.tags.append(tag1)
        tagStorage.tags.append(tag2)
        
        let thingTag = ThingTagModel(thingId: "1", tagId: "1")
        thingTagStorage.thingTags.append(thingTag)
        
        var thing = ThingModel(content: "thing")
        thing.id = "1"
        let tags = viewModel.getUnselectedTags(by: thing)
        
        XCTAssertEqual(tags.count, 1)
        XCTAssertEqual(tags[0].name, "tag2")
    }
    
    func testShouldGetEmptyArrayWhenNoUnselectedTags() {
        var tag1 = TagModel(name: "tag1")
        tag1.id = "1"
        tagStorage.tags.append(tag1)
        
        let thingTag = ThingTagModel(thingId: "1", tagId: "1")
        thingTagStorage.thingTags.append(thingTag)
        
        var thing = ThingModel(content: "thing")
        thing.id = "1"
        let tags = viewModel.getUnselectedTags(by: thing)
        
        XCTAssertEqual(tags.count, 0)
    }
}
