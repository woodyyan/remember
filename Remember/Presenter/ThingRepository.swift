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

class ThingRepository {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    private static let singletonInstance = ThingRepository()
    
    class var sharedInstance : ThingRepository {
        return singletonInstance
    }
    
    private init(){
        
    }
    
    func getThings() -> [ThingEntity]{
        return getThingsFromLocalDB()
    }
    
    func createThing(thing:ThingEntity){
        createAndSaveThingInLocalDB(thing: thing)
    }
    
    func deleteThing(thing:ThingEntity){
        deleteThingFromLocalDB(thing: thing)
    }
    
    private func deleteThingFromLocalDB(thing:ThingEntity){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Thing")
        let entity = NSEntityDescription.entity(forEntityName: "Thing", in: appDelegate.persistentContainer.viewContext)
        request.entity = entity
        let predicate = NSPredicate(format: "%K == %@","id", thing.id)
        request.predicate = predicate
        do{
            if let results = try appDelegate.persistentContainer.viewContext.fetch(request) as? [NSManagedObject]{
                for thing in results {
                    appDelegate.persistentContainer.viewContext.delete(thing)
                    appDelegate.saveContext()
                }
            }
        }catch{
            
        }
    }
    
    private func createAndSaveThingInLocalDB(thing:ThingEntity){
        let object:NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: "Thing", into: appDelegate.persistentContainer.viewContext)
        object.setValue(thing.content, forKey: "content")
        object.setValue(thing.createdAt, forKey: "createdAt")
        object.setValue(thing.id, forKey: "id")
        appDelegate.saveContext()
    }
    
    private func getThingsFromLocalDB() -> [ThingEntity]{
        var things = [ThingEntity]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Thing")
        do{
            if let results = try appDelegate.persistentContainer.viewContext.fetch(request) as? [NSManagedObject]{
                if results.count > 0{
                    for result in results {
                        guard let content = result.value(forKey: "content") as? String else {
                            continue
                        }
                        
                        guard let createdAt = result.value(forKey: "createdAt") as? NSDate else {
                            continue
                        }
                        
                        guard let id = result.value(forKey: "id") as? String else {
                            continue
                        }
                        
                        let thing = ThingEntity(content: content, createdAt: createdAt)
                        thing.id = id
                        things.append(thing)
                    }
                }
            }
        } catch {
        }
        return things
    }
}

