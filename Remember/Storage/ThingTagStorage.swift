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
    // swiftlint:disable force_cast
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func save(for thingTag: ThingTagModel) {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "ThingTag", into: appDelegate.persistentContainer.viewContext)
        entity.setValue(thingTag.id, forKey: "id")
        entity.setValue(thingTag.tagId, forKey: "tagId")
        entity.setValue(thingTag.thingId, forKey: "thingId")
        appDelegate.saveContext()
    }
    
    func delete(for thingTag: ThingTagModel) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ThingTag")
        let entity = NSEntityDescription.entity(forEntityName: "ThingTag", in: appDelegate.persistentContainer.viewContext)
        request.entity = entity
        let predicate = NSPredicate(format: "thingId == %@ && tagId == %@", thingTag.thingId, thingTag.tagId)
        request.predicate = predicate
        do {
            if let results = try appDelegate.persistentContainer.viewContext.fetch(request) as? [ThingTagEntity] {
                if !results.isEmpty {
                    for result in results {
                        appDelegate.persistentContainer.viewContext.delete(result)
                    }
                    appDelegate.saveContext()
                }
            }
        } catch {
        }
    }
    
    func getThingTags(by tag: TagModel) -> [ThingTagModel] {
        var thingTags = [ThingTagModel]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ThingTag")
        let entity = NSEntityDescription.entity(forEntityName: "ThingTag", in: appDelegate.persistentContainer.viewContext)
        request.entity = entity
        let predicate = NSPredicate(format: "%K == %@", "tagId", tag.id!)
        request.predicate = predicate
        do {
            if let results = try appDelegate.persistentContainer.viewContext.fetch(request) as? [ThingTagEntity] {
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
        let entity = NSEntityDescription.entity(forEntityName: "ThingTag", in: appDelegate.persistentContainer.viewContext)
        request.entity = entity
        let predicate = NSPredicate(format: "%K == %@", "thingId", thing.id!)
        request.predicate = predicate
        do {
            if let results = try appDelegate.persistentContainer.viewContext.fetch(request) as? [ThingTagEntity] {
                for result in results {
                    thingTags.append(result.toModel())
                }
            }
        } catch {
        }
        return thingTags
    }
}
