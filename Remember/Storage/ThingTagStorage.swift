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

class ThingTagStorage {
    private let thingTagName = "ThingTag"
    
    private var context: NSManagedObjectContext!
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func save(for thingTag: ThingTagModel) {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "ThingTag", into: self.context)
        entity.setValue(thingTag.id, forKey: "id")
        entity.setValue(thingTag.tagId, forKey: "tagId")
        entity.setValue(thingTag.thingId, forKey: "thingId")
        self.context.saveIfNeeded()
    }
    
    func delete(for thingTag: ThingTagModel) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ThingTag")
        let entity = NSEntityDescription.entity(forEntityName: thingTagName, in: self.context)
        request.entity = entity
        let predicate = NSPredicate(format: "thingId == %@ && tagId == %@", thingTag.thingId, thingTag.tagId)
        request.predicate = predicate
        do {
            if let results = try self.context.fetch(request) as? [NSManagedObject] {
                if !results.isEmpty {
                    for result in results {
                        self.context.delete(result)
                    }
                    self.context.saveIfNeeded()
                }
            }
        } catch {
        }
    }
    
    func findThingTagsBy(tagId: String) -> [ThingTagModel] {
        var thingTags = [ThingTagModel]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ThingTag")
        let entity = NSEntityDescription.entity(forEntityName: thingTagName, in: self.context)
        request.entity = entity
        let predicate = NSPredicate(format: "%K == %@", "tagId", tagId)
        request.predicate = predicate
        do {
            if let results = try self.context.fetch(request) as? [NSManagedObject] {
                for result in results {
                    thingTags.append(result.toThingTagModel())
                }
            }
        } catch {
        }
        return thingTags
    }
    
    func findThingTagsBy(thingId: String) -> [ThingTagModel] {
        var thingTags = [ThingTagModel]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ThingTag")
        let entity = NSEntityDescription.entity(forEntityName: thingTagName, in: self.context)
        request.entity = entity
        let predicate = NSPredicate(format: "%K == %@", "thingId", thingId)
        request.predicate = predicate
        do {
            if let results = try self.context.fetch(request) as? [NSManagedObject] {
                for result in results {
                    thingTags.append(result.toThingTagModel())
                }
            }
        } catch {
        }
        return thingTags
    }
}
