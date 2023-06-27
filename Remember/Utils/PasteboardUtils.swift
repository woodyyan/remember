//
//  PasteboardUtils.swift
//  Remember
//
//  Created by Songbai Yan on 03/04/2018.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation
import UIKit

class PasteboardUtils {
    static func getPasteboardContent() -> String? {
        var pasteContent: String?
        let pasteboard = UIPasteboard.general
        pasteContent = pasteboard.string
        
        // 如果存在表示已经提示过，就不再提示
        if checkPasteContentHasShowed(pasteContent) {
            pasteContent = nil
        }
        
        return pasteContent
    }
    
    private static func checkPasteContentHasShowed(_ pasteContent: String?) -> Bool {
        if let content = UserDefaults.standard.string(forKey: "pasteboardContent") {
            if content == pasteContent {
                return true
            }
        }
        return false
    }
}
