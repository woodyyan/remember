//
//  InputThingViewModel.swift
//  Remember
//
//  Created by Songbai Yan on 2018/4/21.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation

class InputThingViewModel: BaseViewModel {
    private var thingStorage: ThingStorage!
    
    init(thingStorage: ThingStorage) {
        self.thingStorage = thingStorage
    }
    
    func createThing(with content: String) -> ThingModel {
        var thing = ThingModel(content: content)
        thing.isNew = true
        thingStorage.create(thing)
        return thing
    }
}
