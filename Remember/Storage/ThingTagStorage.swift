//
//  ThingTagStorage.swift
//  Remember
//
//  Created by Songbai Yan on 04/07/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ThingTagStorage: CoreStorage {
    func save(for thingTag: ThingTagModel) {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "ThingTag", into: self.persistentContainer.viewContext)
        entity.setValue(thingTag.id, forKey: "id")
        entity.setValue(thingTag.tagId, forKey: "tagId")
        entity.setValue(thingTag.thingId, forKey: "thingId")
        self.saveContext()
    }
    
    func delete(for thingTag: ThingTagModel) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ThingTag")
        let entity = NSEntityDescription.entity(forEntityName: "ThingTag", in: self.persistentContainer.viewContext)
        request.entity = entity
        let predicate = NSPredicate(format: "thingId == %@ && tagId == %@", thingTag.thingId, thingTag.tagId)
        request.predicate = predicate
        do {
            if let results = try self.persistentContainer.viewContext.fetch(request) as? [ThingTagEntity] {
                if !results.isEmpty {
                    for result in results {
                        self.persistentContainer.viewContext.delete(result)
                    }
                    self.saveContext()
                }
            }
        } catch {
        }
    }
    
    func getThingTags(by tag: TagModel) -> [ThingTagModel] {
        var thingTags = [ThingTagModel]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ThingTag")
        let entity = NSEntityDescription.entity(forEntityName: "ThingTag", in: self.persistentContainer.viewContext)
        request.entity = entity
        let predicate = NSPredicate(format: "%K == %@", "tagId", tag.id!)
        request.predicate = predicate
        do {
            if let results = try self.persistentContainer.viewContext.fetch(request) as? [ThingTagEntity] {
                for result in results {
                    thingTags.append(result.toModel())
                }
            }
        } catch {
        }
        return thingTags
    }
    
    func getThingTags(by thing: ThingModel) -> [ThingTagModel] {
        var thingTags = [ThingTagModel]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ThingTag")
        let entity = NSEntityDescription.entity(forEntityName: "ThingTag", in: self.persistentContainer.viewContext)
        request.entity = entity
        let predicate = NSPredicate(format: "%K == %@", "thingId", thing.id!)
        request.predicate = predicate
        do {
            if let results = try self.persistentContainer.viewContext.fetch(request) as? [ThingTagEntity] {
                for result in results {
                    thingTags.append(result.toModel())
                }
            }
        } catch {
        }
        return thingTags
    }
}
