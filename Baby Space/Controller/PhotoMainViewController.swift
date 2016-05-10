//
//  PhotoMainViewController.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/2/18.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import PagingMenuController

class PhotoMainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        self.tabBarController?.tabBar.hidden = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(PhotoMainViewController.sendPhoto))
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("MyPhotoView") as! MyPhotoViewController
        viewController.title = "宝宝相册"
        
        let viewController2 = ClassViewController()
        viewController2.title = "班级相册"
        
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
//    发图片
    func sendPhoto(){
       let vc = SendPhotoViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
