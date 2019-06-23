//
//  Settings.swift
//  Remember
//
//  Created by Songbai Yan  on 2019/6/19.
//  Copyright © 2019 Songbai Yan. All rights reserved.
//

import Foundation

struct Settings {
    var sections = [Section]()
    
    func getSection(index: Int) -> Section {
        return sections[index]
    }
    
    func getSettingItem(_ indexPath: IndexPath) -> SettingItem {
        return sections[indexPath.section].items[indexPath.row]
    }
}

struct Section {
    var items = [SettingItem]()
    
    var count: Int {
        return items.count
    }
}

struct SettingItem {
    var title = ""
    var detailText: String?
    var icon: String = ""
    
    init() {
    }
    
    init(title: String, icon: String) {
        self.title = title
        self.icon = icon
    }
}
