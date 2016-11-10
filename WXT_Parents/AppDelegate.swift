//
//  AppDelegate.swift
//  WXT_Parents
//
//  Created by 李春波 on 15/12/28.
//  Copyright © 2015年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UITabBarControllerDelegate,IChatManagerDelegate {

    var window: UIWindow?
    var delegat : IChatManagerDelegate?
    let arr = NSMutableArray()
    let trustArr = NSMutableArray()
    let noticeArr = NSMutableArray()
    let deliArr = NSMutableArray()
    let homeworkArr = NSMutableArray()
    let leaveArr = NSMutableArray()
    let activityArr = NSMutableArray()
    let commentArr = NSMutableArray()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
   
        //通知类型（这里将声音、消息、提醒角标都给加上）
        let userSettings = UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert],
                                                      categories: nil)
        if ((UIDevice.currentDevice().systemVersion as NSString).floatValue >= 8.0) {
            //可以添加自定义categories
            JPUSHService.registerForRemoteNotificationTypes(userSettings.types.rawValue,
                                                            categories: nil)
        }
        else {
            //categories 必须为nil
            JPUSHService.registerForRemoteNotificationTypes(userSettings.types.rawValue,
                                                            categories: nil)
        }
        
        // 启动JPushSDK
        JPUSHService.setupWithOption(nil, appKey: "c473f4766b25282bd4d2c34a",
                                     channel: "Publish Channel", apsForProduction: true)
        
        let defau = NSNotificationCenter.defaultCenter()
        
        defau.addObserver(self, selector: #selector(network(_:)), name: kJPFNetworkDidLoginNotification, object: nil)
        
        if let launchOpts = launchOptions {
        
            let notification = launchOpts[UIApplicationLaunchOptionsRemoteNotificationKey] as? [NSObject : AnyObject]
            print("#$%^&*(*&^%$#")
            print(notification)
        }
        
        //  微信分享功能 (第一个参数不知道是什么意思)
        ShareSDK.registerApp("142e4be9863ec", activePlatforms: [SSDKPlatformType.TypeWechat.rawValue], onImport: {(platform : SSDKPlatformType) -> Void in
            
            switch platform{
                //  第三个参数为需要连接社交平台SDK时触发，在此事件中写入连接代码
                
            case SSDKPlatformType.TypeWechat:
                ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                
            default:
                break
            }
            }, onConfiguration: {(platform : SSDKPlatformType,appInfo : NSMutableDictionary!) -> Void in
                switch platform {
                    
                
                 
                    
                case SSDKPlatformType.TypeWechat:
                    //设置微信应用信息
                    appInfo.SSDKSetupWeChatByAppId("wx098ea71735ed0a41", appSecret: "b1e66b976880d7cd3c02a2d91e8b08f0")
                    break
                    
               
                
                default:
                    break
                    
                }
        })
        
        NSThread.sleepForTimeInterval(2.0)
        UITabBar.appearance().tintColor = UIColor(red: 54.0 / 255.0, green: 190.0 / 255.0, blue: 100.0 / 255.0, alpha: 1.0)
        //        把返回按钮的back移走
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), forBarMetrics: UIBarMetrics.Default)
        
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
                print("*****************************")
                let defalutid = NSUserDefaults.standardUserDefaults()
                let studentid = defalutid.stringForKey("chid")
                JPUSHService.setTags(nil, aliasInbackground: studentid)
                //        环信登录
                let easeMob:EaseMob = EaseMob()
                easeMob.registerSDKWithAppKey("xiaocool#zhixiaoyuan", apnsCertName: "wxtpush_dev")
                
                EaseMob.sharedInstance().chatManager.removeDelegate(self)
                EaseMob.sharedInstance().chatManager.addDelegate(self, delegateQueue: nil)
                
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
    
    
    func networkDidLogin(){
        print("++++++++++++++++++++++++++++++++")
        let defalutid = NSUserDefaults.standardUserDefaults()
        let studentid = defalutid.stringForKey("chid")
        JPUSHService.setTags(nil, aliasInbackground: studentid)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kJPFNetworkDidLoginNotification, object: nil)
        print(studentid)
        print(callBack)
    }
    
    
    func didLoginFromOtherDevice() {
        let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("您的账号在其他设备登陆！！", comment: "empty message"), preferredStyle: .Alert)
        
//        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        let doneAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            //          清除登录信息
            let useDefaults = NSUserDefaults.standardUserDefaults()
            useDefaults.removeObjectForKey("userid")
            useDefaults.removeObjectForKey("name")
            useDefaults.removeObjectForKey("password")
            useDefaults.removeObjectForKey("schoolid")
            useDefaults.removeObjectForKey("classid")
            useDefaults.removeObjectForKey("chid")
            useDefaults.removeObjectForKey("chidname")
            useDefaults.removeObjectForKey("school_name")
            useDefaults.synchronize()
            //            退出环信
            EaseMob.sharedInstance().chatManager.asyncLogoffWithUnbindDeviceToken(false)
            
            self.window?.rootViewController = self.window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("FirstView")
            
        }
        alertController.addAction(doneAction)
//        alertController.addAction(cancelAction)
        self.window?.rootViewController!.presentViewController(alertController, animated: true, completion: nil)
        
        
    }

    
        
//    检测登录
    func loginCheck()->Bool{
        let userid = NSUserDefaults.standardUserDefaults()
        var segueId = "MainView"
        if((userid.valueForKey("userid") == nil) || (userid.valueForKey("userid")?.length == 0 ))
        {
            let defau = NSNotificationCenter.defaultCenter()
            
            defau.addObserver(self, selector: #selector(self.networkDidLogin), name: kJPFNetworkDidLoginNotification, object: nil)
            segueId = "LoginView"
            self.window?.rootViewController = self.window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier(segueId)
            return false
        }
        else{//登录成功时
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tableBarController = storyboard.instantiateViewControllerWithIdentifier(segueId) as! UITabBarController
//            let tableBarItem = tableBarController.tabBar.items![2]
//            tableBarItem.badgeValue = "3"
            let defau = NSNotificationCenter.defaultCenter()
            
            defau.addObserver(self, selector: #selector(self.networkDidLogin), name: kJPFNetworkDidLoginNotification, object: nil)
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
        
        application.applicationIconBadgeNumber = 0
        application.cancelAllLocalNotifications()
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
        /// Required - 注册 DeviceToken
        JPUSHService.registerDeviceToken(deviceToken)
    
        EaseMob.sharedInstance().application(application,didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
        
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        JPUSHService.handleRemoteNotification(userInfo)
         goToMssageViewControllerWith(userInfo)
        print("啦啦啦啦啦啦")
        print(userInfo)
    }
    
    // 注册deviceToken失败'
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        EaseMob.sharedInstance().application(application,didFailToRegisterForRemoteNotificationsWithError: error)
        print("error-----%@",error)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
//         NSNotificationCenter.defaultCenter().postNotificationName(JuPushNotificationName, object: nil, userInfo: userInfo) 
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(UIBackgroundFetchResult.NewData);
        print("hahahahahahahah")
        print(userInfo)
        

        
        if application.applicationState == .Active {
            print("shiyongzhong")
//            goToMssageViewController(userInfo)
        }else if application.applicationState == .Inactive{
            goToMssageViewControllerWith(userInfo)
//            goToMssageViewController(userInfo)
        }else if application.applicationState == .Background{
            goToMssageViewControllerWith(userInfo)
//            goToMssageViewController(userInfo)
        }
        goToMssageViewController(userInfo)
        
    }
    
    func goToMssageViewController(userInfo:NSDictionary){
        let type = userInfo["type"] as? String
        if type == "message"{
            let userDefaults = NSUserDefaults.standardUserDefaults()
            if userDefaults.valueForKey("count") != nil {
                let str = userDefaults.valueForKey("count") as! NSArray
                if str.count == 0 {
                    arr.removeAllObjects()
                }
            }else{
                arr.removeAllObjects()
            }
            arr.addObject(userInfo)
            userDefaults.setValue(arr, forKey: "count")
            let str = userDefaults.valueForKey("count")
            print((str as! NSArray).count)
            NSNotificationCenter.defaultCenter().postNotificationName("count", object: str)
            
        }else if type == "trust"{
            let userDefaults = NSUserDefaults.standardUserDefaults()
            if userDefaults.valueForKey("trustArr") != nil {
                let str = userDefaults.valueForKey("trustArr") as! NSArray
                if str.count == 0 {
                    trustArr.removeAllObjects()
                }
            }else{
                trustArr.removeAllObjects()
            }
            trustArr.addObject(userInfo)
            userDefaults.setValue(trustArr, forKey: "trustArr")
            let str = userDefaults.valueForKey("trustArr")
            NSNotificationCenter.defaultCenter().postNotificationName("trustArr", object: str)
        }else if type == "notice"{
            let userDefaults = NSUserDefaults.standardUserDefaults()
            if userDefaults.valueForKey("noticeArr") != nil {
                let str = userDefaults.valueForKey("noticeArr") as! NSArray
                if str.count == 0 {
                    noticeArr.removeAllObjects()
                }
            }else{
                noticeArr.removeAllObjects()
            }
            noticeArr.addObject(userInfo)
            userDefaults.setValue(noticeArr, forKey: "noticeArr")
            let str = userDefaults.valueForKey("noticeArr")
            NSNotificationCenter.defaultCenter().postNotificationName("noticeArr", object: str)
        }else if type == "delivery"{
            let userDefaults = NSUserDefaults.standardUserDefaults()
            if userDefaults.valueForKey("deliArr") != nil {
                let str = userDefaults.valueForKey("deliArr") as! NSArray
                if str.count == 0 {
                    deliArr.removeAllObjects()
                }
            }else{
                deliArr.removeAllObjects()
            }
            deliArr.addObject(userInfo)
            userDefaults.setValue(deliArr, forKey: "deliArr")
            let str = userDefaults.valueForKey("deliArr")
            NSNotificationCenter.defaultCenter().postNotificationName("deliArr", object: str)
        }else if type == "homework"{
            let userDefaults = NSUserDefaults.standardUserDefaults()
            if userDefaults.valueForKey("homeworkArr") != nil {
                let str = userDefaults.valueForKey("homeworkArr") as! NSArray
                if str.count == 0 {
                    homeworkArr.removeAllObjects()
                }
            }else{
                homeworkArr.removeAllObjects()
            }
            homeworkArr.addObject(userInfo)
            userDefaults.setValue(homeworkArr, forKey: "homeworkArr")
            let str = userDefaults.valueForKey("homeworkArr")
            NSNotificationCenter.defaultCenter().postNotificationName("homeworkArr", object: str)
        }else if type == "leave"{
            let userDefaults = NSUserDefaults.standardUserDefaults()
            if userDefaults.valueForKey("leaveArr") != nil {
                let str = userDefaults.valueForKey("leaveArr") as! NSArray
                if str.count == 0 {
                    leaveArr.removeAllObjects()
                }
            }else{
                leaveArr.removeAllObjects()
            }
            leaveArr.addObject(userInfo)
            userDefaults.setValue(leaveArr, forKey: "leaveArr")
            let str = userDefaults.valueForKey("leaveArr")
            NSNotificationCenter.defaultCenter().postNotificationName("leaveArr", object: str)
        }else if type == "activity"{
            let userDefaults = NSUserDefaults.standardUserDefaults()
            if userDefaults.valueForKey("activityArr") != nil {
                let str = userDefaults.valueForKey("activityArr") as! NSArray
                if str.count == 0 {
                    activityArr.removeAllObjects()
                }
            }else{
                activityArr.removeAllObjects()
            }
            activityArr.addObject(userInfo)
            userDefaults.setValue(activityArr, forKey: "activityArr")
            let str = userDefaults.valueForKey("activityArr")
            NSNotificationCenter.defaultCenter().postNotificationName("activityArr", object: str)
        }else if type == "comment"{
            let userDefaults = NSUserDefaults.standardUserDefaults()
            if userDefaults.valueForKey("commentArr") != nil {
                let str = userDefaults.valueForKey("commentArr") as! NSArray
                if str.count == 0 {
                    commentArr.removeAllObjects()
                }
            }else{
                commentArr.removeAllObjects()
            }
            activityArr.addObject(userInfo)
            userDefaults.setValue(commentArr, forKey: "commentArr")
            let str = userDefaults.valueForKey("commentArr")
            NSNotificationCenter.defaultCenter().postNotificationName("commentArr", object: str)
        }else if type == "newMessage"{
            NSNotificationCenter.defaultCenter().postNotificationName("message", object: "message")
        }
            
    }
    
    func goToMssageViewControllerWith(userInfo:NSDictionary){
        let type = userInfo["type"] as? String
        NSNotificationCenter.defaultCenter().postNotificationName("push", object: type)
        
    }
    
    func network(not:NSNotification){
        if (JPUSHService.registrationID() != nil) {
            print(JPUSHService.registrationID())
            let userid = NSUserDefaults.standardUserDefaults()
            userid.setValue(JPUSHService.registrationID(), forKey: "deviceToken")
        }
        
    }
    
    
    
}

