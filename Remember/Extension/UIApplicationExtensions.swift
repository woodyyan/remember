//
//  UIApplicationExtensions.swift
//  Remember
//
//  Created by Songbai Yan on 2018/4/18.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    static func barHeight(_ navigationController: UINavigationController?) -> CGFloat {
        let window = UIApplication.shared.keyWindow
        var statusHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        if let navBarHeight = navigationController?.navigationBar.frame.height {
            statusHeight += navBarHeight
        }
        return statusHeight
    }
    
    var keyWindow: UIWindow? {
        // Get connected scenes
        connectedScenes
            // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
            // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
            // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows
            // Finally, keep only the key window
            .first(where: \.isKeyWindow)
    }
}

