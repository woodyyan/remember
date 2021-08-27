//
//  UIColorExtensions.swift
//  Remember
//
//  Created by Songbai Yan on 2018/4/17.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    public static var remember: UIColor {
        return UIColor(red: 252, green: 156, blue: 43)!
    }
    
    public static var background: UIColor {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return UIColor.black
            } else {
                return UIColor(red: 238, green: 238, blue: 238)!
            }
        }
    }
    
    public static var grayBackground: UIColor {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return UIColor(red: 28, green: 28, blue: 28)!
            } else {
                return UIColor(red: 238, green: 238, blue: 238)!
            }
        }
    }
    
    public static var moreButtonColor: UIColor {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return UIColor(red: 44, green: 44, blue: 46)!
            } else {
                return UIColor.white
            }
        }
    }
    
    public static var aboutBottomColor: UIColor {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return UIColor(red: 28, green: 28, blue: 28)!
            } else {
                return UIColor(red: 248, green: 248, blue: 248)!
            }
        }
    }
    
    public static var inputGray: UIColor {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return UIColor(red: 28, green: 28, blue: 28)!
            } else {
                return UIColor(red: 216, green: 216, blue: 216)!
            }
        }
    }
    
    public static var whiteBlackColor: UIColor {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return UIColor.black
            } else {
                return UIColor.white
            }
        }
    }
    
    public static var editBackground: UIColor {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return UIColor(red: 28, green: 28, blue: 28)!
            } else {
                return UIColor.white
            }
        }
    }
    
    public static var text: UIColor {
        return UIColor(red: 116, green: 116, blue: 116)!
    }
    
    public static var tag: UIColor {
        return UIColor(red: 252, green: 156, blue: 43)!
    }
    
    public convenience init?(red: Int, green: Int, blue: Int, transparency: CGFloat = 1) {
        guard red >= 0 && red <= 255 else { return nil }
        guard green >= 0 && green <= 255 else { return nil }
        guard blue >= 0 && blue <= 255 else { return nil }
        
        var trans = transparency
        if trans < 0 { trans = 0 }
        if trans > 1 { trans = 1 }
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: trans)
    }
}
