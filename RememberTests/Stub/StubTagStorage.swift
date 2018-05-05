//
//  StubTagStorage.swift
//  RememberTests
//
//  Created by Songbai Yan on 2018/4/26.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation

class StubTagStorage: TagStorage {
    
    var tags = [TagModel]()
    
    init() {
        super.init(context: CoreStorage.shared.persistentContainer.viewContext)
    }
    
    override func findAll() -> [TagModel] {
        return tags
    }
    
    override func find(by name: String) -> TagModel? {
        return tags.first(where: { (t) -> Bool in
            return t.name == name
        })
    }
    
    override func getTags(by ids: [String]) -> [TagModel] {
        return tags.filter({ (t) -> Bool in
            return ids.contains(t.id)
        })
    }
    
    override func updateIndex(for tag: TagModel) {
        tags[0].index = tag.index
    }
    
    override func save(for tag: TagModel) {
        tags.append(tag)
    }
}
