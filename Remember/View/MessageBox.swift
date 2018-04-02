//
//  MessageBox.swift
//  Remember
//
//  Created by Songbai Yan on 20/01/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import Foundation
import UIKit

class MessageBox {
    
    class func show(_ message: String) {
        
        let messageString = NSString(string: message)
        let size = messageString.size(withAttributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 13)])
        
        let window = UIApplication.shared.keyWindow
        let showView = UIView()
        showView.backgroundColor = UIColor.black
        showView.alpha = 0.8
        showView.layer.cornerRadius = 8.0
        var rect = CGRect(x: 100, y: 100, width: 100, height: 100)
        if size.width > 100 {
            rect = CGRect(x: 100, y: 100, width: size.width + 20, height: 100)
        }
        showView.frame = rect
        showView.center = window!.center
        window!.addSubview(showView)
        
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: rect.width, height: 100)
        label.text = message
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.backgroundColor = UIColor.clear
        label.font = UIFont.boldSystemFont(ofSize: 13)
        showView.addSubview(label)
        
        // swiftlint:disable multiple_closures_with_trailing_closure
        UIView.animate(withDuration: 1, delay: 1, options: UIViewAnimationOptions.allowAnimatedContent, animations: { () -> Void in
            showView.alpha = 0
        }) { (_) -> Void in
            showView.removeFromSuperview()
        }
    }
}
