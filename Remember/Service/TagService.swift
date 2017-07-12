//
//  TagService.swift
//  Remember
//
//  Created by Songbai Yan on 08/07/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import Foundation

class TagService {
    private let tagStorage = TagStorage()
    private let thingTagStorage = ThingTagStorage()
    
    func saveThingTag(_ thingTag:ThingTagModel){
        thingTagStorage.save(for: thingTag)
    }
    
    func deleteThingTag(_ thingTag:ThingTagModel){
        thingTagStorage.delete(for: thingTag)
    }
    
    func save(_ tag:TagModel){
        tagStorage.save(for: tag)
    }
    
    func exists(_ tag:String) -> Bool{
        let tagModel = tagStorage.find(by: tag)
        
        return tagModel != nil
    }
    
    func updateIndex(for tag:TagModel){
        tagStorage.updateIndex(for: tag)
    }
    
    func getSelectedTags(by thing:ThingModel) -> [TagModel]{
        let thingTags = thingTagStorage.getThingTags(by: thing)
        let tagIds = thingTags.filter({ $0.thingId == thing.id }).map({ $0.tagId! })
        let tags = tagStorage.getTags(by:tagIds)
        return tags
    }
    
    func getUnselectedTags(by thing:ThingModel) -> [TagModel]{
        let tags = tagStorage.getAllTags()
        let thingTags = thingTagStorage.getThingTags(by: thing)
        let unselectedTags = tags.filter { (tag) -> Bool in
            return !thingTags.contains(where: { (thingTag) -> Bool in
                return thingTag.tagId == tag.id
            })
        }
        return unselectedTags
    }
}
