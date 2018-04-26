//
//  ThingCellBackgroundStyle.swift
//  Remember
//
//  Created by Songbai Yan on 2018/4/26.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation

enum ThingCellBackgroundStyle: Int {
    case normal //正常情况，四个缺角
    case first //第一个cell，只有下面两个缺角
    case last //最后一个cell，只有上面两个缺角
    case one //只有一个cell，没有缺角
}
