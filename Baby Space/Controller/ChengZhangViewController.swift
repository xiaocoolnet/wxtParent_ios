//
//  ChengZhangViewController.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/2/19.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import DJKFlipper

class ChengZhangViewController: UIViewController, DJKFlipperDataSource {

    @IBOutlet weak var fip: DJKFlipperView!
    var flipperViewArray:[UIViewController] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.navigationBar.hidden = true

        let view1 = ChengZhang1ViewController(nibName: "PageTestViewController", bundle: nil)
        view1.view.frame = self.view.frame
        view1.backImage.image = UIImage(named: "lanunch")
        view1.view.layoutSubviews()
        let view2 = ChengZhang1ViewController(nibName: "PageTestViewController", bundle: nil)
        view2.view.frame = self.view.frame
        view2.view.layoutSubviews()
        view2.backImage.image = UIImage(named: "lanunch")
        let view3 = ChengZhang1ViewController(nibName: "PageTestViewController", bundle: nil)
        view3.view.frame = self.view.frame
        view3.view.layoutSubviews()
        view3.backImage.image = UIImage(named: "lanunch")
        let view4 = ChengZhang1ViewController(nibName: "PageTestViewController", bundle: nil)
        view4.view.frame = self.view.frame
        view4.view.layoutSubviews()
        view4.backImage.image = UIImage(named: "lanunch")
        let view5 = ChengZhang1ViewController(nibName: "PageTestViewController", bundle: nil)
        view5.view.frame = self.view.frame
        view5.view.layoutSubviews()
        view5.backImage.image = UIImage(named: "lanunch")
        
        flipperViewArray += [view1,view2,view3,view4,view5]
        fip.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func numberOfPages(flipper: DJKFlipperView) -> NSInteger {
        return flipperViewArray.count
    }
    
    func viewForPage(page: NSInteger, flipper: DJKFlipperView) -> UIView {
        return flipperViewArray[page].view
    }

}
