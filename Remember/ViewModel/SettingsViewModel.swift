//
//  SettingsViewModel.swift
//  Remember
//
//  Created by Songbai Yan on 2018/4/21.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation

class SettingsViewModel: BaseViewModel {
    private var thingStorage: ThingStorage!
    private var thingTagStorage: ThingTagStorage!
    private var tagStorage: TagStorage!
    
    init(thingStorage: ThingStorage, tagStorage: TagStorage, thingTagStorage: ThingTagStorage) {
        self.thingStorage = thingStorage
        self.tagStorage = tagStorage
        self.thingTagStorage = thingTagStorage
    }
    
    func getAllThingCount() -> Int {
        let things = thingStorage.findAll()
        return things.count
    }
    
    func export() -> URL {
        let exporter = CsvExporter()
        let things = thingStorage.findAll()
        var content = ""
        for thing in things {
            let tags = thing.getSelectedTags(tagStorage: tagStorage, thingTagStorage: thingTagStorage)
            let allTag = tags.map { $0.name }.joined(separator: "/")
            content += "\"\(thing.content)\",\(thing.createdAt),\(allTag)\n"
        }
        return exporter.generateCsv(csv: content)
    }
}
