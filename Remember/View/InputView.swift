//
//  ChatInputView.swift
//  Remember
//
//  Created by Songbai Yan on 14/11/2016.
//  Copyright © 2016 Songbai Yan. All rights reserved.
//

import Foundation
import UIKit

class InputView : UIView, UITextFieldDelegate{
    
    private var textField:UITextField!
    
    var delegate:ThingInputDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
        textField = UITextField(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        textField.placeholder = "记一点什么吧"
        textField.delegate = self
        textField.borderStyle = .roundedRect
        textField.returnKeyType = .done
        self.addSubview(textField)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let content = textField.text{
            let thing = ThingEntity(content: content, createdAt: NSDate())
            ThingRepository.sharedInstance.createThing(thing: thing)
            
            textField.resignFirstResponder()
            textField.text = ""
            
            delegate?.input(inputView: self, thing: thing)
            
            return true
        }
        return false
    }
}

protocol ThingInputDelegate : NSObjectProtocol{
    func input(inputView:InputView, thing:ThingEntity)
}
