//
//  NReadViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/5/15.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import PagingMenuController

class NReadViewController: UIViewController {

    var id:String?
    var num1:String?
    var num2:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "列表"
        view.backgroundColor = UIColor.whiteColor()
        self.tabBarController?.tabBar.hidden = true
        
        let viewController = NReadOverViewController()
        viewController.title = "已读\(num1!)"
        
        let viewController2 = NUnreadViewController()
        viewController2.title = "未读\(num2!)"
        
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

}
