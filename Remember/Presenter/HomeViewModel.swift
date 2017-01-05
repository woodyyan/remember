//
//  File.swift
//  Remember
//
//  Created by Songbai Yan on 21/12/2016.
//  Copyright © 2016 Songbai Yan. All rights reserved.
//

import Foundation

class HomeViewModel {
    private(set) var things = [ThingEntity]()
    
    init() {
        things = ThingRepository.sharedInstance.getThings()
    }
    
    func deleteThing(_ thing:ThingEntity){
        ThingRepository.sharedInstance.deleteThing(thing: thing)
    }
}
