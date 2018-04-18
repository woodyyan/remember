//
//  PasteboardView.swift
//  Remember
//
//  Created by Songbai Yan on 2018/4/18.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation
import UIKit

class PasteboardView: UIView {
    
    let pasteContentLabel = UILabel()
    let okButton = UIButton(type: UIButtonType.custom)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor.white
        
        let tipTextLabel = UILabel(frame: CGRect(x: 10, y: 5, width: self.width, height: 20))
        tipTextLabel.textColor = UIColor.remember
        tipTextLabel.text = NSLocalizedString("addPasteboardContent", comment: "")
        tipTextLabel.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(tipTextLabel)
        tipTextLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(10)
            maker.top.equalTo(self).offset(5)
            maker.right.equalTo(self).offset(-10)
        }
        
        okButton.setImage(UIImage(named: "Checked"), for: .normal)
        okButton.sizeToFit()
        self.addSubview(okButton)
        okButton.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(self)
            maker.right.equalTo(self.snp.right).offset(-10)
        }
        
        pasteContentLabel.textColor = UIColor.text
        self.addSubview(pasteContentLabel)
        pasteContentLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(tipTextLabel.snp.bottom).offset(5)
            maker.left.equalTo(tipTextLabel)
            maker.right.lessThanOrEqualTo(okButton.snp.left).offset(-5)
            maker.height.equalTo(20)
        }
    }
}
