//
//  ViewExtension.swift
//  Remember
//
//  Created by Songbai Yan on 2018/4/6.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation

extension UIView {
    var height: CGFloat {
        return self.frame.height
    }
    
    var width: CGFloat {
        return self.frame.width
    }
}

extension UIViewController {
    var height: CGFloat {
        return self.view.frame.height
    }
    
    var width: CGFloat {
        return self.view.frame.width
    }
}
