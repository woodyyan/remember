//
//  ThingTagEntity+CoreDataClass.swift
//  Remember
//
//  Created by Songbai Yan on 06/07/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import Foundation
import CoreData

@objc(ThingTagEntity)
public class ThingTagEntity: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ThingTagEntity> {
        return NSFetchRequest<ThingTagEntity>(entityName: "ThingTag")
    }
    
    @NSManaged public var thing: ThingEntity?
    @NSManaged public var tag: TagEntity?
}
