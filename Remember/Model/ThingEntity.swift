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
    
    init(content:String, createdAt:NSDate) {
        self.content = content
        self.createdAt = createdAt
    }
}
