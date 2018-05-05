//
//  StubThingTagStorage.swift
//  RememberTests
//
//  Created by Songbai Yan on 2018/4/26.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation

class StubThingTagStorage: ThingTagStorage {
    
    var thingTags = [ThingTagModel]()
    
    init() {
        super.init(context: CoreStorage.shared.persistentContainer.viewContext)
    }
    
    override func save(for thingTag: ThingTagModel) {
        thingTags.append(thingTag)
    }
    
    override func delete(for thingTag: ThingTagModel) {
        let index = thingTags.index { (m) -> Bool in
            return thingTag.id == m.id
        }
        thingTags.remove(at: index!)
    }
    
    override func findThingTagsBy(thingId: String) -> [ThingTagModel] {
        return thingTags.filter({ (t) -> Bool in
            return t.thingId == thingId
        })
    }
}
