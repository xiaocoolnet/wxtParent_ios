//
//  MainTabbarViewController.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/1/9.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class MainTabbarViewController: UITabBarController, IChatManagerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let vc : BlogMainTableTableViewController = mainStoryboard.instantiateViewControllerWithIdentifier("BlogView") as! BlogMainTableTableViewController
        vc.navigationController?.tabBarItem.badgeValue = "3"
        EaseMob.sharedInstance().chatManager.removeDelegate(self)
        EaseMob.sharedInstance().chatManager.addDelegate(self, delegateQueue: nil)
        
    }
    
//    func didLoginFromOtherDevice() {
//        let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("您的账号在其他设备登陆！！", comment: "empty message"), preferredStyle: .Alert)
//        
//        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
//        let doneAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
//            //          清除登录信息
//            let useDefaults = NSUserDefaults.standardUserDefaults()
//            useDefaults.removeObjectForKey("userid")
//            useDefaults.removeObjectForKey("name")
//            useDefaults.removeObjectForKey("password")
//            useDefaults.removeObjectForKey("schoolid")
//            useDefaults.removeObjectForKey("classid")
//            useDefaults.removeObjectForKey("chid")
//            useDefaults.removeObjectForKey("chidname")
//            useDefaults.synchronize()
//            //            退出环信
//            EaseMob.sharedInstance().chatManager.asyncLogoffWithUnbindDeviceToken(false)
//            
//            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
//            let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("FirstView")
//            //            let vc = LoginViewController()
//            self.navigationController?.pushViewController(vc, animated: true)
//            
//        }
//        alertController.addAction(doneAction)
//        alertController.addAction(cancelAction)
//        self.presentViewController(alertController, animated: true, completion: nil)
//        
//    }
    
    
//

}
