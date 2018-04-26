//
//  VersionUtils.swift
//  Remember
//
//  Created by Songbai Yan on 2018/4/21.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation

class VersionUtils {
    static func getCurrentVersion() -> String {
        guard let infoDic = Bundle.main.infoDictionary else {return ""}
        guard let currentVersion = infoDic["CFBundleShortVersionString"] as? String else {return ""}
//        let buildVersion = infoDic["CFBundleVersion"] as? String
        return currentVersion
    }
}
