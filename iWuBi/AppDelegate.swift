//
//  AppDelegate.swift
//  iWuBi
//
//  Created by HTC on 2019/4/7.
//  Copyright © 2019 HTC. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        startBaiduMobStat()
        
        setupBaseUI()
        
        ITCommonAPI.shared.checkAppUpdate(newHandler: nil)
        
        return true
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        if shortcutItem.type.contains("iWuBi://search") {
            let vc = IHTCSearchViewController()
            vc.is86Word = true
            let navi = UINavigationController.init(rootViewController: vc)
            navi.navigationBar.isHidden = true
            UIApplication.shared.keyWindow?.rootViewController!.present(navi, animated: true, completion: nil)
        }
        
        if shortcutItem.type.contains("iWuBi://star") {
            IAppleServiceUtil.inAppRating(url: kAppDownloadURl)
        }
        
        if shortcutItem.type.contains("iWuBi://love") {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                IAppleServiceUtil.openAppstore(url: kAppDownloadURl, isAssessment: false)
            })
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}

// MARK: Prive method
extension AppDelegate {
    
    func startBaiduMobStat() {
        #if !targetEnvironment(macCatalyst)
        let statTracker = BaiduMobStat.default()
#if DEBUG
        print("Debug modle")
        //statTracker.enableDebugOn = true;
        statTracker.channelId = "Debug"
#else
        statTracker.shortAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String 
        statTracker.channelId = "AppStore"
        statTracker.start(withAppId: "16b4ffd70b")
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDate = formatter.string(from: Date())
        
        // 自定义事件
        statTracker.logEvent("usermodelName", eventLabel: UIDevice.init().modelName)
        statTracker.logEvent("systemVersion", eventLabel: UIDevice.current.systemVersion)
        statTracker.logEvent("DateSystemVersion", eventLabel: currentDate + " " + UIDevice.current.systemVersion)
        statTracker.logEvent("DateAndDeviceName", eventLabel: currentDate + " " + UIDevice.current.name)
        statTracker.logEvent("Devices", eventLabel:UIDevice.current.name)
        statTracker.logEvent("AppName", eventLabel:( Bundle.main.infoDictionary?["CFBundleName"] as! String))
#endif
        #endif
    }
    
    func setupBaseUI() {
        let ui = UINavigationBar.appearance()
        ui.tintColor = .white
        ui.barTintColor = UIColor(red:0.979, green:0.322, blue:0.000, alpha:1.000)
        ui.barStyle = .black
        //        UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
        //        UIApplication.shared.setStatusBarHidden(false, with: .none)
    }
    
}



