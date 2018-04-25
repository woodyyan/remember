//
//  EditThingViewModel.swift
//  Remember
//
//  Created by Songbai Yan on 2018/4/21.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation

class EditThingViewModel: BaseViewModel {
    private var thingStorage: ThingStorage!
    
    init(thingStorage: ThingStorage) {
        self.thingStorage = thingStorage
    }
    
    func edit(_ thing: ThingModel) {
        self.thingStorage.edit(thing)
    }
}
