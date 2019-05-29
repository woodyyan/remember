//
//  StubThingStorage.swift
//  RememberTests
//
//  Created by Songbai Yan on 2018/4/26.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation

class StubThingStorage: ThingStorage {
    
    var things = [ThingModel]()
    
    init() {
        super.init(context: CoreStorage.shared.persistentContainer.viewContext)
    }
    
    override func create(_ thing: ThingModel) {
        
    }
    
    override func edit(_ thing: ThingModel) {
        let index = things.firstIndex { (t) -> Bool in
            return t.id == thing.id
        }
        things.remove(at: index!)
        things.append(thing)
    }
    
    override func delete(_ thing: ThingModel) {
        let index = things.firstIndex { (t) -> Bool in
            return t.id == thing.id
        }
        things.remove(at: index!)
    }
    
    override func findAll() -> [ThingModel] {
        return things
    }
}
