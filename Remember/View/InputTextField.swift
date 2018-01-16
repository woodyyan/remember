//
//  InputTextField.swift
//  Remember
//
//  Created by Songbai Yan on 17/01/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import Foundation
import UIKit

class InputTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let leftImage = UIImageView(image: UIImage(named: "PlusMath"))
        self.leftView = leftImage
        self.leftViewMode = .always
        self.attributedPlaceholder = NSAttributedString(string: " 记一点什么吧", attributes: [NSAttributedStringKey.foregroundColor:UIColor.remember()])
        self.contentMode = .center
        self.backgroundColor = UIColor.inputGray()
        self.layer.borderColor = UIColor.inputGray().cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 20
        self.clearButtonMode = .whileEditing
        self.returnKeyType = .done
    }
    
    func setLeftImage(with image:UIImage){
        self.leftView = UIImageView(image: image)
    }
    
    func setPlaceHolder(with text:String){
        self.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedStringKey.foregroundColor:UIColor.remember()])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += 10
        rect.origin.y -= 2
        return rect
    }
}
