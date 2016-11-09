//
//  QCQrCodeVC.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/14.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class QCQrCodeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
        
    }
    func initUI(){
        self.title = "二维码扫描"
        self.tabBarController?.tabBar.hidden = true
        
        let imageView = UIImageView()
        imageView.frame = CGRectMake(WIDTH / 4, HEIGHT / 2 - WIDTH / 4 - 60, WIDTH / 2, WIDTH
         / 2)
        imageView.image = UIImage.init(named: "weixiaotongjiazhang")
        self.view.addSubview(imageView)
        
        let titleLabel = UILabel()
        titleLabel.frame = CGRectMake(WIDTH / 4, HEIGHT / 2 + WIDTH / 4 - 60, WIDTH / 2, 30)
        titleLabel.text = "扫描下载客户端"
        titleLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(titleLabel)
        
        let sureButton = UIButton()
        sureButton.frame = CGRectMake(0, HEIGHT - 104, WIDTH, 40)
        sureButton.setTitle("分享", forState: .Normal)
        sureButton.backgroundColor = RGBA(155, g: 229, b: 180, a: 1)
        sureButton.addTarget(self, action: #selector(shareAction), forControlEvents: .TouchUpInside)
//        self.view.addSubview(sureButton)
        
        
        
        
    }
    func shareAction(){
        //  微信分享
        print("微信分享")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
