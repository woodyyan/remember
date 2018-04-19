//
//  ThingEntity+CoreDataClass.swift
//  Remember
//
//  Created by Songbai Yan on 06/07/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import Foundation
import CoreData

public class ThingEntity: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ThingEntity> {
        return NSFetchRequest<ThingEntity>(entityName: "Thing")
    }
    
    @NSManaged public var content: String?
    @NSManaged public var createdAt: NSDate?
    @NSManaged public var id: String?
    @NSManaged public var index: Int32
}

extension ThingEntity {
    func toModel() -> ThingModel {
        var thingModel = ThingModel(content: self.content!)
        thingModel.createdAt = self.createdAt! as Date
        thingModel.id = self.id!
        thingModel.index = Int(self.index)
        
        return thingModel
    }
}
