//
//  ThingTableCellViewModel.swift
//  Remember
//
//  Created by Songbai Yan on 2018/4/21.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation

class ThingTableCellViewModel {
    private var tagStorage: TagStorage!
    private var thingTagStorage: ThingTagStorage!
    
    init(tagStorage: TagStorage, thingTagStorage: ThingTagStorage) {
        self.tagStorage = tagStorage
        self.thingTagStorage = thingTagStorage
    }
    
    func getJointTagText(for thing: ThingModel) -> String {
        let tags = thing.getSelectedTags(tagStorage: tagStorage, thingTagStorage: thingTagStorage)
        
        let tagString = tags.filter({$0.name != nil}).map({$0.name!}).joined(separator: "/")
        
        return tagString
    }
}
