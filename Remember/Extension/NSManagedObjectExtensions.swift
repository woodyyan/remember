//
//  NSManagedObjectExtensions.swift
//  Remember
//
//  Created by Songbai Yan on 2018/4/20.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    func toThingModel() -> ThingModel {
        let content = self.value(forKey: "content") as! String
        let createdAt = self.value(forKey: "createdAt") as! Date
        let id = self.value(forKey: "id") as! String
        let index = self.value(forKey: "index") as! Int
        
        var thingModel = ThingModel(content: content)
        thingModel.createdAt = createdAt
        thingModel.id = id
        thingModel.index = index
        
        return thingModel
    }
    
    func toTagModel() -> TagModel {
        let name = self.value(forKey: "name") as! String
        let id = self.value(forKey: "id") as! String
        let index = self.value(forKey: "index") as! Int
        
        var tagModel = TagModel(name: name)
        tagModel.id = id
        tagModel.index = index
        return tagModel
    }
}
