//
//  AppDelegate.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/4/30.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import MonkeyKing
import SVProgressHUD
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().tintColor = .black
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        let vc = MainTabBarController()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        defaultSetting()
        
        WeixinPay.register()
        
        return true
    }
    
    func defaultSetting(){
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = true

        
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.setMinimumSize(CGSize(width: 100, height: 100))
        
        NetworkReachabilityManager.init()?.startListening()
    }
    
    // iOS 10
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        _ = MonkeyKing.handleOpenURL(url)
        //WXApi.handleOpen(url, delegate: self)
        return true
    }
    // iOS 9
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        _ = MonkeyKing.handleOpenURL(url)
       
        //WXApi.handleOpen(url, delegate: self)
        
        return true
    }
    
    //  微信回调
//    func onResp(_ resp: BaseResp!){
//        //  微信登录回调
//        if resp.errCode == 0 && resp.type == 0{//授权成功
//            if let response = resp as? SendAuthResp{
//                //  微信登录成功通知
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "WXLoginSuccessNotification"), object: response.code)
//            }
//
//            if let response = resp as? PayResp{
//                //  微信登录成功通知
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "com.tongcheng.WXPay"), object: response.returnKey)
//            }
//
//        }
//    }
    
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

