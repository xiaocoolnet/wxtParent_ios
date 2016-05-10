//
//  ImagesViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/5/7.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import YYWebImage
import MBProgressHUD

class ImagesViewController: UIViewController,UIScrollViewDelegate{

    var id:Int?
    var type:Int?
    let scrollView = UIScrollView()
    let pageControl = UIPageControl()
    var picArr = NSMutableArray()
    
    var contentLbl = UILabel()
    var dianzanBtn = UIButton()
    var pinglunBtn = UIButton()
    
    
    var blogSource = BlogList()
    var pciSource = PictureList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor()
        self.loadData()
//        let lbl = UILabel()
//        lbl.numberOfLines = 0
//        lbl.lineBreakMode = .ByWordWrapping
//        lbl.font = UIFont.systemFontOfSize(12)
//        lbl.text = "dscsdvjhksadvbdskjvbfsadj"
//        lbl.textColor = UIColor.whiteColor()
//        self.navigationItem.titleView = lbl
    }
    //  轮播图
    func createScrollerView() {
        self.scrollView.frame = CGRectMake(10, 100,self.view.frame.size.width-20, 250)
        self.scrollView.pagingEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.delegate = self

        for i in 0..<picArr.count {
            let  imageView = UIImageView()
            imageView.frame = CGRectMake(CGFloat(i)*(self.view.frame.size.width-20), 0, self.view.frame.size.width-20, 250)
            imageView.yy_setImageWithURL(picArr[i] as? NSURL, placeholder: UIImage(named: "无网络的背景.png"))
            imageView.tag = i+1
            //为图片视图添加点击事件
            imageView.userInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(ImagesViewController.tapAction(_:)))
            //            手指头
            tap.numberOfTapsRequired = 1
            //            单击
            tap.numberOfTouchesRequired = 1
            imageView.addGestureRecognizer(tap)
            self.scrollView.addSubview(imageView)
        }
        self.scrollView.contentSize = CGSizeMake(CGFloat(picArr.count)*(self.view.frame.size.width-20), 0)
        self.scrollView.contentOffset = CGPointMake(0, 0)
        self.view.addSubview(scrollView)
        
        self.pageControl.frame = CGRectMake(0, 310, WIDTH, 50)
        self.pageControl.pageIndicatorTintColor = UIColor.redColor()
        self.pageControl.numberOfPages = picArr.count
        self.pageControl.currentPage = 0
        self.view.addSubview(self.pageControl)
        
        self.contentLbl.frame = CGRectMake(10, 370, WIDTH-20, HEIGHT-370-60)
        self.contentLbl.numberOfLines = 0
        self.contentLbl.lineBreakMode = .ByWordWrapping
//        self.contentLbl.text = "宝宝今天参加六一儿童节的舞蹈表演了，真的是太可爱了"
        self.contentLbl.textColor = UIColor.whiteColor()
        self.view.addSubview(self.contentLbl)
        
        let bottomView = UIView()
        bottomView.frame = CGRectMake(0, HEIGHT-114, WIDTH, 50)
        bottomView.backgroundColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
        self.view.addSubview(bottomView)
        
        self.dianzanBtn.frame = CGRectMake(20, 15, 20, 20)
        self.dianzanBtn.setImage(UIImage(named: "Logo.png"), forState: .Normal)
        self.dianzanBtn.addTarget(self, action: #selector(ImagesViewController.dianZan), forControlEvents: .TouchUpInside)
        bottomView.addSubview(dianzanBtn)
        
        let countLbl1 = UILabel()
        countLbl1.frame = CGRectMake(50, 15, 40, 20)
        countLbl1.text = "2"
        countLbl1.textColor = UIColor.whiteColor()
        bottomView.addSubview(countLbl1)
        
        
        self.pinglunBtn.frame = CGRectMake(WIDTH-80, 15, 20, 20)
        self.pinglunBtn.setImage(UIImage(named: "Logo.png"), forState: .Normal)
        self.pinglunBtn.addTarget(self, action: #selector(ImagesViewController.pingLun) , forControlEvents: .TouchUpInside)
        bottomView.addSubview(pinglunBtn)
        
        let countLbl2 = UILabel()
        countLbl2.frame = CGRectMake(WIDTH-50, 15, 40, 20)
        countLbl2.text = "12"
        countLbl2.textColor = UIColor.whiteColor()
        bottomView.addSubview(countLbl2)
    }
    //    图片点击事件
    func tapAction(tap:UIGestureRecognizer) {
        var imageView = UIImageView()
        imageView = tap.view as! UIImageView
        print("这是第\(Int(imageView.tag))张图片")
    }
    func scroll(){
        if self.pageControl.currentPage == self.pageControl.numberOfPages-1 {
            self.pageControl.currentPage = 0
        }else{
            self.pageControl.currentPage += 1
        }
        let offSetX:CGFloat = CGFloat(self.pageControl.currentPage) * CGFloat(self.scrollView.frame.size.width-20)
        self.scrollView.setContentOffset(CGPoint(x: offSetX,y: 0), animated: true)
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.pageControl.currentPage = Int(scrollView.contentOffset.x)/Int(self.view.frame.size.width-20)
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var offsetX:CGFloat = self.scrollView.contentOffset.x
        offsetX = offsetX + ((self.scrollView.frame.size.width-20) * 0.5)
        //pageControll改变
        let page:Int = Int(offsetX)/Int(self.scrollView.frame.size.width-20)
        self.pageControl.currentPage = page
    }
    //    加载数据
    func loadData(){
        //        http://wxt.xiaocool.net/index.php?g=apps&m=index&a=GetMicroblog&schoolid=1&classid=1&type=3
        let url = apiUrl+"GetMicroblog"
        
        let schoolid = NSUserDefaults.standardUserDefaults()
        let scid = schoolid.stringForKey("schoolid")
        
        let classid = NSUserDefaults.standardUserDefaults()
        let clid = classid.stringForKey("classid")
        
        let param = [
            "schoolid":scid!,
            "classid":clid!,
            "type":type!
        ]
        Alamofire.request(.GET, url, parameters: param as? [String : AnyObject]).response { request, response, json, error in
            if(error != nil){
            }
            else{
                print("request是")
                print(request!)
                print("====================")
                let status = Http(JSONDecoder(json!))
                
                print("状态是")
                print(status.status)
                if(status.status == "error"){
                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.mode = MBProgressHUDMode.Text;
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                
                if(status.status == "success"){
                    self.blogSource = BlogList(status.data!)
                    let blogInfo = self.blogSource.objectlist[self.id!]
                    self.contentLbl.text = blogInfo.content
                    let picList:PictureList = PictureList(blogInfo.piclist!)
                    for i in 0..<picList.count {
                            let picInfo = picList.picturelist[i]
                            let imgUrl = imageUrl + picInfo.pictureurl!
                            let photourl = NSURL(string: imgUrl)
                            self.picArr.addObject(photourl!)
                    }
                    self.createScrollerView()
                }
            }
            
        }
       
    }
    func dianZan(){
    
    }
    func pingLun(){
//        let vc = CommentViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}
