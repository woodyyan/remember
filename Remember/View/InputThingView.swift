//
//  ChatInputView.swift
//  Remember
//
//  Created by Songbai Yan on 14/11/2016.
//  Copyright © 2016 Songbai Yan. All rights reserved.
//

import Foundation
import UIKit

class InputThingView : UIView, UITextFieldDelegate{
    
    private var textField:UITextField!
    
    var delegate:ThingInputDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textField = InputTextField(frame: CGRect(x: 10, y: 10, width: frame.width - 20, height: frame.height - 20))
        let leftImage = UIImageView(image: UIImage(named: "PlusMath"))
        textField.leftView = leftImage
        textField.leftViewMode = .always
        textField.attributedPlaceholder = NSAttributedString(string: " 记一点什么吧", attributes: [NSForegroundColorAttributeName:UIColor.remember()])
        textField.backgroundColor = UIColor.inputGray()
        textField.layer.borderColor = UIColor.inputGray().cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 20
        
        textField.delegate = self
        textField.returnKeyType = .done
        self.addSubview(textField)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let content = textField.text{
            if !content.isEmpty{
                let thing = ThingEntity(content: content, createdAt: NSDate())
                ThingRepository.sharedInstance.createThing(thing: thing)
                
                delegate?.input(inputView: self, thing: thing)
            }
        }
        
        textField.resignFirstResponder()
        textField.text = ""
        
        return true
    }
}

protocol ThingInputDelegate : NSObjectProtocol{
    func input(inputView:InputThingView, thing:ThingEntity)
}
