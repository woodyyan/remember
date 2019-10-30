//
//  MoreMenuViewModel.swift
//  Remember
//
//  Created by Songbai Yan  on 2019/10/30.
//  Copyright © 2019 Songbai Yan. All rights reserved.
//

import Foundation

class MoreMenuViewModel: BaseViewModel {
    
    var moreMenuSettings: MoreMenuSettings!
    
    override init() {
        moreMenuSettings = MoreMenuSettings(numberOfRowsInSection: 3, heightForRow: 30)
        
        moreMenuSettings.menuItems.append(MenuItem(text: NSLocalizedString("share", comment: "分享"), imageName: "share"))
        moreMenuSettings.menuItems.append(MenuItem(text: NSLocalizedString("copy", comment: "复制"), imageName: "copy"))
        moreMenuSettings.menuItems.append(MenuItem(text: NSLocalizedString("delete", comment: "删除"), imageName: "delete"))
        ////            textLabel.text = NSLocalizedString("password", comment: "密码")
        ////            imageView.image = #imageLiteral(resourceName: "password")
    }
}
