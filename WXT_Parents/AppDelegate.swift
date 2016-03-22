//
//  AppDelegate.swift
//  WXT_Parents
//
//  Created by 李春波 on 15/12/28.
//  Copyright © 2015年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UITabBarControllerDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        NSThread.sleepForTimeInterval(2.0)
        UITabBar.appearance().tintColor = UIColor(red: 54.0 / 255.0, green: 190.0 / 255.0, blue: 100.0 / 255.0, alpha: 1.0)

        
        let infoDictionary = NSBundle.mainBundle().infoDictionary
        let currentAppVersion = infoDictionary!["CFBundleShortVersionString"] as! String
        
        // 取出之前保存的版本号
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let appVersion = userDefaults.stringForKey("appVersion")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
//         如果 appVersion 为 nil 说明是第一次启动；如果 appVersion 不等于 currentAppVersion 说明是更新了
        if appVersion == nil || appVersion != currentAppVersion {
            // 保存最新的版本号
            userDefaults.setValue(currentAppVersion, forKey: "appVersion")
            
            let guideViewController = storyboard.instantiateViewControllerWithIdentifier("ScollViewController") as! ScollViewController
            self.window?.rootViewController = guideViewController
        }

        
        else{
//            检测登录
            if self.loginCheck() {
                //        环信登录
                let easeMob:EaseMob = EaseMob()
                easeMob.registerSDKWithAppKey("xiaocool#zhixiaoyuan", apnsCertName: "wxtpush_dev")
                easeMob.application(application, didFinishLaunchingWithOptions: launchOptions)
                //        账号
                let userid = NSUserDefaults.standardUserDefaults()
                //        接口调用注册
                easeMob.chatManager.asyncRegisterNewAccount(userid.valueForKey("userid")! as! String, password:userid.valueForKey("userid")! as! String)
                //        //        设置自动登录
                easeMob.chatManager.asyncLoginWithUsername(userid.valueForKey("userid")! as! String, password: userid.valueForKey("userid")! as! String)
                //        检测是否设置了自动登录
                        let isAutoLogin:Bool = easeMob.chatManager.isAutoLoginEnabled!
                        if(!isAutoLogin){
                            easeMob.chatManager.asyncLoginWithUsername(userid.valueForKey("userid")! as! String,password:userid.valueForKey("userid")! as! String)
                        }
//                        182.92.20.117
                easeMob.registerSDKWithAppKey("xiaocool#zhixiaoyuan", apnsCertName: "wxtpush_dev")
                //iOS8 注册APNS
                if(application.respondsToSelector(#selector(UIApplication.registerForRemoteNotifications))){
                    application.registerForRemoteNotifications()
                    let notificationTypes:UIUserNotificationType = UIUserNotificationType(arrayLiteral: .Alert,.Badge,.Sound)
                    let settings:UIUserNotificationSettings = UIUserNotificationSettings.init(forTypes: notificationTypes, categories: nil)
                    application.registerUserNotificationSettings(settings)
                }else{
                    let notificationTypes:UIRemoteNotificationType = UIRemoteNotificationType(arrayLiteral: .Alert,.Badge,.Sound)
                    application.registerForRemoteNotificationTypes(notificationTypes)
                }
            }
        }
        
        return true
    }
//    检测登录
    func loginCheck()->Bool{
        let userid = NSUserDefaults.standardUserDefaults()
        var segueId = "MainView"
        if((userid.valueForKey("userid") == nil) || (userid.valueForKey("userid")?.length == 0 ))
        {
            
            segueId = "LoginView"
            self.window?.rootViewController = self.window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier(segueId)
            return false
        }
        else{//登录成功时
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tableBarController = storyboard.instantiateViewControllerWithIdentifier(segueId) as! UITabBarController
            let tableBarItem = tableBarController.tabBar.items![2]
            tableBarItem.badgeValue = "3"
            self.window?.rootViewController = tableBarController
            return true
        }
    }
    
    
     func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        EaseMob.sharedInstance().applicationDidEnterBackground(application)
    }
// App进入后台
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
// App将要从后台返回
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        EaseMob.sharedInstance().applicationWillEnterForeground(application)
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
// 申请处理时间
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        EaseMob.sharedInstance().applicationWillTerminate(application)
    }
    // 将得到的deviceToken传给SDK
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        EaseMob.sharedInstance().application(application,didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    // 注册deviceToken失败'
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        EaseMob.sharedInstance().application(application,didFailToRegisterForRemoteNotificationsWithError: error)
        print("error-----%@",error)
    }

}

