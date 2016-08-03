//
//  SchoolMainTableViewController.swift
//  WXT_Parents
//
//  Created by xiaocool on 16/1/28.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import ImageSlideshow
import Alamofire

class SchoolMainTableViewController: UITableViewController {

    
    var dataArr = NSMutableArray()
//    @IBOutlet weak var schoolImageScroll: ImageSlideshow!
    //  校园公告

    @IBOutlet weak var schoolHeaderImage: UIImageView!
    
    @IBOutlet weak var schoolContent: UILabel!
    
    
    @IBOutlet weak var newsContent: UILabel!
    
    @IBOutlet weak var newsHeaderImage: UIImageView!
    
    @IBOutlet weak var yuerContent: UILabel!
    
    @IBOutlet weak var yuerHeaderImage: UIImageView!
    
    var schoolId = String()
    var newsId = String()
    var yuerId = String()
    
    
    @IBOutlet weak var myScrollView: UIScrollView!
    var scrollView = UIScrollView()
    var pageControl = UIPageControl()
    var timer = NSTimer()
    
    
    @IBAction func directorBoxBtn(sender: AnyObject) {
        //  进入院长信箱
        print("进入园长信箱")
        let directorBoxVC = QCDirectorBoxVC()
        self.navigationController?.pushViewController(directorBoxVC, animated: true)
        
    }
    @IBAction func schoolNotice(sender: AnyObject) {
        
        //  调转到公告的界面，得到公告
        let schoolNoticeVC = SchoolNoticeVC()
        self.navigationController?.pushViewController(schoolNoticeVC, animated: true)
        
        
        
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView = myScrollView
        schoolHeaderImage.image = UIImage.init(named: "wxt_1.png")
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(GrowingDiaryMainViewController.scroll), userInfo: nil, repeats: true)
//        ScrollViewImage()
        createSlideView()
        
        
//        print(schoolImageScroll.frame)

        reloadData()
        GETNEW()
        GETYuER()
    }
    
    
    func reloadData(){
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=school&a=getSchoolNotices"
        let u = NSUserDefaults.standardUserDefaults()
        let schoolid = u.valueForKey("schoolid")
        let param = ["schoolid":schoolid!]
//        http://wxt.xiaocool.net/index.php?g=apps&m=school&a=getSchoolNotices&schoolid=1
        Alamofire.request(.GET, url, parameters:param ).responseJSON {response in
            switch response.result {
            case .Success:
                //把得到的JSON数据转为字典
                if let j = response.result.value as? NSDictionary{
                    //获取字典里面的key为数组
                    let Items = j.valueForKey("data")as! NSArray
                    //便利数组得到每一个字典模型
                        self.dataArr.removeAllObjects()
                    for _ in Items{
                        self.dataArr.addObject(Items.lastObject!)
                    }
                    for dict1 in self.dataArr{
                        self.schoolContent.text = dict1["post_excerpt"] as? String
                        let thumb = dict1["thumb"] as? String
                        let url = imageUrl + thumb!
                        self.schoolHeaderImage.sd_setImageWithURL(NSURL.init(string: url), placeholderImage: UIImage.init(named: "wxt_1.png"))
                        self.schoolId = (dict1["id"] as? String)!
                    }
                }
            case .Failure(let error):
                
                print(error)
            }
            
            
        }
    }
    
    func GETNEW(){

        //  新闻通知
//        http://wxt.xiaocool.net/index.php?g=apps&m=school&a=getSchoolNews&schoolid=1

        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=school&a=getSchoolNews"
        let u = NSUserDefaults.standardUserDefaults()
        let schoolid = u.valueForKey("schoolid")
        let param = ["schoolid":schoolid!]
        Alamofire.request(.GET, url, parameters:param ).responseJSON {response in
            switch response.result {
            case .Success:
                //把得到的JSON数据转为字典
                if let j = response.result.value as? NSDictionary{
                    //获取字典里面的key为数组
                    let Items = j.valueForKey("data")as! NSArray
                    //便利数组得到每一个字典模型
                    self.dataArr.removeAllObjects()

                    for _ in Items{
                        self.dataArr.addObject(Items.lastObject!)
                    }
                    for dict1 in self.dataArr{
                        self.newsContent.text = dict1["post_excerpt"] as? String
                        let thumb = dict1["thumb"] as? String
                        let url = imageUrl + thumb!
                        self.newsHeaderImage.sd_setImageWithURL(NSURL.init(string: url), placeholderImage: UIImage.init(named: "wxt_1.png"))
                        self.newsId = (dict1["id"] as? String)!
                    }
                }
            case .Failure(let error):
                
                print(error)
            }
            
            
        }
    }
    
    func GETYuER(){
        
        //  新闻通知
//     http://wxt.xiaocool.net/index.php?g=apps&m=school&a=getParentsThings&schoolid=1
        
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=school&a=getParentsThings"
        let u = NSUserDefaults.standardUserDefaults()
        let schoolid = u.valueForKey("schoolid")
        let param = ["schoolid":schoolid!]
        Alamofire.request(.GET, url, parameters:param ).responseJSON {response in
            switch response.result {
            case .Success:
                //把得到的JSON数据转为字典
                if let j = response.result.value as? NSDictionary{
                    //获取字典里面的key为数组
                    let Items = j.valueForKey("data")as! NSArray
                    //便利数组得到每一个字典模型
                    self.dataArr.removeAllObjects()

                    for _ in Items{
                        self.dataArr.addObject(Items.lastObject!)
                    }
                    for dict1 in self.dataArr{
                        self.yuerContent.text = dict1["post_excerpt"] as? String
                        let thumb = dict1["thumb"] as? String
                        let url = imageUrl + thumb!
                        self.yuerHeaderImage.sd_setImageWithURL(NSURL.init(string: url), placeholderImage: UIImage.init(named: "wxt_1.png"))
                        self.yuerId = (dict1["id"] as? String)!
                    }
                }
            case .Failure(let error):
                
                print(error)
            }
            
            
        }
    }
        
        
        
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
    }

    @IBAction func pushBabyVC(sender: AnyObject) {
        let babyVC = BabyShowGroundVC()
        self.navigationController?.pushViewController(babyVC, animated: true)

    }

    //  
//    func ScrollViewImage(){
//        //  设置时间
//        schoolImageScroll.slideshowInterval = 5.0
//
////          设置图片
//        schoolImageScroll.setImageInputs([AFURLSource(urlString: "http://pic2.ooopic.com/01/03/51/25b1OOOPIC19.jpg")!, AFURLSource(urlString: "http://ppt360.com/background/UploadFiles_6733/201012/2010122016291897.jpg")!, AFURLSource(urlString: "http://img.taopic.com/uploads/allimg/130501/240451-13050106450911.jpg")!])
//    }
    func createSlideView(){
//        schoolImageScroll.slideshowInterval = 5.0

        
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
            imageView.image = UIImage(named: array[i] as! String)
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


    // MARK: - Table view data source



    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("1111111")
        //  跳转到分享页面
        //  校园
        //  http://wxt.xiaocool.net/index.php?g=portal&m=article&a=notice&id=39
        if indexPath.section == 1 && indexPath.row == 1{
            print("1,1")
            print(self.schoolId)
            let vc = TeacherInfoViewController()
            vc.id = self.schoolId
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.section == 2 && indexPath.row == 1{
            print("2,1")
            //  新闻
            print(self.newsId)
            //  http://wxt.xiaocool.net/index.php?g=portal&m=article&a=news&id=16
            let vc = TeacherInfoViewController()
            vc.id = self.newsId
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.section == 3 && indexPath.row == 1{
            print("3,1")
            let vc = TeacherInfoViewController()
            vc.id = self.yuerId
            print(self.yuerId)
            
            self.navigationController?.pushViewController(vc, animated: true)

        }

    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        return 0.01
        
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5.0
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
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.pageControl.currentPage = Int(scrollView.contentOffset.x)/Int(self.view.frame.size.width)
    }
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        var offsetX:CGFloat = self.scrollView.contentOffset.x
        offsetX = offsetX + (self.scrollView.frame.size.width * 0.5)
        //pageControll改变
        let page:Int = Int(offsetX)/Int(self.scrollView.frame.size.width)
        self.pageControl.currentPage = page
    }
    //开始拖拽时
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        timer.fireDate = NSDate.distantFuture()
    }
    //结束拖拽时
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        timer.fireDate = NSDate.distantPast()
    }
    


}
