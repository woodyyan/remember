//
//  EditThingViewModel.swift
//  Remember
//
//  Created by Songbai Yan on 28/02/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import Foundation

class EditThingViewModel{
    func editThing(_ thing:ThingEntity){
        ThingRepository.sharedInstance.editThing(thing: thing)
    }
}
