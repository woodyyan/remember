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

class TagStorage: CoreStorage {
    func save(for tag: TagModel) {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Tag", into: self.persistentContainer.viewContext)
        entity.setValue(tag.id, forKey: "id")
        entity.setValue(tag.name, forKey: "name")
        entity.setValue(tag.index, forKey: "index")
        self.saveContext()
    }
    
    func delete(_ tag: TagModel) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tag")
        let predicate = NSPredicate(format: "%K == %@", "id", tag.id)
        request.predicate = predicate
        do {
            if let results = try self.persistentContainer.viewContext.fetch(request) as? [TagEntity] {
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
    
    func getAllTags() -> [TagModel] {
        var tags = [TagModel]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tag")
        do {
            if let results = try self.persistentContainer.viewContext.fetch(request) as? [TagEntity] {
                if !results.isEmpty {
                    for result in results {
                        tags.append(result.toModel())
                    }
                }
            }
        } catch {
        }
        
        tags.sort { $0.index > $1.index }
        
        return tags
    }
    
    func getTag(by name: String) -> TagModel? {
        var tag: TagModel?
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tag")
        let predicate = NSPredicate(format: "%K == %@", "name", name)
        request.predicate = predicate
        do {
            if let results = try self.persistentContainer.viewContext.fetch(request) as? [TagEntity] {
                if !results.isEmpty {
                    tag = results[0].toModel()
                }
            }
        } catch {
        }
        
        return tag
    }
    
    func getTags(by ids: [String]) -> [TagModel] {
        var tags = [TagModel]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tag")
        let predicate = NSPredicate(format: "%K IN %@", "id", ids)
        request.predicate = predicate
        do {
            if let results = try self.persistentContainer.viewContext.fetch(request) as? [TagEntity] {
                if !results.isEmpty {
                    for result in results {
                        tags.append(result.toModel())
                    }
                }
            }
        } catch {
        }
        
        tags.sort { $0.index > $1.index }
        
        return tags
    }
    
    func updateIndex(for tag: TagModel) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tag")
        let entity = NSEntityDescription.entity(forEntityName: "Tag", in: self.persistentContainer.viewContext)
        request.entity = entity
        let predicate = NSPredicate(format: "%K == %@", "id", tag.id!)
        request.predicate = predicate
        do {
            if let results = try self.persistentContainer.viewContext.fetch(request) as? [TagEntity] {
                for result in results {
                    result.setValue(tag.index, forKey: "index")
                    self.saveContext()
                }
            }
        } catch {
            
        }
    }
    
    func find(by tagName: String) -> TagModel? {
        var tag: TagModel?
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tag")
        let predicate = NSPredicate(format: "%K == %@", "name", tagName)
        request.predicate = predicate
        do {
            if let results = try self.persistentContainer.viewContext.fetch(request) as? [TagEntity] {
                tag = results.first?.toModel()
            }
        } catch {
        }
        
        return tag
    }
}
