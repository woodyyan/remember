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
}

extension TagEntity {
    func toModel() -> TagModel {
        var tagModel = TagModel(name: self.name!)
        tagModel.id = self.id
        tagModel.index = Int(self.index)
        return tagModel
    }
}
