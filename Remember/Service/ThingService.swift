//
//  ThingService.swift
//  Remember
//
//  Created by Songbai Yan on 03/07/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import Foundation

class ThingService {
    private let thingStorage = ThingStorage()
    
    func create(_ thing:ThingModel){
        thingStorage.create(thing)
    }
    
    func edit(_ thing:ThingModel){
        thingStorage.edit(thing)
    }
    
    func delete(_ thing:ThingModel){
        thingStorage.delete(thing)
    }
    
    func getCreatedDateText(from date:Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd hh:mm"
        let dateText = "创建于 " + dateFormatter.string(from: date as Date)
        return dateText
    }
}
