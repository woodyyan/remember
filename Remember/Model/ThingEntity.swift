//
//  ThingEntity.swift
//  Remember
//
//  Created by Songbai Yan on 04/01/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import Foundation

class ThingEntity {
    var content:String!
    var createdAt:NSDate!
    var id:String!
    var index:Int!
    
    init(content:String, createdAt:NSDate, index:Int) {
        let uuid = UUID().uuidString
        self.id = uuid
        self.content = content
        self.createdAt = createdAt
        self.index = index
    }
}
