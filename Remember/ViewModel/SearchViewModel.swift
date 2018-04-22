//
//  SearchViewModel.swift
//  Remember
//
//  Created by Songbai Yan on 2018/4/21.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation

class SearchViewModel {
    private var tagStorage: TagStorage!
    
    init(tagStorage: TagStorage) {
        self.tagStorage = tagStorage
    }
    
    func getAllTags() -> [TagModel] {
        return tagStorage.findAll()
    }
}
