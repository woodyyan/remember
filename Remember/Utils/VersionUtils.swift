//
//  VersionUtils.swift
//  Remember
//
//  Created by Songbai Yan on 2018/4/21.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation

class VersionUtils {
    static func getCurrentVersion(_ bundleVersion: Bool = false) -> String {
        guard let infoDic = Bundle.main.infoDictionary else {return ""}
        guard let currentVersion = infoDic["CFBundleShortVersionString"] as? String else {return ""}
        if let buildVersion = infoDic["CFBundleVersion"] as? String, bundleVersion == true {
            return currentVersion + buildVersion
        } else {
            return currentVersion
        }
    }
}
