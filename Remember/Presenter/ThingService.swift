//
//  ThingService.swift
//  Remember
//
//  Created by Songbai Yan on 03/07/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import Foundation

class ThingService {
    private let tagStorage = TagStorage()
    private let thingTagStorage = ThingTagStorage()
    
    func saveThingTag(for tag:TagEntity, with thingTag:ThingTagEntity){
        tagStorage.save(for: tag)
        thingTagStorage.save(for: thingTag)
    }
    
    func exists(_ tag:String) -> Bool{
        //TODO
        return false
    }
    
    func edit(_ thing:ThingModel){
        ThingRepository.sharedInstance.edit(thing)
    }
    
    func getSelectedTags(by thing:ThingModel) -> [TagModel]{
//        let thingTags = thingTagStorage.getThingTags(by: thing)
        return []
    }
    
    func getUnselectedTags(by thing:ThingModel) -> [TagModel]{
//        let tags = tagStorage.getAllTags()
//        let thingTags = thingTagStorage.getThingTags(by: thing)
//        let unselectedTags = tags.filter { (tag) -> Bool in
//            return !thingTags.contains(where: { (thingTag) -> Bool in
//                return thingTag.tagId == tag.id
//            })
//        }
//        return unselectedTags
        return [TagModel]()
    }
    
    func getCreatedDateText(from date:Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd hh:mm"
        let dateText = "创建于 " + dateFormatter.string(from: date as Date)
        return dateText
    }
}
