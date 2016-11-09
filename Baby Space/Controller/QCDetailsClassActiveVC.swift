//
//  QCDetailsClassActiveVC.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/19.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import YYWebImage
import XWSwiftRefresh
import MBProgressHUD

class QCDetailsClassActiveVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var id:String!
    //  数据源
    var activitySource = ActivityInfo()
    var activity_listSource = activity_listList()
    var apply_countSource = apply_countList()
    var picSource = picList()
    var user_Source = user_List()
    //  创建tableview
    var tableView = UITableView()
    var isCollect:Bool = false
    var likeNum  = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        createTableView()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    func initUI(){
        self.title = "活动详情"
        self.tabBarController?.tabBar.hidden = true
        self.view.backgroundColor = RGBA(239, g: 239, b: 244, a: 1)
    }
    
    
    func createTableView(){
        tableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(QCDetailsClassActiveCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
    }
    
    func GETData(){
    
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? QCDetailsClassActiveCell
        cell?.selectionStyle = .None
        let activity_listModel = self.activity_listSource.activityList[0]
        self.user_Source = user_List(activity_listModel.user_info!)
        if self.user_Source.activityList.count != 0 {
            let userModel = self.user_Source.activityList[0]
            cell?.teacherLabel.text = userModel.name
            cell?.teacherLabel.font = biaotifont
            cell?.teacherLabel.textColor = biaotiColor
        }
        
        cell?.titleLabel.text = activity_listModel.title
        //  活动时间
        let dateformate = NSDateFormatter()
        dateformate.dateFormat = "MM-dd HH:mm"
        let date = NSDate(timeIntervalSince1970: NSTimeInterval(activity_listModel.create_time!)!)
        let str:String = dateformate.stringFromDate(date)
        cell?.timeLabel.text = str
        
        cell?.contentLabel.text = activity_listModel.content
        cell?.contentLabel.numberOfLines = 0
        cell?.contentLabel.sizeToFit()
        
        let dateformate1 = NSDateFormatter()
        dateformate1.dateFormat = "yy-MM-dd"
        let data1 = NSDate(timeIntervalSince1970: NSTimeInterval(activity_listModel.begintime!)!)
        cell?.startTime.frame = CGRectMake(10, (cell?.contentLabel.frame.size.height)!+cell!.contentLabel.frame.origin.y + 20, WIDTH - 20, 30)
        cell?.startTime.text = "活动开始时间\(dateformate.stringFromDate(data1))"
        cell?.startTime.sizeToFit()
        
        let dateformate2 = NSDateFormatter()
        dateformate2.dateFormat = "MM-dd"
        let data2 = NSDate(timeIntervalSince1970: NSTimeInterval(activity_listModel.starttime!)!)
        let data3 = NSDate(timeIntervalSince1970: NSTimeInterval(activity_listModel.endtime!)!)
        let data4 = NSDate(timeIntervalSince1970: NSTimeInterval(activity_listModel.finishtime!)!)
        cell?.activeTimes.frame = CGRectMake(10, (cell?.startTime.frame.size.height)!+cell!.startTime.frame.origin.y + 20, WIDTH - 20, 30)
        cell?.activeTimes.text = "活动结束时间\(dateformate.stringFromDate(data3))"
        
        cell?.startime.frame = CGRectMake(10, (cell?.activeTimes.frame.size.height)!+cell!.activeTimes.frame.origin.y + 20, WIDTH - 20, 30)
        if activity_listModel.starttime != "0" {
            
            cell?.startime.text = "活动报名时间\(dateformate.stringFromDate(data2))"
        }else{
            cell?.startime.text = "活动开始报名时间:  无"
        }
        
        cell?.finishtime.frame = CGRectMake(10, (cell?.startime.frame.size.height)!+cell!.startime.frame.origin.y + 20, WIDTH - 20, 30)
        if activity_listModel.finishtime == "0" {
            cell?.finishtime.text = "活动结束报名时间:  无"
        }else{
            
            cell?.finishtime.text = "活动结束报名时间\(dateformate.stringFromDate(data4))"
        }
        
        var pic = self.picSource.activityList
        //        print(picModel.count)
        
        
        
        //  图片
        var image_h = CGFloat()
        var button:CustomBtn?
        
        let height = (cell?.finishtime.frame.size.height)!+cell!.finishtime.frame.origin.y + 30
        
        
        //判断图片张数显示
        //解决数据返回有null和“”的错误图片显示
        if pic.count==1&&(pic.first?.picture_url=="null"||pic.first?.picture_url=="") {
            pic.removeAll()
        }

        if(pic.count>0&&pic.count<=3){
            image_h=300
            if pic.count==1 {
                let pciInfo = pic[0]
                let imgUrl = microblogImageUrl+(pciInfo.picture_url)!
                let avatarUrl = NSURL(string: imgUrl)
                let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                    if(data != nil){
                        
                        button = CustomBtn()
                        button?.flag = 1
                        button!.frame = CGRectMake(10, height, WIDTH - 20, 300)
                        let imgTmp = UIImage(data: data!)
                        
                        button!.setImage(imgTmp, forState: .Normal)
                        button?.imageView?.contentMode = .ScaleAspectFill
                        button?.clipsToBounds = true
                        if button?.imageView?.image == nil{
                            button?.setBackgroundImage(UIImage(named: "图片默认加载"), forState: .Normal)
                        }
                        button?.tag = indexPath.row
                        button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                        cell!.contentView.addSubview(button!)
                        
                    }
                })
                
            }else{
                image_h=(WIDTH - 40)/3.0
                for i in 1...pic.count{
                    var x = 12
                    let pciInfo = pic[i-1]
                    let imgUrl = microblogImageUrl+(pciInfo.picture_url)!
                    let avatarUrl = NSURL(string: imgUrl)
                    let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                    
                    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                        if(data != nil){
                            x = x+((i-1)*Int((WIDTH - 40)/3.0 + 10))
                            button = CustomBtn()
                            button?.flag = i
                            button!.frame = CGRectMake(CGFloat(x), height, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                            let imgTmp = UIImage(data: data!)
                            
                            button!.setImage(imgTmp, forState: .Normal)
                            button?.imageView?.contentMode = .ScaleAspectFill
                            button?.clipsToBounds = true
                            if button?.imageView?.image == nil{
                                button?.setBackgroundImage(UIImage(named: "图片默认加载"), forState: .Normal)
                            }
                            button?.tag = indexPath.row
                            button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                            cell!.contentView.addSubview(button!)
                            
                        }
                    })
                }
            }
        }
        if(pic.count>3&&pic.count<=6){
            image_h=(WIDTH - 40)/3.0*2 + 10
            for i in 1...pic.count{
                if i <= 3 {
                    var x = 12
                    let pciInfo = pic[i-1]
                    if pciInfo.picture_url != "" {
                        
                        
                        let imgUrl = microblogImageUrl+(pciInfo.picture_url)!
                        
                        //let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-1)*Int((WIDTH - 40)/3.0 + 10))
                                button = CustomBtn()
                                button?.flag = i
                                button!.frame = CGRectMake(CGFloat(x), height, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                                
                                let imgTmp = UIImage(data: data!)
                                
                                button!.setImage(imgTmp, forState: .Normal)
                                if button?.imageView?.image == nil{
                                    button!.setImage(UIImage(named: "图片默认加载"), forState: .Normal)
                                }
                                button?.tag = indexPath.row
                                button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                                cell!.contentView.addSubview(button!)
                            }
                        })
                    }}else{
                    var x = 12
                    let pciInfo = pic[i-1]
                    if pciInfo.picture_url != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.picture_url)!
                        
                        //let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-4)*Int((WIDTH - 40)/3.0 + 10))
                                button = CustomBtn()
                                button?.flag = i
                                button!.frame = CGRectMake(CGFloat(x), height+(WIDTH - 40)/3.0 + 5, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                                let imgTmp = UIImage(data: data!)
                                
                                button!.setImage(imgTmp, forState: .Normal)
                                if button?.imageView?.image == nil{
                                    button!.setImage(UIImage(named: "图片默认加载"), forState: .Normal)
                                }
                                button?.tag = indexPath.row
                                button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                                cell!.contentView.addSubview(button!)
                            }
                        })
                        
                    }
                }
            }}
        if(pic.count>6&&pic.count<=9){
            image_h=(WIDTH - 40)/3.0*3+20
            for i in 1...pic.count{
                if i <= 3 {
                    var x = 12
                    let pciInfo = pic[i-1]
                    if pciInfo.picture_url != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.picture_url)!
                        
                        //let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-1)*Int((WIDTH - 40)/3.0 + 10))
                                button = CustomBtn()
                                button?.flag = i
                                button!.frame = CGRectMake(CGFloat(x), height, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                                let imgTmp = UIImage(data: data!)
                                
                                button!.setImage(imgTmp, forState: .Normal)
                                if button?.imageView?.image == nil{
                                    button!.setImage(UIImage(named: "图片默认加载"), forState: .Normal)
                                }
                                button?.tag = indexPath.row
                                button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                                cell!.contentView.addSubview(button!)
                            }
                        })
                        
                    }}else if (i>3&&i<=6){
                    var x = 12
                    let pciInfo = pic[i-1]
                    if pciInfo.picture_url != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.picture_url)!
                        
                        //let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-4)*Int((WIDTH - 40)/3.0 + 10))
                                button = CustomBtn()
                                button?.flag = i
                                button!.frame = CGRectMake(CGFloat(x), height+(WIDTH - 40)/3.0 + 5, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                                let imgTmp = UIImage(data: data!)
                                
                                button!.setImage(imgTmp, forState: .Normal)
                                if button?.imageView?.image == nil{
                                    button!.setImage(UIImage(named: "图片默认加载"), forState: .Normal)
                                }
                                button?.tag = indexPath.row
                                button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                                cell!.contentView.addSubview(button!)
                            }
                        })
                        
                    } }else{
                    var x = 12
                    let pciInfo = pic[i-1]
                    if pciInfo.picture_url != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.picture_url)!
                        
                        //let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-7)*Int((WIDTH - 40)/3.0 + 10))
                                button = CustomBtn()
                                button?.flag = i
                                button!.frame = CGRectMake(CGFloat(x), height+(WIDTH - 40)/3.0 + 5+(WIDTH - 40)/3.0 + 5, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                                let imgTmp = UIImage(data: data!)
                                
                                button!.setImage(imgTmp, forState: .Normal)
                                if button?.imageView?.image == nil{
                                    button!.setImage(UIImage(named: "图片默认加载"), forState: .Normal)
                                }
                                button?.tag = indexPath.row
                                button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                                cell!.contentView.addSubview(button!)
                            }
                        })
                        
                    }
                    
                }
                
            }}
        if pic.count > 9 {
            image_h=(WIDTH - 40)/3.0*3 + 20
            for i in 1...pic.count{
                if i <= 3 {
                    var x = 12
                    let pciInfo = pic[i-1]
                    if pciInfo.picture_url != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.picture_url)!
                        
                        //let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-1)*Int((WIDTH - 40)/3.0 + 10))
                                print(x)
                                button = CustomBtn()
                                button?.flag = i
                                button!.frame = CGRectMake(CGFloat(x), height, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                                let imgTmp = UIImage(data: data!)
                                
                                button!.setImage(imgTmp, forState: .Normal)
                                if button?.imageView?.image == nil{
                                    button!.setImage(UIImage(named: "图片默认加载"), forState: .Normal)
                                }
                                button?.tag = indexPath.row
                                button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                                cell!.contentView.addSubview(button!)
                            }
                        })
                        
                    }}else if (i>3&&i<=6){
                    var x = 12
                    let pciInfo = pic[i-1]
                    if pciInfo.picture_url != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.picture_url)!
                        
                        //let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-4)*Int((WIDTH - 40)/3.0 + 10))
                                button = CustomBtn()
                                button?.flag = i
                                button!.frame = CGRectMake(CGFloat(x), height+(WIDTH - 40)/3.0 + 5, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                                let imgTmp = UIImage(data: data!)
                                
                                button!.setImage(imgTmp, forState: .Normal)
                                if button?.imageView?.image == nil{
                                    button!.setImage(UIImage(named: "图片默认加载"), forState: .Normal)
                                }
                                button?.tag = indexPath.row
                                button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                                cell!.contentView.addSubview(button!)
                            }
                        })
                        
                    } }else{
                    var x = 12
                    let pciInfo = pic[i-1]
                    if pciInfo.picture_url != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.picture_url)!
                        
                        //let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-7)*Int((WIDTH - 40)/3.0 + 10))
                                button = CustomBtn()
                                button?.flag = i
                                button!.frame = CGRectMake(CGFloat(x), height+(WIDTH - 40)/3.0 + 5+(WIDTH - 40)/3.0 + 5, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                                let imgTmp = UIImage(data: data!)
                                
                                button!.setImage(imgTmp, forState: .Normal)
                                if button?.imageView?.image == nil{
                                    button!.setImage(UIImage(named: "图片默认加载"), forState: .Normal)
                                }
                                button?.tag = indexPath.row
                                button?.addTarget(self, action: #selector(self.clickBtn(_:)), forControlEvents: .TouchUpInside)
                                cell!.contentView.addSubview(button!)
                            }
                        })
                        
                    }
                    
                }
                
            }}
        tableView.rowHeight = height + image_h + 60 + 120
        
        cell?.joinButton.frame = CGRectMake(10, height + image_h + 20, WIDTH - 20, 40)
        
        var answerInfo = NSString()
        for j in 0 ..< self.apply_countSource.activityList.count {
            answerInfo = self.apply_countSource.activityList[j].userid!
        }
        let userid = NSUserDefaults.standardUserDefaults()
        let uid = userid.stringForKey("userid")
        if answerInfo != uid {
            cell?.joinButton.setTitle("报名", forState: .Normal)
            cell?.joinButton.addTarget(self, action: #selector(self.GetBaoMing(_:)), forControlEvents: .TouchUpInside)
        }else{
            self.isCollect = true
            cell?.joinButton.setTitle("已报名", forState: .Normal)
        }
        
        if isCollect == false {
            cell?.joinButton.setTitle("报名", forState: .Normal)
    
        }else{
            cell?.joinButton.setTitle("已报名", forState: .Normal)
        }
        
        cell?.joinCountLabel.frame = CGRectMake(10, height + image_h + 80, WIDTH - 20, 20)
    
        cell?.joinCountLabel.text = "已报名\(self.apply_countSource.activityList.count + self.likeNum)"
        if activity_listModel.starttime == "0" {
            
        }else{
            cell?.contentView.addSubview((cell?.joinButton)!)
            cell?.contentView.addSubview((cell?.joinCountLabel)!)
        }
        
        return cell!
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func clickBtn(sender:CustomBtn){
        let activityInfo = self.activitySource
        let detailsVC = PicDetailViewController()
        
        detailsVC.activitySource = activityInfo
        detailsVC.activity_listSource = activity_listList(activityInfo.activity_list!)
        detailsVC.apply_countSource = apply_countList(activityInfo.apply_count!)
        detailsVC.picSource = picList(activityInfo.pic!)
        detailsVC.count = sender.flag!
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func GetBaoMing(btn:UIButton){
//        http://wxt.xiaocool.net/index.php?g=apps&m=student&a=ApplyActivity&userid=597&activityid=3&sex=1&age=5&fathername=大眼&contactphone=111
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=teacher&a=ApplyActivity"
        let userid = NSUserDefaults.standardUserDefaults()
        let uid = userid.stringForKey("userid")
        let param = [
            "activityid":id,
            "userid":uid
        ]
        Alamofire.request(.GET, url, parameters: param as? [String:String]).response { request, response, json, error in
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
                    hud.labelText = status.errorData
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                
                if(status.status == "success"){
                    //self.dianZanBtn.selected == true
                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.mode = MBProgressHUDMode.Text;
                    hud.labelText = "报名成功"
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                    //                    刷新
                    userid.setObject("true", forKey: "isCollect")
                    self.isCollect = true
                    self.likeNum = 1
                    self.tableView.reloadData()
                }
                
            }
            
        }
        

    }
    
    
}
