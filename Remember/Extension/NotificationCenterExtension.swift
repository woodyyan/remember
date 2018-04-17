//
//  NotificationCenterExtension.swift
//  Remember
//
//  Created by Songbai Yan on 2018/4/17.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation

extension NotificationCenter {
    public static func addObserver(_ target: Any, _ selector: Selector, _ name: String) {
        let notifcationName = NSNotification.Name(rawValue: name)
        NotificationCenter.addObserver(target, selector, notifcationName)
    }
    
    public static func addObserver(_ target: Any, _ selector: Selector, _ notifcationName: NSNotification.Name) {
        NotificationCenter.default.addObserver(target, selector: selector, name: notifcationName, object: nil)
    }
}
