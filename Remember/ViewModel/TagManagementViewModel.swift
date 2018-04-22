//
//  TagManagementViewModel.swift
//  Remember
//
//  Created by Songbai Yan on 2018/4/21.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation

class TagManagementViewModel {
    private var tagStorage: TagStorage!
    private var thingTagStorage: ThingTagStorage!
    
    init(tagStorage: TagStorage, thingTagStorage: ThingTagStorage) {
        self.tagStorage = tagStorage
        self.thingTagStorage = thingTagStorage
    }
    
    func deleteThingTag(_ thingTag: ThingTagModel) {
        thingTagStorage.delete(for: thingTag)
    }
    
    func saveThingTag(_ thingTag: ThingTagModel) {
        thingTagStorage.save(for: thingTag)
    }
    
    func updateIndex(for tag: TagModel) {
        tagStorage.updateIndex(for: tag)
    }
    
    func exists(_ tag: String) -> Bool {
        let tagModel = tagStorage.find(by: tag)
        
        return tagModel != nil
    }
    
    func saveTagAndThingTag(_ tag: String, thingId: String) {
        var tagModel = TagModel(name: tag)
        tagModel.index = 1
        let thingTagModel = ThingTagModel(thingId: thingId, tagId: tagModel.id)
        
        tagStorage.save(for: tagModel)
        self.saveThingTag(thingTagModel)
    }
    
    func getUnselectedTags(by thing: ThingModel) -> [TagModel] {
        let tags = tagStorage.findAll()
        let thingTags = thingTagStorage.findThingTagsBy(thingId: thing.id)
        let unselectedTags = tags.filter { (tag) -> Bool in
            return !thingTags.contains(where: { (thingTag) -> Bool in
                return thingTag.tagId == tag.id
            })
        }
        return unselectedTags
    }
    
    func getSelectedTags(by thing: ThingModel) -> [TagModel] {
        return thing.getSelectedTags(tagStorage: tagStorage, thingTagStorage: thingTagStorage)
    }
}
