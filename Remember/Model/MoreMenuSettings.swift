//
//  MoreMenuSettings.swift
//  Remember
//
//  Created by Songbai Yan  on 2019/10/30.
//  Copyright © 2019 Songbai Yan. All rights reserved.
//

import Foundation

struct MoreMenuSettings {
    var numberOfRowsInSection: Int
    var heightForRow: CGFloat
    
    var menuItems = [MenuItem]()
    
    func getMenuItem(index: Int) -> MenuItem {
        return menuItems[index]
    }
}
