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
    
    func save(for tag:TagEntity){
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Tag", into: appDelegate.persistentContainer.viewContext)
        entity.setValue(tag.id, forKey: "id")
        entity.setValue(tag.name, forKey: "name")
        entity.setValue(tag.index, forKey: "index")
        appDelegate.saveContext()
    }
    
    func getAllTags() -> [TagEntity]{
        var tags = [TagEntity]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tag")
        do{
            if let results = try appDelegate.persistentContainer.viewContext.fetch(request) as? [NSManagedObject]{
                if results.count > 0{
                    for result in results {
                        guard let id = result.value(forKey: "id") as? String else {
                            continue
                        }
                        
                        guard let name = result.value(forKey: "name") as? String else {
                            continue
                        }
                        
                        guard let index = result.value(forKey: "index") as? NSNumber else {
                            continue
                        }
                        
                        let tag = TagEntity()
                        tag.setValue(name, forKey: "name")
                        tag.setValue(id, forKey: "id")
                        tag.setValue(index, forKey: "index")
                        tags.append(tag)
                    }
                }
            }
        } catch {
        }
        
//        tags.sort { $0.index < $1.index }
        
        return tags
    }
}
