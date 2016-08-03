//
//  QCAboutWeVC.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/12.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class QCAboutWeVC: UIViewController {
    var row : Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func initUI(){
        
        self.tabBarController?.tabBar.hidden = true
        self.view.backgroundColor = RGBA(239, g: 239, b: 244, a: 1)
        if self.row == 0 {
            //
            self.title = "使用帮助"
            getLabel("使用帮助")
        }
        if self.row == 2{
            //
            self.title = "关于我们"
            getLabel("AboutUS")
        }
    }
    func getLabel(content:String){
        let label = UILabel()
        label.frame = self.view.bounds
        label.text = content
        label.font = UIFont.systemFontOfSize(50)
        self.view.addSubview(label)
    }

}
