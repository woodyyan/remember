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
