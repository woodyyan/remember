//
//  ViewModelFactory.swift
//  Remember
//
//  Created by Songbai Yan on 2018/4/23.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation

class ViewModelFactory {
    private static var single: ViewModelFactory!
    
    static var shared: ViewModelFactory {
        if single == nil {
            single = ViewModelFactory()
        }
        return single
    }
    
    private var viewModels = [BaseViewModel]()
    
    private init() {
        let context = CoreStorage.shared.persistentContainer.viewContext
        let tagStorage = TagStorage(context: context)
        let thingStorage = ThingStorage(context: context)
        let thingTagStorage = ThingTagStorage(context: context)
        viewModels.append(HomeViewModel(tagStorage: tagStorage, thingStorage: thingStorage, thingTagStorage: thingTagStorage))
        viewModels.append(AboutViewModel())
        viewModels.append(VoiceInputViewModel())
        viewModels.append(TipsViewModel())
        viewModels.append(EditThingViewModel(thingStorage: thingStorage))
        viewModels.append(InputThingViewModel(thingStorage: thingStorage))
        viewModels.append(SettingsViewModel(thingStorage: thingStorage))
        viewModels.append(TagManagementViewModel(tagStorage: tagStorage, thingTagStorage: thingTagStorage))
        viewModels.append(TagManagementViewControllerModel(tagStorage: tagStorage, thingTagStorage: thingTagStorage))
        viewModels.append(SearchViewModel(tagStorage: tagStorage, thingStorage: thingStorage, thingTagStorage: thingTagStorage))
        viewModels.append(ThingTableCellViewModel(tagStorage: tagStorage, thingTagStorage: thingTagStorage))
    }
    
    func create<T>() -> T {
        let viewModel: T = viewModels.first { (vm) -> Bool in
            return vm is T
            } as! T
        return viewModel
    }
}
