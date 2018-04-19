//
//  HomeViewModel.swift
//  Remember
//
//  Created by Songbai Yan on 02/04/2018.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation

class HomeViewModel {
    private let service = ThingService()
    
    var pasteContent: String?
    var things = [ThingModel]()
    
    init() {
        initData()
    }
    
    func refreshThings() {
        service.refresh()
        initData()
    }
    
    func addPastContent() -> Bool {
        if let content = pasteContent {
            var thing = ThingModel(content: content)
            thing.isNew = true
            self.service.create(thing)
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
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17)]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let size = content.boundingRect(with: expectSize, options: option, attributes: attributes, context: nil)
        var height = size.height + 40
        let hasTag = service.hasTag(for: thing)
        if hasTag {
            height = size.height + 50
        }
        return height
    }
    
    func deleteThing(index: Int) {
        let thing = self.things[index]
        self.things.remove(at: index)
        self.service.delete(thing)
    }
    
    func sortAndSaveThings() {
        var set = Set<Int>()
        self.things.forEach { set.insert($0.index) }
        if set.count < self.things.count || self.things[0].index != 0 {
            for i in 0..<self.things.count {
                self.things[i].index = i
            }
        }
        
        self.service.save(sorted: self.things)
    }
    
    private func initData() {
        things = service.things
    }
}
