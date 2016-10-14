//
//  ViewController.swift
//  Timeline
//
//  Created by Evan Dekhayser on 7/26/14.
//  Copyright (c) 2014 Evan Dekhayser. All rights reserved.
//

import UIKit
import ImageSlideshow
import PagingMenuController
import Alamofire
import AFNetworking

class GrowingDiaryMainViewController: UIViewController,UIScrollViewDelegate {
    
    let scrollView = UIScrollView()
    let pageControl = UIPageControl()
    var timer = NSTimer()
    var picArr = NSMutableArray()
    
    override func viewDidAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(GrowingDiaryMainViewController.addDiary))
        timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(GrowingDiaryMainViewController.scroll), userInfo: nil, repeats: true)
        self.GETData()
        self.createChildView()
        
        
        
    }
    //    发图片
    func addDiary(){
        let vc = AddDiaryViewController()
        self.navigationController?.pushViewController(vc, animated: true)
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
                    let string = dataDic["picture_name"];                    print(string)
                    self.picArr.addObject(string as! String)
                    print(self.picArr)
                

                }
            self.createSlideView()
            print(1)
            }) { (AFHTTPRequestOperation, NSError) in
                print("请求失败")
        }
        
    }

        //
    
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
    func createChildView(){
        let v = UIView(frame: CGRectMake(0,HEIGHT/4,WIDTH,HEIGHT/4*3))
        self.view.addSubview(v)
    
        let viewController = GDMyViewController()
        viewController.title = "个人足迹"
        
        let viewController2 = GDFriendsViewController()
        viewController2.title = "好友足迹"
        
        let viewControllers = [viewController, viewController2]
        
        let options = PagingMenuOptions()
        options.menuItemMargin = 5
        options.menuHeight = 40
        options.menuDisplayMode = .SegmentedControl
        options.menuItemMode = .Underline(height: 5, color: RGBA(138.0, g: 227.0, b: 163.0, a: 1.0), horizontalPadding: 0, verticalPadding: 0)
        options.selectedTextColor = RGBA(138.0, g: 227.0, b: 163.0, a: 1.0)
        let pagingMenuController = PagingMenuController(viewControllers: viewControllers, options: options)
        pagingMenuController.view.frame.origin.y += 0
        pagingMenuController.view.frame.size.height -= 0
        
        addChildViewController(pagingMenuController)
        v.addSubview(pagingMenuController.view)
        pagingMenuController.didMoveToParentViewController(self)
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

