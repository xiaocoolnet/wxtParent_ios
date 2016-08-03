//
//  QCCreditCardSetVC.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/14.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class QCCreditCardSetVC: UIViewController {
    
    let viewOne = UIView()
    let viewTwo = UIView()
    let viewThree = UIView()
    let scrollView = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initScrollView()
        initUI()
        
    }
    func initScrollView(){
        scrollView.frame = self.view.bounds
        if WIDTH == 414 {
            scrollView.contentSize = CGSizeMake(WIDTH, WIDTH / 414.0 * 672)
        }else{
            scrollView.contentSize = CGSizeMake(WIDTH, WIDTH / 414.0 * 736)
        }
        self.view.addSubview(scrollView)
        
    }
    func initUI(){
        self.title = "刷卡设置"
        self.tabBarController?.tabBar.hidden = true
        
        //   分段选择控制器
        let array = ["生活照","亲属照","语音播报"]
        let segmented = UISegmentedControl.init(items: array)
        segmented.frame = CGRectMake(10, 10, WIDTH - 20, 40)
        segmented.selectedSegmentIndex = 0
        segmented.tintColor = RGBA(155, g: 229, b: 180, a: 1.0)
        segmented.addTarget(self, action: #selector(changeView(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.scrollView.addSubview(segmented)
        initViewOne()
        
    }
    
    func changeView(sender:UISegmentedControl){
        print(sender.selectedSegmentIndex)
        if sender.selectedSegmentIndex == 0 {
            
            viewTwo.removeFromSuperview()
            viewThree.removeFromSuperview()
            
            initViewOne()
        }
        if sender.selectedSegmentIndex == 1 {
            
            viewOne.removeFromSuperview()
            viewThree.removeFromSuperview()
            
            initViewTwo()
        }
        if sender.selectedSegmentIndex == 2 {
            
            viewTwo.removeFromSuperview()
            viewOne.removeFromSuperview()
            
            initViewThree()
        }
        
    }
    
    func initViewOne(){
        
        viewOne.frame = CGRectMake(0, 50, WIDTH, WIDTH / 414.0 * 736 - 50)
        viewOne.backgroundColor = RGBA(239, g: 239, b: 244, a: 1)
        self.scrollView.addSubview(viewOne)
        initViewOneUI()
    }
    func initViewTwo(){
        
        viewTwo.frame = CGRectMake(0, 50, WIDTH, WIDTH / 414.0 * 736 - 50)
        //  关闭弹簧效果
        viewTwo.backgroundColor = RGBA(239, g: 239, b: 244, a: 1)
        self.scrollView.addSubview(viewTwo)
        
        initViewTwoUI()
    }
    func initViewThree(){
        
        viewThree.frame = CGRectMake(0, 50, WIDTH, WIDTH / 414.0 * 736 - 50)
        
        viewThree.backgroundColor = RGBA(239, g: 239, b: 244, a: 1)
        self.scrollView.addSubview(viewThree)
        
        initViewThreeUI()
    }
    func initViewOneUI(){
        
        let titleLabel = UILabel()
        titleLabel.frame = CGRectMake(10, 20, WIDTH - 20, 30)
        titleLabel.text = "宝宝靓照要在打卡机上显示，拍漂亮一点哦！！～～"
        viewOne.addSubview(titleLabel)
        
        
        
        let view = UIView()
        view.frame = CGRectMake(10, 50, WIDTH - 20, WIDTH - 60)
        view.backgroundColor = UIColor.whiteColor()
        viewOne.addSubview(view)
        
        let photoButton = UIButton()
        photoButton.frame = CGRectMake((WIDTH - 20) / 4.0, (WIDTH - 20) / 4.0, (WIDTH - 20) / 2.0, (WIDTH - 20) / 2.0)
        photoButton.setImage(UIImage.init(named: "1.png"), forState: .Normal)
        photoButton.addTarget(self, action: #selector(getPhoto), forControlEvents: .TouchUpInside)
        view.addSubview(photoButton)
        
        let photoLabel = UILabel()
        photoLabel.frame = CGRectMake(50, (WIDTH - 20) / 4.0 * 3.0, WIDTH - 120, 30)
        photoLabel.text = "上传宝宝的靓照吧"
        view.addSubview(photoLabel)
        
        
        
        let textView = UITextView()
        textView.frame = CGRectMake(10, WIDTH, WIDTH - 20, WIDTH * 0.4 - 24)
        viewOne.addSubview(textView)
//
        let cancleButton = UIButton()
        cancleButton.frame = CGRectMake((WIDTH / 2.0 - 80) / 4.0 * 3, WIDTH + WIDTH * 0.4 - 14, 80, WIDTH / 414 * 40)
        cancleButton.backgroundColor = UIColor.orangeColor()
        cancleButton.addTarget(self, action: #selector(cancleAction), forControlEvents: .TouchUpInside)
        viewOne.addSubview(cancleButton)
        
        let sureButton = UIButton()
        sureButton.frame = CGRectMake((WIDTH / 2.0 - 80) / 4.0 + WIDTH / 2.0 , WIDTH + WIDTH * 0.4 - 14, 80, WIDTH / 414 * 40)
        sureButton.backgroundColor = RGBA(155, g: 229, b: 180, a: 1)
        sureButton.addTarget(self, action: #selector(sureAction), forControlEvents: .TouchUpInside)
        viewOne.addSubview(sureButton)
    
    }
    
    func getPhoto(){
        //   上传照片
        print("上传照片")
    }
    func cancleAction(){
        //  取消按钮
        print("取消按钮")
    }
    func sureAction(){
        //  确定按钮
        print("确定按钮")
        
        
    }
    func initViewTwoUI(){
        let titleLabel = UILabel()
        titleLabel.frame = CGRectMake(10, 20, WIDTH - 20, 30)
        titleLabel.text = "宝宝靓照要在打卡机上显示，拍漂亮一点哦！！～～"
        viewTwo.addSubview(titleLabel)
        
        let setLabel = UILabel()
        setLabel.frame = CGRectMake(10, 50, WIDTH - 20, 30)
        setLabel.text = "设置要求:"
        viewTwo.addSubview(setLabel)
        
        let imageLabel = UILabel()
        imageLabel.frame = CGRectMake(10, 80, WIDTH - 20, 30)
        imageLabel.text = "设置要求:"
        viewTwo.addSubview(imageLabel)
        
        
        let view = UIView()
        view.frame = CGRectMake(10, 120, WIDTH - 20, WIDTH - 20)
        view.backgroundColor = UIColor.greenColor()
        viewTwo.addSubview(view)
        
        let cancleButton = UIButton()
        cancleButton.frame = CGRectMake((WIDTH / 2.0 - 80) / 4.0 * 3, WIDTH + 110, 80, WIDTH / 414 * 40)
        cancleButton.backgroundColor = UIColor.orangeColor()
        cancleButton.addTarget(self, action: #selector(cancleAction), forControlEvents: .TouchUpInside)
        viewTwo.addSubview(cancleButton)
        
        let sureButton = UIButton()
        sureButton.frame = CGRectMake((WIDTH / 2.0 - 80) / 4.0 + WIDTH / 2.0 , WIDTH + 110, 80, WIDTH / 414 * 40)
        sureButton.backgroundColor = RGBA(155, g: 229, b: 180, a: 1)
        sureButton.addTarget(self, action: #selector(sureAction), forControlEvents: .TouchUpInside)
        viewTwo.addSubview(sureButton)
        
        
        
    }
    func initViewThreeUI(){
        
        
        
        
        
        let cancleButton = UIButton()
        cancleButton.frame = CGRectMake((WIDTH / 2.0 - 80) / 4.0 * 3, WIDTH + 110, 80, WIDTH / 414 * 40)
        cancleButton.backgroundColor = UIColor.orangeColor()
        cancleButton.addTarget(self, action: #selector(cancleAction), forControlEvents: .TouchUpInside)
        viewThree.addSubview(cancleButton)
        
        let sureButton = UIButton()
        sureButton.frame = CGRectMake((WIDTH / 2.0 - 80) / 4.0 + WIDTH / 2.0 , WIDTH + 110, 80, WIDTH / 414 * 40)
        sureButton.backgroundColor = RGBA(155, g: 229, b: 180, a: 1)
        sureButton.addTarget(self, action: #selector(sureAction), forControlEvents: .TouchUpInside)
        viewThree.addSubview(sureButton)
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
