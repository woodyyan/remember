//
//  ChatInputView.swift
//  Remember
//
//  Created by Songbai Yan on 14/11/2016.
//  Copyright © 2016 Songbai Yan. All rights reserved.
//

import Foundation
import UIKit

class InputThingView: UIView, UITextFieldDelegate {
    private var textField: UITextField!
    private var micButton: UIButton!
    
    private let viewModel = InputThingViewModel(thingStorage: ThingStorage(context: CoreStorage.shared.persistentContainer.viewContext))
    
    weak var delegate: ThingInputDelegate?
    
    var voiceInputAction: ((InputThingView) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.background
        
        textField = InputTextField(frame: CGRect(x: 10, y: 10, width: frame.width - 20, height: frame.height - 20))
        textField.delegate = self
        self.addSubview(textField)
        
        micButton = UIButton.init(type: UIButton.ButtonType.custom)
        micButton.setImage(UIImage(named: "Microphone"), for: .normal)
        micButton.addTarget(self, action: #selector(InputThingView.micButtonTapped(sender:)), for: UIControl.Event.touchUpInside)
        micButton.sizeToFit()
        micButton.frame = CGRect(x: self.frame.width - self.frame.height + 15, y: 0, width: micButton.frame.width, height: micButton.frame.height)
        micButton.center.y = self.frame.height/2
        self.addSubview(micButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func isEditing() -> Bool {
        return textField.isEditing
    }
    
    @objc func micButtonTapped(sender: UIButton) {
        self.voiceInputAction?(self)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        micButton.isHidden = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        micButton.isHidden = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let content = textField.text {
            if !content.isEmpty {
                let thing = self.viewModel.createThing(with: content)
                delegate?.input(inputView: self, thing: thing)
            }
        }
        
        endEditing()
        textField.text = ""
        
        return true
    }
    
    func beginEditing() {
        self.textField.becomeFirstResponder()
    }
    
    func endEditing() {
        self.textField.resignFirstResponder()
    }
}

protocol ThingInputDelegate: NSObjectProtocol {
    func input(inputView: InputThingView, thing: ThingModel)
}
