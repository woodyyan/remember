//
//  ThingModel.swift
//  Remember
//
//  Created by Songbai Yan on 06/07/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import Foundation

struct ThingModel {
    var content: String
    var createdAt: Date
    var id: String
    var index: Int = 0
    var isNew = false
    
    init(content: String) {
        self.content = content
        self.id = UUID().uuidString
        self.createdAt = Date()
    }
}
