//
//  VoiceInputViewModel.swift
//  Remember
//
//  Created by Songbai Yan on 08/03/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import Foundation

class VoiceInputViewModel: BaseViewModel {
    private var thingStorage: ThingStorage!
    
    init(thingStorage: ThingStorage) {
        self.thingStorage = thingStorage
    }
    
    func saveThing(_ content: String) -> ThingModel {
        var thing = ThingModel(content: content)
        thing.content = content
        thingStorage.create(thing)
        return thing
    }
}
