//
//  AppDelegate.swift
//  Remember
//
//  Created by Songbai Yan on 14/11/2016.
//  Copyright © 2016 Songbai Yan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window!.rootViewController = UINavigationController.init(rootViewController: HomeViewController())
        
        initAliyunService()
        
        let addIcon = UIApplicationShortcutIcon(type: .add)
        let addText = NSLocalizedString("addThingAction", comment: "添加小事")
        let createItem = UIApplicationShortcutItem(type: "create", localizedTitle: addText, localizedSubtitle: nil, icon: addIcon, userInfo: nil)
        let searchIcon = UIApplicationShortcutIcon(type: .search)
        let searchText = NSLocalizedString("searchThingAction", comment: "搜索小事")
        let searchItem = UIApplicationShortcutItem(type: "search", localizedTitle: searchText, localizedSubtitle: nil, icon: searchIcon, userInfo: nil)
        application.shortcutItems = [createItem, searchItem]
        
        return true
    }
    
    private func initAliyunService() {
        let man = ALBBMANAnalytics.getInstance()
        //man?.turnOnDebug()
        man?.initWithAppKey(GlobleConfigs.aliyunAppKey, secretKey: GlobleConfigs.aliyunAppSecret)
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        self.performActionForShortcutItem(shortcutItem: shortcutItem)
        
        completionHandler(true)
    }
    
    private func performActionForShortcutItem(shortcutItem: UIApplicationShortcutItem) {
        if let controller = self.window!.rootViewController?.childViewControllers.first(where: { (controller) -> Bool in
            return controller is HomeViewController
        }) as? HomeViewController {
            //延迟执行，因为view可能还没有load
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                if controller.isViewLoaded {
                    if shortcutItem.type == "search" { //搜索小事
                        
                        controller.searchClick(UIButton())
                    } else if shortcutItem.type == "create" { //添加小事
                        controller.beginCreateThing()
                    }
                }
            })
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // 粘贴板内容添加提示
        if let pasteContent = PasteboardUtils.getPasteboardContent() {
            let notify = Notification(name: Notification.Name(rawValue: "updatePasteboardView"), object: pasteContent, userInfo: nil)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "updatePasteboardView"), object: notify)
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        CoreStorage.shared.saveContext()
    }
}
