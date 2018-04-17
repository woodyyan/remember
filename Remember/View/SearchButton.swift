//
//  SearchButton.swift
//  Remember
//
//  Created by Songbai Yan on 2018/4/17.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation

class SearchButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        self.setTitle(NSLocalizedString("searchPlaceHolder", comment: "搜索"), for: UIControlState.normal)
        self.setImage(UIImage(named: "Search"), for: UIControlState.normal)
        self.layer.borderColor = UIColor.inputGray.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 20
        self.backgroundColor = UIColor.inputGray
        self.setTitleColor(UIColor.remember, for: UIControlState.normal)
        self.tintColor = UIColor.remember
    }
}
