//
//  HomeViewModel.swift
//  Remember
//
//  Created by Songbai Yan on 02/04/2018.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation
import LocalAuthentication

class HomeViewModel: BaseViewModel {
    private var tagStorage: TagStorage!
    private var thingStorage: ThingStorage!
    private var thingTagStorage: ThingTagStorage!
    
    var pasteContent: String?
    var things = [ThingModel]()
    
    init(tagStorage: TagStorage, thingStorage: ThingStorage, thingTagStorage: ThingTagStorage!) {
        super.init()
        self.tagStorage = tagStorage
        self.thingStorage = thingStorage
        self.thingTagStorage = thingTagStorage
        self.refreshThings()
    }
    
    func refreshThings() {
        things = thingStorage.findAll()
    }
    
    func addPastContent() -> Bool {
        if let content = pasteContent {
            var thing = ThingModel(content: content)
            thing.isNew = true
            self.thingStorage.create(thing)
            self.things.insert(thing, at: 0)
            self.sortAndSaveThings()
            pasteContent = nil
            return true
        }
        return false
    }
    
    func getCellBackgroundStyle(_ index: Int) -> ThingCellBackgroundStyle {
        var style = ThingCellBackgroundStyle.normal
        let lastNumber = self.things.count - 1
        switch index {
        case 0:
            style = ThingCellBackgroundStyle.first
        case lastNumber:
            style = ThingCellBackgroundStyle.last
        default:
            style = ThingCellBackgroundStyle.normal
        }
        
        if self.things.count == 1 {
            style = ThingCellBackgroundStyle.one
        }
        
        return style
    }
    
    func addPasteContentToSettings(_ content: String) {
        UserDefaults.standard.set(content, forKey: "pasteboardContent")
        UserDefaults.standard.synchronize()
    }
    
    func calculateCellHeight(viewWidth: CGFloat, row: Int) -> CGFloat {
        let thing = self.things[row]
        let content: NSString = thing.content as NSString
        let expectSize = CGSize(width: viewWidth - 60, height: CGFloat.greatestFiniteMagnitude)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let size = content.boundingRect(with: expectSize, options: option, attributes: attributes, context: nil)
        var height = size.height + 40
        let tags = thing.getSelectedTags(tagStorage: tagStorage, thingTagStorage: thingTagStorage)
        let hasTag = !tags.isEmpty
        if hasTag {
            height = size.height + 50
        }
        return height
    }
    
    func deleteThing(index: Int) {
        let thing = self.things[index]
        self.things.remove(at: index)
        self.thingStorage.delete(thing)
    }
    
    func sortAndSaveThings() {
        var set = Set<Int>()
        self.things.forEach { set.insert($0.index) }
        if set.count < self.things.count || self.things[0].index != 0 {
            for i in 0..<self.things.count {
                self.things[i].index = i
            }

        }
        
        self.thingStorage.save(sorted: self.things)
    }
    
    func errorMessageForLAErrorCode(errorCode: Int) -> String {
        var message = ""
        
        switch errorCode {
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.touchIDLockout.rawValue:
            message = "Too many failed attempts."
            
        case LAError.touchIDNotAvailable.rawValue:
            message = "TouchID is not available on the device"
            //            showPassWordInput()
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = "Did not find error code on LAError object"
        }
        return message
    }
}
