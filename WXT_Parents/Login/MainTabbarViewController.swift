//
//  MainTabbarViewController.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/1/9.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class MainTabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let vc : BlogMainTableTableViewController = mainStoryboard.instantiateViewControllerWithIdentifier("BlogView") as! BlogMainTableTableViewController
        vc.navigationController?.tabBarItem.badgeValue = "3"
    }

}
