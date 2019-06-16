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
    
    init(thingStorage: ThingStorage) {
        self.thingStorage = thingStorage
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
            content += "\(thing.id),\(thing.content),\(thing.createdAt)\n"
        }
        return exporter.generateCsv(csv: content)
    }
}
