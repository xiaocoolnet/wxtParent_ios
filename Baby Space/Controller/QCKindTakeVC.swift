//
//  QCKindTakeVC.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/21.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import PagingMenuController

class QCKindTakeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initUI() {
        view.backgroundColor = UIColor.whiteColor()
        //  是否显示视图控制器
        self.tabBarController?.tabBar.hidden = true
        
        let viewController = TakeTableViewController()
        viewController.title = "待处理"
        
        let viewController2 = QCTokenCompleteVC()
        viewController2.title = "已完成"

        
        let viewController3 = QCNotTokenCompleteVC()
        viewController3.title = "已过期"

        
        let viewControllers = [viewController, viewController2,viewController3]
        
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
