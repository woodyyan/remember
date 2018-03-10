//
//  TipsViewModel.swift
//  Remember
//
//  Created by Songbai Yan on 10/03/2018.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation

class TipsViewModel {
    func getTipText(_ index:Int) -> NSAttributedString{
        var attributedString:NSMutableAttributedString!
        var fullText:String!
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
        
        attributedString = NSMutableAttributedString(string: fullText);
        attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 12), range: NSRange(location: 0, length: typeLength))
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.remember(), range: NSRange(location: 0, length: typeLength));
        return attributedString
    }
    
    func getTipCount() -> Int{
        return 14
    }
}

struct Tip{
    static let longPressOrderTip = Tip(text: "长按首页的小事可以排序", type: TipType.function)
    static let touch3DTip = Tip(text: "3D Touch可以快速搜索和记事", type: TipType.function)
    static let leftSlideThingTip = Tip(text: "首页小事左滑可以分享，删除小事和修改标签", type: TipType.function)
    static let tagDeleteTip = Tip(text: "标签管理页面可以删除不用的标签", type: TipType.function)
    static let searchByTagTip = Tip(text: "搜索小事时可以通过标签快速过滤", type: TipType.function)
    static let shareThingTip = Tip(text: "分享小事可以快速把小事分享给别人", type: TipType.function)
    static let multiTagTip = Tip(text: "同一件小事可以添加多个标签", type: TipType.function)
    static let sampleTip1 = Tip(text: "红酒开瓶器在书房的书柜抽屉里", type: TipType.sample)
    static let sampleTip2 = Tip(text: "家里的Wi-Fi密码是XXX", type: TipType.sample)
    static let sampleTip3 = Tip(text: "妈妈的生日是6月30日", type: TipType.sample)
    static let sampleTip4 = Tip(text: "小明家在X小区二期3栋1901", type: TipType.sample)
    static let sampleTip5 = Tip(text: "万达影城1号厅要买7排才是最佳位置", type: TipType.sample)
    static let sampleTip6 = Tip(text: "学术论文链接地址是：http://XXX.com", type: TipType.sample)
    static let sampleTip7 = Tip(text: "7月要看的书单是：解忧杂货店", type: TipType.sample)
    
    let text:String!
    let type:String!
    
    init(text:String, type:TipType) {
        self.text = text
        self.type = type.rawValue
    }
    
    func fullName() -> String {
        return self.type + self.text
    }
}

enum TipType:String {
    case function = "「技巧」"
    case sample = "「例子」"
}
