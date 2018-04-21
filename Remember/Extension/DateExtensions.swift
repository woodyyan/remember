//
//  DateExtensions.swift
//  Remember
//
//  Created by Songbai Yan on 2018/4/21.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation

extension Date {
    func toDateText() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd hh:mm"
        let dateText = NSLocalizedString("createAt", comment: "") + dateFormatter.string(from: self)
        return dateText
    }
}
