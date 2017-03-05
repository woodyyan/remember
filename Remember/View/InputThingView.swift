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
        
        self.backgroundColor = UIColor.background()
        
        textField = InputTextField(frame: CGRect(x: 10, y: 10, width: frame.width - 20, height: frame.height - 20))
        textField.delegate = self
        self.addSubview(textField)
        
        let micButton = UIButton.init(type: UIButtonType.custom)
        micButton.setImage(UIImage(named: "Microphone"), for: .normal)
        micButton.addTarget(self, action: #selector(InputThingView.micButtonTapped(sender:)), for: UIControlEvents.touchUpInside)
        micButton.sizeToFit()
        micButton.frame = CGRect(x: self.frame.width - self.frame.height + 15, y: 0, width: micButton.frame.width, height: micButton.frame.height)
        micButton.center.y = self.frame.height/2
        self.addSubview(micButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func micButtonTapped(sender:UIButton){
        print("agag")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let content = textField.text{
            if !content.isEmpty{
                let thing = ThingEntity(content: content, createdAt: NSDate(), index: 0)
                ThingRepository.sharedInstance.createThing(thing: thing)
                
                delegate?.input(inputView: self, thing: thing)
            }
        }
        
        endEditing()
        textField.text = ""
        
        return true
    }
    
    func endEditing() {
        self.textField.resignFirstResponder()
    }
}

protocol ThingInputDelegate : NSObjectProtocol{
    func input(inputView:InputThingView, thing:ThingEntity)
}
