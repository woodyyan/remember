//
//  ThingService.swift
//  Remember
//
//  Created by Songbai Yan on 03/07/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import Foundation

class ThingService {
    private var thingStorage = ThingStorage(context: CoreStorage.shared.persistentContainer.viewContext)
    private let thingTagStorage = ThingTagStorage(context: CoreStorage.shared.persistentContainer.viewContext)
    private let tagService = TagService()
    
    private(set) var things = [ThingModel]()
    
    init() {
        things = thingStorage.findAll()
    }
    
    func refresh() {
        things = thingStorage.findAll()
    }
    
    func create(_ thing: ThingModel) {
        thingStorage.create(thing)
    }
    
    func delete(_ thing: ThingModel) {
        thingStorage.delete(thing)
        let thingTags = thingTagStorage.findThingTagsBy(thingId: thing.id)
        for thingTag in thingTags {
            thingTagStorage.delete(for: thingTag)
        }
    }
    
    func save(sorted things: [ThingModel]) {
        thingStorage.save(sorted: things)
    }
    
    func hasTag(for thing: ThingModel) -> Bool {
        let tags = tagService.getSelectedTags(by: thing)
        return !tags.isEmpty
    }
    
    func edit(_ thing: ThingModel) {
        thingStorage.edit(thing)
    }
    
    func getAllThingCount() -> Int {
        let things = thingStorage.findAll()
        return things.count
    }
    
    func getCreatedDateText(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd hh:mm"
        let dateText = NSLocalizedString("createAt", comment: "") + dateFormatter.string(from: date as Date)
        return dateText
    }
}
