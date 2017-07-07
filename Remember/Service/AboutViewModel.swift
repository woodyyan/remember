//
//  AboutViewModel.swift
//  Remember
//
//  Created by Songbai Yan on 10/01/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import Foundation

class AboutViewModel {
    func getAppName() -> String{
        return "丁丁记事"
    }
    
    func getSlogan() -> String{
        return "记住你容易忘记的小事"
    }
    
    func getVersionInfo() -> String{
        return "版本号：V\(getCurrentVersion())"
    }
    
    func getDescription() -> String{
        return Constants.description
    }
    
    func getGettingStarted() -> String{
        return Constants.sampleThing
    }
    
    private func getCurrentVersion(_ bundleVersion:Bool = false) -> String{
        guard let infoDic = Bundle.main.infoDictionary else {return ""}
        guard let currentVersion = infoDic["CFBundleShortVersionString"] as? String else {return ""}
        if let buildVersion = infoDic["CFBundleVersion"] as? String , bundleVersion == true {
            return currentVersion + buildVersion
        }else {
            return currentVersion
        }
    }
}
