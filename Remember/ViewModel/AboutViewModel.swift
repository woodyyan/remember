//
//  AboutViewModel.swift
//  Remember
//
//  Created by Songbai Yan on 10/01/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import Foundation

class AboutViewModel: BaseViewModel {
    func getAppName() -> String {
        return NSLocalizedString("appName", comment: "丁丁记事")
    }
    
    func getSlogan() -> String {
        return NSLocalizedString("rememberEveryThing", comment: "")
    }
    
    func getVersionInfo() -> String {
        return "\(NSLocalizedString("version", comment: "版本号"))V\(VersionUtils.getCurrentVersion())"
    }
}
