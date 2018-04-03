//
//  File.swift
//  Remember
//
//  Created by Songbai Yan on 21/12/2016.
//  Copyright © 2016 Songbai Yan. All rights reserved.
//

import Foundation
import UIKit

class HomeService {
    
    class func getActivityViewController(content: String) -> UIActivityViewController {
        let activityController = UIActivityViewController(activityItems: [content], applicationActivities: [])
        activityController.excludedActivityTypes = [.openInIBooks, .addToReadingList, .saveToCameraRoll]
        activityController.completionWithItemsHandler = {
            (type, flag, array, error) -> Swift.Void in
            print(type ?? "")
        }
        return activityController
    }
}

extension UIColor {
    class func remember() -> UIColor {
        return UIColor(red: 252/255, green: 156/255, blue: 43/255, alpha: 1)
    }
    
    class func background() -> UIColor {
        return UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
    }
    
    class func inputGray() -> UIColor {
        return UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
    }
    
    class func text() -> UIColor {
        return UIColor(red: 116/255, green: 116/255, blue: 116/255, alpha: 1)
    }
}
