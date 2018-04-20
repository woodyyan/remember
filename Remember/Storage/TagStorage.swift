//
//  TagStorage.swift
//  Remember
//
//  Created by Songbai Yan on 04/07/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class TagStorage {
    private let tagName = "Tag"
    
    private var context: NSManagedObjectContext!
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func save(for tag: TagModel) {
        let entity = NSEntityDescription.insertNewObject(forEntityName: tagName, into: self.context)
        entity.setValue(tag.id, forKey: "id")
        entity.setValue(tag.name, forKey: "name")
        entity.setValue(tag.index, forKey: "index")
        self.context.saveIfNeeded()
    }
    
    func delete(_ tag: TagModel) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: tagName)
        let predicate = NSPredicate(format: "%K == %@", "id", tag.id)
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
    
    func findAll() -> [TagModel] {
        var tags = [TagModel]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: tagName)
        do {
            if let results = try self.context.fetch(request) as? [NSManagedObject] {
                if !results.isEmpty {
                    for result in results {
                        tags.append(result.toTagModel())
                    }
                }
            }
        } catch {
        }
        
        tags.sort { $0.index > $1.index }
        
        return tags
    }
    
    func getTags(by ids: [String]) -> [TagModel] {
        var tags = [TagModel]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: tagName)
        let predicate = NSPredicate(format: "%K IN %@", "id", ids)
        request.predicate = predicate
        do {
            if let results = try self.context.fetch(request) as? [NSManagedObject] {
                if !results.isEmpty {
                    for result in results {
                        tags.append(result.toTagModel())
                    }
                }
            }
        } catch {
        }
        
        tags.sort { $0.index > $1.index }
        
        return tags
    }
    
    func updateIndex(for tag: TagModel) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: tagName)
        let entity = NSEntityDescription.entity(forEntityName: tagName, in: self.context)
        request.entity = entity
        let predicate = NSPredicate(format: "%K == %@", "id", tag.id!)
        request.predicate = predicate
        do {
            if let results = try self.context.fetch(request) as? [NSManagedObject] {
                for result in results {
                    result.setValue(tag.index, forKey: "index")
                    self.context.saveIfNeeded()
                }
            }
        } catch {
            
        }
    }
    
    func find(by name: String) -> TagModel? {
        var tag: TagModel?
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: tagName)
        let predicate = NSPredicate(format: "%K == %@", "name", name)
        request.predicate = predicate
        do {
            if let results = try self.context.fetch(request) as? [NSManagedObject] {
                tag = results.first?.toTagModel()
            }
        } catch {
        }
        
        return tag
    }
}
