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
    
    func getFilteredThings(by searchText:String) -> [ThingModel]{
        let filteredThings = self.things.filter({ (thing) -> Bool in
            return thing.content!.contains(searchText)
        })
        return filteredThings
    }
}
