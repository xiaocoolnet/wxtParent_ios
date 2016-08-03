//
//  PCommentViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/5/15.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class PCommentViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "评论列表"
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(PCommentViewController.writeComment))
    }
//    发表评论
    func writeComment(){
        let vc = PWriteViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
