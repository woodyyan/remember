//
//  TagEntity+CoreDataClass.swift
//  Remember
//
//  Created by Songbai Yan on 06/07/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import Foundation
import CoreData

@objc(TagEntity)
public class TagEntity: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TagEntity> {
        return NSFetchRequest<TagEntity>(entityName: "Tag")
    }
    
    @NSManaged public var id: String?
    @NSManaged public var index: Int32
    @NSManaged public var name: String?
    @NSManaged public var thingTag: NSSet?
}

// MARK: Generated accessors for thingTag
extension TagEntity {
    
    @objc(addThingTagObject:)
    @NSManaged public func addToThingTag(_ value: ThingTagEntity)
    
    @objc(removeThingTagObject:)
    @NSManaged public func removeFromThingTag(_ value: ThingTagEntity)
    
    @objc(addThingTag:)
    @NSManaged public func addToThingTag(_ values: NSSet)
    
    @objc(removeThingTag:)
    @NSManaged public func removeFromThingTag(_ values: NSSet)
    
}
