//
//  VoiceInputController.swift
//  Remember
//
//  Created by Songbai Yan on 06/03/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import Foundation
import UIKit

class VoiceInputController: UIViewController, UIGestureRecognizerDelegate {
    
    fileprivate let backgroundView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //一个cell的高度
        let height = (self.view.frame.width)/2
        
        backgroundView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        self.view.addSubview(backgroundView)
        backgroundView.frame = CGRect(origin: CGPoint(x: 0.0, y: self.view.frame.height), size: CGSize(width: self.view.frame.width, height: height))
        
        let voiceView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: height))
        voiceView.backgroundColor = UIColor.white
        backgroundView.addSubview(voiceView)
        
        addDismissGesture()
    }
    
    private func addDismissGesture(){
        //Gesture Recognizer for tapping outside the menu
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(VoiceInputController.dismissController))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func dismissController() {
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 100.0,
                       initialSpringVelocity: 0.6,
                       options: [.beginFromCurrentState, .allowUserInteraction, .overrideInheritedOptions, .curveEaseOut],
                       animations: {
                        self.view.backgroundColor = UIColor.clear
                        self.backgroundView.frame = CGRect(origin: CGPoint(x: 0.0, y: self.view.frame.height), size: self.backgroundView.frame.size)
        },
                       completion: {(finished) in
                        self.dismiss(animated: true, completion: {() -> Void in
                            
                        })
        })
    }
    
    //展示此controller
    func show() {
        self.view.backgroundColor = UIColor.clear
        UIView.animate(withDuration: 0.8 * 0.4,
                       delay: 0.0,
                       options: UIViewAnimationOptions.curveEaseOut,
                       animations: {
                        self.view.backgroundColor = UIColor(red: 41/255, green: 41/255, blue: 41/255, alpha: 0.8)
        },
                       completion: nil
        )
        
        backgroundView.frame = CGRect(origin: CGPoint(x: 0.0, y: self.view.frame.height), size: backgroundView.frame.size)
        UIView.animate(withDuration: 0.8,
                       delay: 0.0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.6,
                       options: [.beginFromCurrentState, .allowUserInteraction, .overrideInheritedOptions],
                       animations: {
                        self.backgroundView.frame = CGRect(origin: CGPoint(x: 0.0, y: self.view.frame.height-self.backgroundView.frame.height), size: self.backgroundView.frame.size)
                        self.backgroundView.layoutIfNeeded()
        },
                       completion: nil)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view != gestureRecognizer.view {
            return false
        }
        return true
    }
}
