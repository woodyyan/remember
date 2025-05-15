//
//  ThingTypeModel.swift
//  Remember
//
//  Created by 颜松柏 on 2025/2/19.
//  Copyright © 2025 Songbai Yan. All rights reserved.
//

import Foundation
import UIKit

struct ThingTypeModel {
    var name: String
    var type: ThingType
    var color: UIColor
    
    init(name: String, type: ThingType, color: UIColor) {
        self.name = name
        self.type = type
        self.color = color
    }
}

extension ThingTypeModel {
    static func count() -> Int {
        return 4
    }
    
    static func getAllTypes() -> [ThingTypeModel] {
        var types = [ThingTypeModel]()
        types.append(ThingTypeModel(name: NSLocalizedString("accountPassword", comment: "账号密码"), type: .password, color: .red))
        types.append(ThingTypeModel(name: NSLocalizedString("note", comment: "备忘录"), type: .card, color: .aboutBottomColor))
        types.append(ThingTypeModel(name: NSLocalizedString("address", comment: "地址"), type: .address))
        types.append(ThingTypeModel(name: NSLocalizedString("idcard", comment: "证件信息"), type: .note))
        return types
    }
}
