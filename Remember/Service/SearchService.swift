//
//  SearchService.swift
//  Remember
//
//  Created by Songbai Yan on 24/07/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import Foundation

class SearchService {
    private let thingStorage = ThingStorage()
    
    private(set) var things = [ThingModel]()
    
    init() {
        things = thingStorage.getThings()
    }
    
    func getThings(byTag tag:String) -> [ThingModel]{
        let thingTagStorage = ThingTagStorage()
        let tagStorage = TagStorage()
        let tagModel = tagStorage.getTag(by: tag)
        let thingTags = thingTagStorage.getThingTags(by: tagModel)
        let thingTagIds = thingTags.map({$0.thingId!})
        let filteredThings = things.filter { (thing) -> Bool in
            return thingTagIds.contains(thing.id)
        }
        return filteredThings
    }
    
    func getThings(byText searchText:String) -> [ThingModel]{
        let filteredThings = self.things.filter({ (thing) -> Bool in
            return thing.content!.contains(searchText)
        })
        return filteredThings
    }
}
