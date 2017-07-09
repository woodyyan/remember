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
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func save(for tag:TagModel){
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Tag", into: appDelegate.persistentContainer.viewContext)
        entity.setValue(tag.id, forKey: "id")
        entity.setValue(tag.name, forKey: "name")
        entity.setValue(tag.index, forKey: "index")
        appDelegate.saveContext()
    }
    
    func getAllTags() -> [TagModel]{
        var tags = [TagModel]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tag")
        do{
            if let results = try appDelegate.persistentContainer.viewContext.fetch(request) as? [TagEntity]{
                if results.count > 0{
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
    
    func getTags(by ids:[String]) -> [TagModel]{
        var tags = [TagModel]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tag")
        let predicate = NSPredicate(format: "%K IN %@", "id", ids)
        request.predicate = predicate
        do{
            if let results = try appDelegate.persistentContainer.viewContext.fetch(request) as? [TagEntity]{
                if results.count > 0{
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
    
    func find(by tagName:String) -> TagModel?{
        var tag:TagModel?
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tag")
        let predicate = NSPredicate(format: "%K == %@", "name", tagName)
        request.predicate = predicate
        do{
            if let results = try appDelegate.persistentContainer.viewContext.fetch(request) as? [TagEntity]{
                tag = results.first?.toModel()
            }
        } catch {
        }
        
        return tag
    }
}