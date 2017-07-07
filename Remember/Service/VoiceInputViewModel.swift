//
//  VoiceInputViewModel.swift
//  Remember
//
//  Created by Songbai Yan on 08/03/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import Foundation

class VoiceInputViewModel{
    private let thingStorage = ThingStorage()
    
    func saveThing(_ content:String) -> ThingModel{
        let thing = ThingModel(content: content)
        thing.content = content
        thingStorage.create(thing)
        return thing
    }
}
