//
//  ThingTagModel.swift
//  Remember
//
//  Created by Songbai Yan on 06/07/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import Foundation

class ThingTagModel {
    var thingId: String!
    var tagId: String!
    var id:String!
    
    init(thingId:String, tagId:String){
        self.thingId = thingId
        self.tagId = tagId
        self.id = UUID().uuidString
    }
}
