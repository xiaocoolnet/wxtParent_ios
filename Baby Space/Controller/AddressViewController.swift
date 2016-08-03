//
//  AddressViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/5/12.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import PagingMenuController


class AddressViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()

        view.backgroundColor = UIColor.whiteColor()
        //  是否显示视图控制器
        self.tabBarController?.tabBar.hidden = true
        
        let viewController = AddressBookTableViewController()
        viewController.title = "老师"
        
        let viewController2 = FriendsViewController()
        viewController2.title = "好友"
        
        let viewControllers = [viewController, viewController2]
        
        let options = PagingMenuOptions()
        options.menuItemMargin = 5
        options.menuHeight = 40
        options.menuDisplayMode = .SegmentedControl
        options.menuItemMode = .Underline(height: 5, color: RGBA(138.0, g: 227.0, b: 163.0, a: 1.0), horizontalPadding: 0, verticalPadding: 0)
        options.selectedTextColor = RGBA(138.0, g: 227.0, b: 163.0, a: 1.0)
        let pagingMenuController = PagingMenuController(viewControllers: viewControllers, options: options)
        pagingMenuController.view.frame.origin.y += 0
        pagingMenuController.view.frame.size.height -= 0
        
        addChildViewController(pagingMenuController)
        view.addSubview(pagingMenuController.view)
        pagingMenuController.didMoveToParentViewController(self)
    }
    func initUI(){
        
        //  添加一个右按钮
        let sureButton = UIButton()
        sureButton.frame = CGRectMake(0,  0,  40, 20)
        sureButton.setTitle("➕", forState: .Normal)
        sureButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        sureButton.addTarget(self, action: #selector(RefreshBook), forControlEvents: .TouchUpInside)
        let rightButton = UIBarButtonItem(customView: sureButton)
        self.navigationItem.rightBarButtonItem = rightButton
        
    }
     func RefreshBook(){
        print("加载通讯录")
        
        //   进入到第一个页面
    }
}
