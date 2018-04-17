//
//  TipsViewModel.swift
//  Remember
//
//  Created by Songbai Yan on 10/03/2018.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation

class TipsViewModel {
    func getTipText(_ index: Int) -> NSAttributedString {
        let result = getFullTextAndTypeLength(index: index)
        let fullText: String! = result.0
        let typeLength = result.1
        
        let attributedString = NSMutableAttributedString(string: fullText)
        let range = NSRange(location: 0, length: typeLength)
        attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 12), range: range)
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.remember, range: range)
        return attributedString
    }
    
    // swiftlint:disable function_body_length
    // swiftlint:disable cyclomatic_complexity
    private func getFullTextAndTypeLength(index: Int) -> (String, Int) {
        var fullText: String!
        var typeLength = 0
        switch index {
        case 0:
            fullText = Tip.longPressOrderTip.fullName()
            typeLength = Tip.longPressOrderTip.type.count
        case 1:
            fullText = Tip.touch3DTip.fullName()
            typeLength = Tip.touch3DTip.type.count
        case 2:
            fullText = Tip.leftSlideThingTip.fullName()
            typeLength = Tip.leftSlideThingTip.type.count
        case 3:
            fullText = Tip.tagDeleteTip.fullName()
            typeLength = Tip.tagDeleteTip.type.count
        case 4:
            fullText = Tip.searchByTagTip.fullName()
            typeLength = Tip.searchByTagTip.type.count
        case 5:
            fullText = Tip.shareThingTip.fullName()
            typeLength = Tip.shareThingTip.type.count
        case 6:
            fullText = Tip.multiTagTip.fullName()
            typeLength = Tip.multiTagTip.type.count
        case 7:
            fullText = Tip.sampleTip1.fullName()
            typeLength = Tip.sampleTip1.type.count
        case 8:
            fullText = Tip.sampleTip2.fullName()
            typeLength = Tip.sampleTip2.type.count
        case 9:
            fullText = Tip.sampleTip3.fullName()
            typeLength = Tip.sampleTip3.type.count
        case 10:
            fullText = Tip.sampleTip4.fullName()
            typeLength = Tip.sampleTip4.type.count
        case 11:
            fullText = Tip.sampleTip5.fullName()
            typeLength = Tip.sampleTip5.type.count
        case 12:
            fullText = Tip.sampleTip6.fullName()
            typeLength = Tip.sampleTip6.type.count
        case 13:
            fullText = Tip.sampleTip7.fullName()
            typeLength = Tip.sampleTip7.type.count
        default: break
        }
        return (fullText, typeLength)
    }
    
    func getTipCount() -> Int {
        return 14
    }
}

struct Tip {
    static let longPressOrderTip = Tip(text: "tipLongPressToOrder", type: TipType.function)
    static let touch3DTip = Tip(text: "tipQuickAction", type: TipType.function)
    static let leftSlideThingTip = Tip(text: "tipLeftSlideToShareDeleteTag", type: TipType.function)
    static let tagDeleteTip = Tip(text: "tipTagManagerCanDeleteTag", type: TipType.function)
    static let searchByTagTip = Tip(text: "tipSearchByTag", type: TipType.function)
    static let shareThingTip = Tip(text: "tipShareThing", type: TipType.function)
    static let multiTagTip = Tip(text: "tipMultiTagsOneThing", type: TipType.function)
    static let sampleTip1 = Tip(text: "example1", type: TipType.sample)
    static let sampleTip2 = Tip(text: "example2", type: TipType.sample)
    static let sampleTip3 = Tip(text: "example3", type: TipType.sample)
    static let sampleTip4 = Tip(text: "example4", type: TipType.sample)
    static let sampleTip5 = Tip(text: "example5", type: TipType.sample)
    static let sampleTip6 = Tip(text: "example6", type: TipType.sample)
    static let sampleTip7 = Tip(text: "example7", type: TipType.sample)
    
    let text: String!
    let type: String!
    
    init(text: String, type: TipType) {
        self.text = NSLocalizedString(text, comment: "")
        self.type = NSLocalizedString(type.rawValue, comment: "")
    }
    
    func fullName() -> String {
        return self.type + self.text
    }
}

enum TipType: String {
    case function = "skill"
    case sample = "example"
}
