//
//  QCIntegralMallVC.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/14.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class QCIntegralMallVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()

    }
    func initUI(){
        self.title = "积分商城"
        self.tabBarController?.tabBar.hidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    



}
