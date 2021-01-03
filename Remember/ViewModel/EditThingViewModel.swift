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
    
    func delete(_ thing: ThingModel) {
        self.thingStorage.delete(thing)
    }
    
    func getCurrentLanguage() -> Language {
        let preferredLang = Bundle.main.preferredLocalizations.first! as NSString
        switch String(describing: preferredLang) {
        case "en-US", "en-CN", "en":
            return Language.EN // 英文
        case "zh-Hans-US", "zh-Hans-CN", "zh-Hant-CN", "zh-TW", "zh-HK", "zh-Hans", "zh":
            return Language.ZH // 中文
        default:
            return Language.EN
        }
    }
}

enum Language {
    case EN
    case ZH
}
