//
//  QCOpinionVC.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/12.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class QCOpinionVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //   打开手势交互
        self.view.userInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(_:)))
        
        self.view.addGestureRecognizer(tap)
        initUI()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func tapAction(tap:UITapGestureRecognizer){
        self.view.endEditing(true)
    }

    
    func initUI(){
        
        self.tabBarController?.tabBar.hidden = true
        self.view.backgroundColor = RGBA(239, g: 239, b: 244, a: 1)
        
        let label = UILabel()
        label.frame = CGRectMake(10, 10, WIDTH - 20, 30)
        label.text = "请输入您宝贵的建议"
        self.view.addSubview(label)
        
        let textView = UITextView()
        textView.frame = CGRectMake(0, 50, WIDTH, WIDTH * 0.5)
        textView.layer.cornerRadius = 5
        self.view.addSubview(textView)
        
        let submitButton = UIButton()
        submitButton.frame = CGRectMake(10, HEIGHT * 0.6, WIDTH - 20, 45)
        submitButton.backgroundColor = RGBA(155, g: 229, b: 180, a: 1)
        submitButton.layer.cornerRadius = 4
        submitButton.setTitle("提交", forState: .Normal)
        submitButton.addTarget(self, action: #selector(submit), forControlEvents: .TouchUpInside)
        self.view.addSubview(submitButton)

    }
    func submit(){
        //
    }
    //  隐藏输入框

}
