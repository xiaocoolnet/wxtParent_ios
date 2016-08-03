//
//  QCBabyDetailsVC.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/14.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class QCBabyDetailsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()

    }
    func initUI(){
        self.title = "我是宝宝n号"
        self.tabBarController?.tabBar.hidden = true
        self.view.backgroundColor = RGBA(239, g: 239, b: 244, a: 1)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
