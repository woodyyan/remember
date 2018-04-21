//
//  VoiceInputViewModel.swift
//  Remember
//
//  Created by Songbai Yan on 08/03/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import Foundation

class VoiceInputViewModel {
    private var thingStorage = ThingStorage(context: CoreStorage.shared.persistentContainer.viewContext)
    
    init() {
    }
    
    func saveThing(_ content: String) -> ThingModel {
        var thing = ThingModel(content: content)
        thing.content = content
        thingStorage.create(thing)
        return thing
    }
}
