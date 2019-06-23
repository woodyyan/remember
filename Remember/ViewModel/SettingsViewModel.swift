//
//  SettingsViewModel.swift
//  Remember
//
//  Created by Songbai Yan on 2018/4/21.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation

class SettingsViewModel: BaseViewModel {
    private var thingStorage: ThingStorage!
    private var thingTagStorage: ThingTagStorage!
    private var tagStorage: TagStorage!
    
    var settings: Settings!
    
    init(thingStorage: ThingStorage, tagStorage: TagStorage, thingTagStorage: ThingTagStorage) {
        self.thingStorage = thingStorage
        self.tagStorage = tagStorage
        self.thingTagStorage = thingTagStorage
    }
    
    func initSettings() {
        settings = Settings()
        
        var tagSection = Section()
        let tagItem = SettingItem(title: NSLocalizedString("tagManager", comment: "标签管理"), icon: "tag_gray")
        tagSection.items.append(tagItem)
        settings.sections.append(tagSection)
        
        var othersSection = Section()
        
        let tipsItem = SettingItem(title: NSLocalizedString("tips", comment: "使用小提示"), icon: "tips")
        othersSection.items.append(tipsItem)
        
        let recommandItem = SettingItem(title: NSLocalizedString("tellFriends", comment: "告诉小伙伴"), icon: "share_gray")
        othersSection.items.append(recommandItem)
        
        let rateItem = SettingItem(title: NSLocalizedString("reviewInAppStore", comment: "给我们评分"), icon: "like_gray")
        othersSection.items.append(rateItem)
        
        let feedbackItem = SettingItem(title: NSLocalizedString("feedback", comment: "反馈与建议"), icon: "feedback")
        // TODO: get feedback
        othersSection.items.append(feedbackItem)
        
        let exportItem = SettingItem(title: NSLocalizedString("export", comment: "导出数据"), icon: "export")
        othersSection.items.append(exportItem)
        
        settings.sections.append(othersSection)
        
        var aboutSection = Section()
        var aboutItem = SettingItem(title: NSLocalizedString("about", comment: "关于"), icon: "about_gray")
        aboutItem.detailText = "V \(VersionUtils.getCurrentVersion())"
        aboutSection.items.append(aboutItem)
        settings.sections.append(aboutSection)
    }
    
    func getAllThingCount() -> Int {
        let things = thingStorage.findAll()
        return things.count
    }
    
    func export() -> URL {
        let exporter = CsvExporter()
        let things = thingStorage.findAll()
        var content = ""
        for thing in things {
            let tags = thing.getSelectedTags(tagStorage: tagStorage, thingTagStorage: thingTagStorage)
            let allTag = tags.map { $0.name }.joined(separator: "/")
            content += "\"\(thing.content)\",\(thing.createdAt),\(allTag)\n"
        }
        return exporter.generateCsv(csv: content)
    }
}
