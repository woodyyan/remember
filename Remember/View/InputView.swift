//
//  ChatInputView.swift
//  Remember
//
//  Created by Songbai Yan on 14/11/2016.
//  Copyright © 2016 Songbai Yan. All rights reserved.
//

import Foundation
import UIKit

class InputView : UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        textField.placeholder = "记一点什么吧"
        textField.borderStyle = .roundedRect
        self.addSubview(textField)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
