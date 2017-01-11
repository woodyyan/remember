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
        return "丁丁记事是一个帮助你记住平时容易的忘记的小事的应用，你可以非常快速而简单的记录一切小事，同时很方便的找到它们。"
    }
    
    func getGettingStarted() -> String{
        return "比如：\n爸爸的烟藏在厨房第三个柜子里面\n三脚架在右边床头柜里\n女朋友的生日是2月14日\n妈妈最喜欢吃的菜是土豆丝\n毕业证书在衣柜底部的抽屉里"
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
