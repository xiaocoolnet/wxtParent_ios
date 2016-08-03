//
//  XQBDetailViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/6/2.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class XQBDetailViewController: UIViewController {

    var nameLab = UILabel()
    @IBOutlet weak var detailLbl: UILabel!
    @IBOutlet weak var joinBtn: UIButton!
    
    var banInfo:XingQuBanInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameLab.frame = CGRectMake(100, 100, 100, 100)
        
        
        self.view.addSubview(self.nameLab)
        
        
        
        self.title = "美术兴趣班"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(XQBDetailViewController.member))
        print(banInfo?.post_title)
        self.nameLab.text = banInfo?.post_title
        //  下面的都需要进行修改
        self.detailLbl.text = banInfo!.description
        if banInfo?.status == "1"{
            self.joinBtn.backgroundColor = UIColor.whiteColor()
            self.joinBtn.selected = false
        }else{
            self.joinBtn.addTarget(self, action: #selector(XQBDetailViewController.join), forControlEvents: .TouchUpInside)
        }
    }
//    加入
    func join(){
        print("加入")
    }
//    成员
    func member(){
        let vc = XQBMemberViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
