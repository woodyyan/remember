//
//  SearchViewModel.swift
//  Remember
//
//  Created by Songbai Yan on 2018/4/21.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation

class SearchViewModel: BaseViewModel {
    private var tagStorage: TagStorage!
    private let thingStorage: ThingStorage!
    private let thingTagStorage: ThingTagStorage!
    
    private(set) var things = [ThingModel]()
    
    init(tagStorage: TagStorage, thingStorage: ThingStorage, thingTagStorage: ThingTagStorage) {
        self.tagStorage = tagStorage
        self.thingStorage = thingStorage
        self.thingTagStorage = thingTagStorage
        things = thingStorage.findAll()
    }
    
    func getAllTags() -> [TagModel] {
        return tagStorage.findAll()
    }
    
    func getThings(byText searchText: String) -> [ThingModel] {
        things = thingStorage.findAll()
        let filteredThings = self.things.filter({ (thing) -> Bool in
            return thing.content.contains(searchText)
        })
        return filteredThings
    }
    
    func getThings(byTag tag: String) -> [ThingModel] {
        things = thingStorage.findAll()
        var filteredThings = [ThingModel]()
        if let tagModel = tagStorage.find(by: tag) {
            let thingTags = thingTagStorage.findThingTagsBy(tagId: tagModel.id)
            let thingTagIds = thingTags.map({$0.thingId!})
            filteredThings = things.filter { (thing) -> Bool in
                return thingTagIds.contains(thing.id)
            }
        }
        return filteredThings
    }
}
