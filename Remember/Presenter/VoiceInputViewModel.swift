//
//  VoiceInputViewModel.swift
//  Remember
//
//  Created by Songbai Yan on 08/03/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import Foundation

class VoiceInputViewModel{
    func saveThing(_ content:String) -> ThingEntity{
        let thing = ThingEntity(content: content, createdAt: NSDate(), index: 0)
        ThingRepository.sharedInstance.createThing(thing: thing)
        return thing
    }
}
