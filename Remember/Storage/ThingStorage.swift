//
//  ThingRepository.swift
//  Remember
//
//  Created by Songbai Yan on 21/12/2016.
//  Copyright © 2016 Songbai Yan. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ThingStorage {
    private let thingName = "Thing"
    
    private var context: NSManagedObjectContext!
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func findAll() -> [ThingModel] {
        return getThingsFromLocalDB()
    }
    
    func create(_ thing: ThingModel) {
        createAndSaveThingInLocalDB(thing: thing)
    }
    
    func delete(_ thing: ThingModel) {
        deleteThing(by: thing.id)
    }
    
    func edit(_ thing: ThingModel) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: thingName)
        let entity = NSEntityDescription.entity(forEntityName: thingName, in: self.context)
        request.entity = entity
        let predicate = NSPredicate(format: "%K == %@", "id", thing.id)
        request.predicate = predicate
        do {
            if let results = try context.fetch(request) as? [NSManagedObject] {
                for result in results {
                    result.setValue(thing.content, forKey: "content")
                    self.context.saveIfNeeded()
                }
            }
        } catch {
            
        }
    }
    
    func save(sorted things: [ThingModel]) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: thingName)
        let entity = NSEntityDescription.entity(forEntityName: thingName, in: context)
        request.entity = entity
        for thing in things {
            let predicate = NSPredicate(format: "%K == %@", "id", thing.id)
            request.predicate = predicate
            do {
                if let results = try context.fetch(request) as? [NSManagedObject] {
                    for result in results {
                        result.setValue(thing.index, forKey: "index")
                    }
                }
            } catch {
                
            }
        }
        self.context.saveIfNeeded()
    }
    
    private func deleteThing(by thingId: String) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: thingName)
        let entity = NSEntityDescription.entity(forEntityName: thingName, in: context)
        request.entity = entity
        let predicate = NSPredicate(format: "%K == %@", "id", thingId)
        request.predicate = predicate
        do {
            if let results = try context.fetch(request) as? [NSManagedObject] {
                for result in results {
                    self.context.delete(result)
                    self.context.saveIfNeeded()
                }
            }
        } catch {
            
        }
    }
    
    private func createAndSaveThingInLocalDB(thing: ThingModel) {
        let object: NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: thingName, into: context)
        object.setValue(thing.content, forKey: "content")
        object.setValue(thing.createdAt, forKey: "createdAt")
        object.setValue(thing.id, forKey: "id")
        object.setValue(thing.index, forKey: "index")
        self.context.saveIfNeeded()
    }
    
    private func getThingsFromLocalDB() -> [ThingModel] {
        var things = [ThingModel]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: thingName)
        do {
            if let results = try self.context.fetch(request) as? [NSManagedObject] {
                if !results.isEmpty {
                    for result in results {
                        things.append(result.toModel())
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        things.sort { $0.index < $1.index }
        
        return things
    }
}
