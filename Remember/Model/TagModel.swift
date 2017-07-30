//
//  TagModel.swift
//  Remember
//
//  Created by Songbai Yan on 06/07/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import Foundation

class TagModel : Hashable{
    var id: String!
    var index = 0
    var name: String!
    
    init(name:String){
        self.name = name
        self.id = UUID().uuidString
    }
    
    public static func ==(lhs: TagModel, rhs: TagModel) -> Bool{
        return lhs.id == rhs.id
    }
    
    public var hashValue: Int {
        get{
            return id.hashValue
        }
    }
}
