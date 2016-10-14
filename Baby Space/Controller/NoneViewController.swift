//
//  NoneViewController.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/8/12.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import ImageSlideshow
import Alamofire
import AFNetworking

class NoneViewController: UIViewController, UIScrollViewDelegate {
    
    let scrollView = UIScrollView()
    let pageControl = UIPageControl()
    var timer = NSTimer()
    var picArr = NSMutableArray()
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = RGBA(242.0, g: 242.0, b: 242.0, a: 1)
        timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(GrowingDiaryMainViewController.scroll), userInfo: nil, repeats: true)
        self.GETData()
        
    }
    func GETData(){
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=index&a=Viwepager"
        let  afManager = AFHTTPRequestOperationManager()
        afManager.responseSerializer =  AFHTTPResponseSerializer()
        afManager.GET(url, parameters: nil, success: { (AFHTTPRequestOperation, AnyObject) in
            print("请求成功")
            //            print(AnyObject)
            let jsonData = try? NSJSONSerialization.JSONObjectWithData(AnyObject as! NSData, options: NSJSONReadingOptions.AllowFragments)
            print(jsonData)
            
            // 字典  数组 字典  字符串
            let dataArr = jsonData!["data"] as! NSArray
            print(dataArr.count)
            for  i in 0 ..< dataArr.count{
                let dataDic =  dataArr[i]
                let string = dataDic["picture_name"];
                print(string)
                self.picArr.addObject(string as! String)
                print(self.picArr)
                
                
            }
            self.createSlideView()
            self.createImg()
            print(1)
        }) { (AFHTTPRequestOperation, NSError) in
            print("请求失败")
        }
        
    }
    
    // 添加图片
    func createImg(){
        let img = UIImageView()
        img.frame = CGRectMake(0, HEIGHT/4 + 10, WIDTH, HEIGHT - HEIGHT/4)
        img.contentMode = .ScaleAspectFit
        img.image = UIImage(named: "催一催")
        self.view.addSubview(img)
        
        let btn = UIButton()
        btn.frame = img.frame
        btn.backgroundColor = UIColor.clearColor()
        btn.addTarget(self, action: #selector(self.Exitlogin), forControlEvents: .TouchUpInside)
        self.view.addSubview(btn)
        

    }
    
    func Exitlogin(){
        let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("催一催你的好友更新足迹？", comment: "empty message"), preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        let doneAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
        
            let shareParames = NSMutableDictionary()
            shareParames.SSDKSetupShareParamsByText("您已经好久没有上传孩子的足迹了，快去智校园上更新孩子足迹吧",
                                                    images : nil,
                                                    url : nil,
                                                    title : "您已经好久没有上传孩子的足迹了，快去智校园上更新孩子足迹吧",
                                                    type : SSDKContentType.Text)
            
            
            if WXApi.isWXAppInstalled() {
                //微信好友分享
                ShareSDK.share(SSDKPlatformType.SubTypeWechatSession , parameters: shareParames) { (state : SSDKResponseState, userData : [NSObject : AnyObject]!, contentEntity :SSDKContentEntity!, error : NSError!) -> Void in
                    switch state{
                        
                    case SSDKResponseState.Success:
                        print("分享成功")
                        let alert = UIAlertView(title: "分享成功", message: "分享成功", delegate: self, cancelButtonTitle: "确定")
                        alert.show()
                        
                    case SSDKResponseState.Fail:  print("分享失败,错误描述:\(error)")
                    case SSDKResponseState.Cancel:  print("分享取消")
                        
                    default:
                        break
                    }
                }
            }else{
                let alertView = UIAlertView.init(title:"提示" , message: "没有安装微信", delegate: self, cancelButtonTitle: "确定")
                alertView.show()
                
            }

        }
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
    }

    
//    func clickBtn(){
//        let shareParames = NSMutableDictionary()
//        shareParames.SSDKSetupShareParamsByText("您已经好久没有上传孩子的足迹了，快去智校园上更新孩子足迹吧",
//                                                images : nil,
//                                                url : nil,
//                                                title : "您已经好久没有上传孩子的足迹了，快去智校园上更新孩子足迹吧",
//                                                type : SSDKContentType.Text)
//        
//        
//        if WXApi.isWXAppInstalled() {
//            //微信好友分享
//            ShareSDK.share(SSDKPlatformType.SubTypeWechatSession , parameters: shareParames) { (state : SSDKResponseState, userData : [NSObject : AnyObject]!, contentEntity :SSDKContentEntity!, error : NSError!) -> Void in
//                switch state{
//                    
//                case SSDKResponseState.Success:
//                    print("分享成功")
//                    let alert = UIAlertView(title: "分享成功", message: "分享成功", delegate: self, cancelButtonTitle: "确定")
//                    alert.show()
//                    
//                case SSDKResponseState.Fail:  print("分享失败,错误描述:\(error)")
//                case SSDKResponseState.Cancel:  print("分享取消")
//                    
//                default:
//                    break
//                }
//            }
//        }else{
//            let alertView = UIAlertView.init(title:"提示" , message: "没有安装微信", delegate: self, cancelButtonTitle: "确定")
//            alertView.show()
//            
//        }
//    }
    
    //    创建轮播图
    func createSlideView(){
        self.scrollView.frame = CGRectMake(0, 0,WIDTH, HEIGHT/4)
        self.scrollView.pagingEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.delegate = self
        
        //  通过解析得到图片
        //  http://wxt.xiaocool.net/index.php?g=apps&m=index&a=Viwepager
        //        picArr = ["s1","s2","s3","s4"]
        let array = ["sc1.jpg","sc2.jpg","sc3.jpg","sc4.jpg"]
        for i in 0...3 {
            let  imageView = UIImageView()
            imageView.frame = CGRectMake(CGFloat(i)*WIDTH, 0, WIDTH, HEIGHT/4)
            //            imageView.sd_setImageWithURL(NSURL.init(string: (growCoverImageUrl + (array[i] as! String) )))
            imageView.image = UIImage(named: array[i] )
            imageView.tag = i+1
            //为图片视图添加点击事件
            imageView.userInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(GrowingDiaryMainViewController.tapAction(_:)))
            //            手指头
            tap.numberOfTapsRequired = 1
            //            单击
            tap.numberOfTouchesRequired = 1
            imageView.addGestureRecognizer(tap)
            self.scrollView.addSubview(imageView)
        }
        self.scrollView.contentSize = CGSizeMake(4*WIDTH, 0)
        self.scrollView.contentOffset = CGPointMake(0, 0)
        self.view.addSubview(scrollView)
        
        self.pageControl.frame = CGRectMake(0, HEIGHT/5-20, WIDTH, 17)
        self.pageControl.pageIndicatorTintColor = UIColor.redColor()
        self.pageControl.numberOfPages = 4
        self.pageControl.currentPage = 0
        self.view.addSubview(self.pageControl)
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
        let offSetX:CGFloat = CGFloat(self.pageControl.currentPage) * CGFloat(self.scrollView.frame.size.width)
        self.scrollView.setContentOffset(CGPoint(x: offSetX,y: 0), animated: true)
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.pageControl.currentPage = Int(scrollView.contentOffset.x)/Int(self.view.frame.size.width)
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var offsetX:CGFloat = self.scrollView.contentOffset.x
        offsetX = offsetX + (self.scrollView.frame.size.width * 0.5)
        //pageControll改变
        let page:Int = Int(offsetX)/Int(self.scrollView.frame.size.width)
        self.pageControl.currentPage = page
    }
    //开始拖拽时
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        timer.fireDate = NSDate.distantFuture()
    }
    //结束拖拽时
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        timer.fireDate = NSDate.distantPast()
    }

   
}
