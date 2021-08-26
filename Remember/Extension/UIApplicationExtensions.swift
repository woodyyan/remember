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
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        var statusHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        if let navBarHeight = navigationController?.navigationBar.frame.height {
            statusHeight += navBarHeight
        }
        return statusHeight
    }
}
