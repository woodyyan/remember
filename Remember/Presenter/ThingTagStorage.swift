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
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func save(for thingTag:ThingTagEntity){
//        let entity = NSEntityDescription.insertNewObject(forEntityName: "ThingTag", into: appDelegate.persistentContainer.viewContext)
//        entity.setValue(thingTag.tagId, forKey: "tagId")
//        entity.setValue(thingTag.thingId, forKey: "thingId")
////        entity.setValue(thingTag.thing, forKey: "thing")
//        entity.setValue(thingTag.tag, forKey: "tag")
//        appDelegate.saveContext()
    }
    
    func getThingTags(by thing:ThingModel) -> [ThingTagModel]{
//        var thingTags = [ThingTagEntity]()
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ThingTag")
//        let entity = NSEntityDescription.entity(forEntityName: "ThingTag", in: appDelegate.persistentContainer.viewContext)
//        request.entity = entity
//        let predicate = NSPredicate(format: "%K == %@","thingId", thing.id!)
//        request.predicate = predicate
//        do{
//            if let results = try appDelegate.persistentContainer.viewContext.fetch(request) as? [NSManagedObject]{
//                for result in results {
//                    guard let thingId = result.value(forKey: "thingId") as? String else {
//                        continue
//                    }
//                    
//                    guard let tagId = result.value(forKey: "tagId") as? String else {
//                        continue
//                    }
//
//                    let thingTagEntity = ThingTagEntity()
//                    thingTagEntity.thingId = thingId
//                    thingTagEntity.tagId = tagId
//                    thingTags.append(thingTagEntity)
//                }
//            }
//        }catch{
//        }
//        return thingTags
        return [ThingTagModel]()
    }
}
