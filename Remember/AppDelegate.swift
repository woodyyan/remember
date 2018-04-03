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
        man?.initWithAppKey(GlobleParameters.aliyunAppKey, secretKey: GlobleParameters.aliyunAppSecret)
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

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state.
        // This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message)
        // or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks.
        // Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state;
        // here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // 粘贴板内容添加提示
        if let pasteContent = PasteboardUtils.getPasteboardContent() {
            let notify = Notification(name: Notification.Name(rawValue: "updatePasteboardView"), object: pasteContent, userInfo: nil)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "updatePasteboardView"), object: notify)
        }

        // Restart any tasks that were paused (or not yet started) while the application was inactive.
        // If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        StorageService.shared.saveContext()
    }
}
