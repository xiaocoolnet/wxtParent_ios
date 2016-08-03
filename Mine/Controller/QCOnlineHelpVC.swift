//
//  QCOnlineHelpVC.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/14.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class QCOnlineHelpVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        //  进行环信的集成（聊天）
    }
    func initUI(){
        self.title = "在线客服"
        self.tabBarController?.tabBar.hidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
