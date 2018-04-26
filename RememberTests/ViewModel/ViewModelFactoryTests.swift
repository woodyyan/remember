//
//  ViewModelFactoryTests.swift
//  RememberTests
//
//  Created by Songbai Yan on 2018/4/26.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import XCTest

class ViewModelFactoryTests: XCTestCase {
    
    func testExample() {
        let factory = ViewModelFactory.shared
        
        let homeViewModel:HomeViewModel = factory.create()
        XCTAssertNotNil(homeViewModel)
        
        let aboutViewModel: AboutViewModel = factory.create()
        XCTAssertNotNil(aboutViewModel)
        
        let voiceInputViewModel: VoiceInputViewModel = factory.create()
        XCTAssertNotNil(voiceInputViewModel)
        
        let tipsViewModel: TipsViewModel = factory.create()
        XCTAssertNotNil(tipsViewModel)
        
        let editThingViewModel: EditThingViewModel = factory.create()
        XCTAssertNotNil(editThingViewModel)
        
        let inputThingViewModel: InputThingViewModel = factory.create()
        XCTAssertNotNil(inputThingViewModel)
        
        let settingsViewModel: SettingsViewModel = factory.create()
        XCTAssertNotNil(settingsViewModel)
        
        let tagManagementViewModel: TagManagementViewModel = factory.create()
        XCTAssertNotNil(tagManagementViewModel)
        
        let searchViewModel: SearchViewModel = factory.create()
        XCTAssertNotNil(searchViewModel)
        
        let thingTableCellViewModel: ThingTableCellViewModel = factory.create()
        XCTAssertNotNil(thingTableCellViewModel)
    }
}
