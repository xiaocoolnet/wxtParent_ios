//
//  GDMyViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/6/6.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import XWSwiftRefresh
import MBProgressHUD

class GDMyViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    var table = UITableView()
    var noticeSource = BabyPhotoList()
    
    var oldDate = " "
    var isLike:Bool = false
    var bview = UIView()
    var keyboardShowState = false
    var num = 0
    let contentTextView = UITextField()
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
        self.loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //   打开手势交互
        self.view.userInteractionEnabled = true
        
        self.bview = UIView()
        bview.backgroundColor = UIColor.lightGrayColor()
        bview.frame = CGRectMake(0, HEIGHT-HEIGHT/4-64-40-49 - 80, WIDTH, 80)
        self.view.addSubview(bview)
        //  初始化tableView
        self.createTable()
        //  刷新
        self.DropDownUpdate()
        //  获得数据
        self.loadData()
    }
    
        //    开始刷新
        func DropDownUpdate(){
            self.table.headerView = XWRefreshNormalHeader(target: self, action: #selector(YuanNoticeTableViewController.loadData))
            self.table.reloadData()
            self.oldDate = " "
            self.table.headerView?.beginRefreshing()
        } 
        func loadData(){
            //      http://wxt.xiaocool.net/index.php?g=apps&m=student&a=GetSelfGrow&studentid=597
            
            let defalutid = NSUserDefaults.standardUserDefaults()
            let studentid = defalutid.stringForKey("chid")
            let param = ["studentid":studentid]
            let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=GetSelfGrow"
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
                        hud.mode = MBProgressHUDMode.Text
                        hud.labelText = status.errorData
                        hud.margin = 10.0
                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 1)
                    }
                    if(status.status == "success"){
                        self.noticeSource = BabyPhotoList(status.data!)
                        
                        self.table.reloadData()
                    }
                    self.table.headerView?.endRefreshing()
                }
            }
        }
//    创建表
    func createTable(){
        table = UITableView(frame: CGRectMake(0, 0, WIDTH, HEIGHT-HEIGHT/4-64-40-49))
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = RGBA(242.0, g: 242.0, b: 242.0, a: 1)
        table.separatorStyle = .None
        self.view.addSubview(table)
//        table.registerNib(UINib.init(nibName: "DiaryTableViewCell", bundle: nil), forCellReuseIdentifier: "DiaryCell")
    
    }
//    行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return self.noticeSource.objectlist.count
    }
////    行高
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//
//        return 1000
//    }
//    单元格
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier:String(indexPath.row))
        cell.selectionStyle = .None
        cell.backgroundColor = RGBA(242.0, g: 242.0, b: 242.0, a: 1)
        
        let model = self.noticeSource.objectlist[indexPath.row]
        //  保存得到的日志
//        cell.fillCellWithModel(model)
        
        let time = UILabel()
        time.frame = CGRectMake(10, 20, 50, 20)
        time.font = timefont
//        time.textColor = neirongColor
        cell.contentView.addSubview(time)
        

        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        view.frame = CGRectMake(70, 20, WIDTH - 80, 500)
        cell.contentView.addSubview(view)
//        let heigh = view.frame.size.height
        let width = view.frame.size.width
        
        view.userInteractionEnabled = true
        
        let content = UILabel()
        content.frame = CGRectMake(10, 10, width - 20, 60)
        content.text = model.content
        content.textColor=neirongColor
        content.font=neirongfont
        content.numberOfLines = 0
        content.sizeToFit()
        view.addSubview(content)
        //        自适应行高
        let options : NSStringDrawingOptions = NSStringDrawingOptions.UsesLineFragmentOrigin
        let screenBounds:CGRect = UIScreen.mainScreen().bounds
        let boundingRect = String(content.text).boundingRectWithSize(CGSizeMake(screenBounds.width, 0), options: options, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(15)], context: nil)
        let height = boundingRect.size.height + 20
        
        //  图片
        var image_h = CGFloat()
        var button:CustomBtn?
        //判断图片张数显示
        
        let pic  = model.pic
        if(pic.count>0&&pic.count<=3){
            image_h=300
            if pic.count==1 {
                let pciInfo = pic[0]
                let imgUrl = microblogImageUrl+(pciInfo.pictureurl)!
                let avatarUrl = NSURL(string: imgUrl)
                let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                    if(data != nil){
                        
                        button = CustomBtn()
                        button?.flag = 1
                        button!.frame = CGRectMake(10, height, width - 20, 300)
                        let imgTmp = UIImage(data: data!)
                        
                        button!.setImage(imgTmp, forState: .Normal)
                        button?.imageView?.contentMode = .ScaleAspectFill
                        button?.clipsToBounds = true
                        if button?.imageView?.image == nil{
                            button?.setBackgroundImage(UIImage(named: "图片默认加载"), forState: .Normal)
                        }
                        button?.tag = indexPath.row
                        button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                        view.addSubview(button!)
                        
                    }
                })
                
            }else{
                image_h=(WIDTH - 40)/3.0
                for i in 1...pic.count{
                    var x = 12
                    let pciInfo = pic[i-1]
                    let imgUrl = microblogImageUrl+(pciInfo.pictureurl)!
                    let avatarUrl = NSURL(string: imgUrl)
                    let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                    
                    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                        if(data != nil){
                            x = x+((i-1)*Int((width - 40)/3.0 + 5))
                            button = CustomBtn()
                            button?.flag = i
                            button!.frame = CGRectMake(CGFloat(x), height, (width - 40)/3.0, (width - 40)/3.0)
                            let imgTmp = UIImage(data: data!)
                            
                            button!.setImage(imgTmp, forState: .Normal)
                            button?.imageView?.contentMode = .ScaleAspectFill
                            button?.clipsToBounds = true
                            if button?.imageView?.image == nil{
                                button?.setBackgroundImage(UIImage(named: "图片默认加载"), forState: .Normal)
                            }
                            button?.tag = indexPath.row
                            button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                            view.addSubview(button!)
                            
                        }
                    })
                }
            }
        }
        if(pic.count>3&&pic.count<=6){
            image_h=(width - 40)/3.0*2 + 10
            for i in 1...pic.count{
                if i <= 3 {
                    var x = 12
                    let pciInfo = pic[i-1]
                    if pciInfo.pictureurl != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.pictureurl)!
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-1)*Int((width - 40)/3.0 + 5))
                                button = CustomBtn()
                                button?.flag = i
                                button!.frame = CGRectMake(CGFloat(x), height, (width - 40)/3.0, (width - 40)/3.0)
                                let imgTmp = UIImage(data: data!)
                                button!.setImage(imgTmp, forState: .Normal)
                                button?.imageView?.contentMode = .ScaleAspectFill
                                button?.clipsToBounds = true
                                if button?.imageView?.image == nil{
                                    button!.setImage(UIImage(named: "Logo"), forState: .Normal)
                                }
                                button?.tag = indexPath.row
                                button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                                view.addSubview(button!)
                            }
                        })
                    }}else{
                    var x = 12
                    let pciInfo = pic[i-1]
                    if pciInfo.pictureurl != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.pictureurl)!
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-4)*Int((width - 40)/3.0 + 5))
                                button = CustomBtn()
                                button?.flag = i
                                button!.frame = CGRectMake(CGFloat(x), height+(width - 40)/3.0 + 5, (width - 40)/3.0, (width - 40)/3.0)
                                let imgTmp = UIImage(data: data!)
                                button!.setImage(imgTmp, forState: .Normal)
                                button?.imageView?.contentMode = .ScaleAspectFill
                                button?.clipsToBounds = true
                                if button?.imageView?.image == nil{
                                    button!.setImage(UIImage(named: "Logo"), forState: .Normal)
                                }
                                button?.tag = indexPath.row
                                button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                                view.addSubview(button!)
                            }
                        })
                        
                    }
                }
            }}
        if(pic.count>6&&pic.count<=9){
            image_h=(width - 40)/3.0*3+20
            for i in 1...pic.count{
                if i <= 3 {
                    var x = 12
                    let pciInfo = pic[i-1]
                    if pciInfo.pictureurl != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.pictureurl)!
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-1)*Int((width - 40)/3.0 + 5))
                                button = CustomBtn()
                                button?.flag = i
                                button!.frame = CGRectMake(CGFloat(x), height, (width - 40)/3.0, (width - 40)/3.0)
                                let imgTmp = UIImage(data: data!)
                                button!.setImage(imgTmp, forState: .Normal)
                                button?.imageView?.contentMode = .ScaleAspectFill
                                button?.clipsToBounds = true
                                if button?.imageView?.image == nil{
                                    button!.setImage(UIImage(named: "Logo"), forState: .Normal)
                                }
                                button?.tag = indexPath.row
                                button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                                view.addSubview(button!)
                            }
                        })
                        
                    }}else if (i>3&&i<=6){
                    var x = 12
                    let pciInfo = pic[i-1]
                    if pciInfo.pictureurl != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.pictureurl)!
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-4)*Int((width - 40)/3.0 + 5))
                                button = CustomBtn()
                                button?.flag = i
                                button!.frame = CGRectMake(CGFloat(x), height+(width - 40)/3.0 + 5, (width - 40)/3.0, (width - 40)/3.0)
                                let imgTmp = UIImage(data: data!)
                                
                                button!.setImage(imgTmp, forState: .Normal)
                                button?.imageView?.contentMode = .ScaleAspectFill
                                button?.clipsToBounds = true
                                if button?.imageView?.image == nil{
                                    button!.setImage(UIImage(named: "Logo"), forState: .Normal)
                                }
                                button?.tag = indexPath.row
                                button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                                view.addSubview(button!)
                            }
                        })
                        
                    } }else{
                    var x = 12
                    let pciInfo = pic[i-1]
                    if pciInfo.pictureurl != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.pictureurl)!
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-7)*Int((width - 40)/3.0 + 5))
                                button = CustomBtn()
                                button?.flag = i
                                button!.frame = CGRectMake(CGFloat(x), height+(width - 40)/3.0 + 5+(width - 40)/3.0 + 5, (width - 40)/3.0, (width - 40)/3.0)
                                let imgTmp = UIImage(data: data!)
                                button!.setImage(imgTmp, forState: .Normal)
                                button?.imageView?.contentMode = .ScaleAspectFill
                                button?.clipsToBounds = true
                                if button?.imageView?.image == nil{
                                    button!.setImage(UIImage(named: "Logo"), forState: .Normal)
                                }
                                button?.tag = indexPath.row
                                button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                                view.addSubview(button!)
                            }
                        })
                        
                    }
                    
                }
                
            }}
        
        
        let timeLable = UILabel()
        timeLable.frame = CGRectMake(10, height + image_h + 10, 120, 20)
        let dateformate = NSDateFormatter()
        dateformate.dateFormat = "MM-dd HH:mm"
        let date = NSDate(timeIntervalSince1970: NSTimeInterval(model.write_time)!)
        let str:String = dateformate.stringFromDate(date)
        timeLable.text = str
        timeLable.textColor = timeColor
        timeLable.font = timefont
        view.addSubview(timeLable)
        
        let string=(str as NSString).substringToIndex(5)
        
        let lable = UILabel()
        lable.frame = CGRectMake(10, 40, 50, 20)
        lable.backgroundColor = UIColor(red: 155/255, green: 229/255, blue: 180/255, alpha: 1)
        lable.textColor = UIColor.whiteColor()
        lable.font = timefont
        lable.textAlignment = NSTextAlignment.Center
        lable.layer.cornerRadius = 5
        lable.layer.masksToBounds = true
        cell.contentView.addSubview(lable)
        
        if oldDate != string {
            //  获取当前星期几
            let days = Int(Int(model.write_time)!/86400) // 24*60*60
            let weekday = ((days + 4)%7+7)%7
            weekday == 0 ? 7 : weekday
            if weekday == 1 {
                time.text = "星期一"
                lable.text = string
            }else if weekday == 2{
                time.text = "星期二"
                lable.text = string
            }else if weekday == 3{
                time.text = "星期三"
                lable.text = string
            }else if weekday == 4{
                time.text = "星期四"
                lable.text = string
            }else if weekday == 5{
                time.text = "星期五"
                lable.text = string
            }else if weekday == 6{
                time.text = "星期六"
                lable.text = string
            }else{
                time.text = "星期日"
                lable.text = string
            }
        }
//        oldDate = string
        
        let zanBtn = UIButton()
        zanBtn.frame = CGRectMake(width - 100, height + image_h + 10, 20, 20)
        zanBtn.setBackgroundImage(UIImage(named: "已点赞"), forState: .Normal)
        zanBtn.tag = indexPath.row
        zanBtn.addTarget(self, action: #selector(self.clickZan), forControlEvents: .TouchUpInside)
        view.addSubview(zanBtn)
        
        let pinglunBtn = UIButton()
        pinglunBtn.frame = CGRectMake(width - 40, height + image_h + 10, 20, 20)
        pinglunBtn.setBackgroundImage(UIImage(named: "评论"), forState: .Normal)
        pinglunBtn.tag = indexPath.row
        pinglunBtn.addTarget(self, action: #selector(self.pinglunBtn(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(pinglunBtn)
        
        let aview = UIView()
        if model.like.count != 0 {
            aview.frame = CGRectMake(0, height + image_h + 40, width, 30)
            view.addSubview(aview)
            let btn = UIButton()
            btn.frame = CGRectMake(10, 5, 20, 20)
            btn.setBackgroundImage(UIImage(named: "已点赞"), forState: .Normal)
            aview.addSubview(btn)
            let lable = UILabel()
            lable.frame = CGRectMake(40, 5, (WIDTH - 50), 20)
            lable.textColor = UIColor(red: 115/255.0, green: 229/255.0, blue: 180/255.0, alpha: 1.0)
            lable.font = UIFont.systemFontOfSize(14)
            aview.addSubview(lable)
            let arr = NSMutableArray()
            for i in 1...model.like.count {
                let str = model.like[i - 1].name
                //                lable.text = str
                arr.addObject(str)
            }
            
            let zanstr = arr.componentsJoinedByString("  ")
            lable.text = zanstr
            lable.numberOfLines = 0
            lable.sizeToFit()
            //        自适应行高
            let options : NSStringDrawingOptions = NSStringDrawingOptions.UsesLineFragmentOrigin
            let screenBounds:CGRect = UIScreen.mainScreen().bounds
            let boundingRect = String(lable.text).boundingRectWithSize(CGSizeMake(screenBounds.width, 0), options: options, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(15)], context: nil)
            let heigh = boundingRect.size.height + 5
            aview.frame = CGRectMake(0, height + image_h + 40, width, heigh)
        }
        
        var pingView = UIView()
        var h = CGFloat()
        if model.comment.count != 0 {
            for i in 1...model.comment.count {
                pingView = UIView()
                h = CGFloat( 60 * (i))
                pingView.frame = CGRectMake(0, height + image_h + 50 + aview.frame.size.height , width, h)
//                pingView.backgroundColor = RGBA(242.0, g: 242.0, b: 242.0, a: 1)
                view.addSubview(pingView)
                let name = UILabel()
                name.frame = CGRectMake(50, 5 + CGFloat( 60 * (i - 1)), 60, 20)
                name.text = model.comment[i - 1].name
                name.font = UIFont.systemFontOfSize(13)
                pingView.addSubview(name)
                
                let img = UIImageView()
                img.frame = CGRectMake(10, 5 + CGFloat( 60 * (i - 1)), 30, 30)
                let pict = model.comment[i - 1].avatar
                let imgUrl = microblogImageUrl + pict
                let photourl = NSURL(string: imgUrl)
                img.sd_setImageWithURL(photourl, placeholderImage: UIImage(named: "默认头像"))
                img.layer.cornerRadius = 15
                img.clipsToBounds = true
                pingView.addSubview(img)
                
                let dateformat = NSDateFormatter()
                dateformat.dateFormat = "yyyy-MM-dd HH:mm"
                let date = NSDate(timeIntervalSince1970: NSTimeInterval(model.comment[i - 1].comment_time)!)
                let st:String = dateformat.stringFromDate(date)
                let time = UILabel()
                time.frame = CGRectMake(110, 5 + CGFloat( 60 * (i - 1)), width - 130, 20)
                time.font = UIFont.systemFontOfSize(12)
                time.textAlignment = NSTextAlignment.Right
                time.text = st
                pingView.addSubview(time)
                
                let con = UILabel()
                con.frame = CGRectMake(50, 25 + CGFloat( 60 * (i - 1)), width - 50, 30)
                con.font = UIFont.systemFontOfSize(13)
                con.text = model.comment[i - 1].content
                con.numberOfLines = 0
                con.sizeToFit()
                pingView.addSubview(con)
            }
        }


        view.frame = CGRectMake(70, 20, WIDTH - 80, height + image_h + 45 + h + aview.frame.size.height)
        self.table.rowHeight = view.frame.size.height + 20
        
        return cell
    }
    
    
    // 点击图片跳转
    func clickBtn(sender:CustomBtn){
        let vc = ImagesViewController()
        vc.arrayInfo = self.noticeSource.objectlist[sender.tag].pic
        vc.nu = vc.arrayInfo.count
        vc.count = sender.flag
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = GDPLViewController()
        vc.dataSource = self.noticeSource.objectlist[indexPath.row]
        vc.num = indexPath.row
        vc.type = "7"
        vc.idtype = "2"
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //    点赞
    func clickZan(sender:UIButton){
        let user = NSUserDefaults.standardUserDefaults()
        let uid = user.stringForKey("userid")
        print(uid)
        let model = self.noticeSource.objectlist[sender.tag]
        
        let str = model.like
        var answerInfo = NSString()
        
        for j in 0 ..< str.count {
            answerInfo = str[j].userid
        }
        
        if answerInfo != uid {
            let url = "http://wxt.xiaocool.net/index.php?g=apps&m=school&a=SetLike"
            let param = [
                "id":model.mid,
                "userid":uid!,
                "type":"7"
            ]
            Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
                print(request)
                if(error != nil){
                    
                }else{
                    let status = Http(JSONDecoder(json!))
                    print("状态是")
                    print(status.status)
                    if(status.status == "error"){
                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        hud.mode = MBProgressHUDMode.Text
                        hud.labelText = status.errorData
                        hud.margin = 10.0
                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 1)
                    }
                    if(status.status == "success"){
                        
                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        hud.mode = MBProgressHUDMode.Text;
                        hud.labelText = "点赞成功"
                        hud.margin = 10.0
                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 1)
                        user.setObject("true", forKey: "isLike")
                        self.isLike=true
                        self.table.reloadData()
                        self.loadData()
                        
                    }
                }
            }
        }else{
            let url = "http://wxt.xiaocool.net/index.php?g=apps&m=school&a=ResetLike"
            let param = [
                "id":model.mid,
                "userid":uid!,
                "type":"7"
            ]
            Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
                print(request)
                if(error != nil){
                    
                }else{
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
                        
                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        hud.mode = MBProgressHUDMode.Text;
                        hud.labelText = "取消点赞成功"
                        hud.margin = 10.0
                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 1)
                        print(status.data)
                        self.isLike=false
                        user.setObject("false", forKey: "isLike")
                        self.table.reloadData()
                        self.loadData()
                    }
                }
                
            }
            
        }
        
    }

    // 评论
    func pinglunBtn(sender:UIButton) {
        
        //            bview.frame.origin.y = 50
        
        bview.bringSubviewToFront(table)
        table.frame = CGRectMake(0, 0, WIDTH, HEIGHT-HEIGHT/4-64-40-49 - 80)
        contentTextView.frame = CGRectMake(20 , 20, WIDTH - 40, 40)
        contentTextView.borderStyle = UITextBorderStyle.RoundedRect
        contentTextView.placeholder = "评论"
        contentTextView.returnKeyType = UIReturnKeyType.Send
        contentTextView.delegate = self
        bview.addSubview(contentTextView)
        
        print(1111)
        
        self.num = sender.tag
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MyPhotoViewController.keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardDidAppear), name: UIKeyboardDidShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MyPhotoViewController.keyboardWillDisappear(_:)), name:UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func keyboardWillAppear(notification: NSNotification) {
        
        // 获取键盘信息
        let keyboardinfo = notification.userInfo![UIKeyboardFrameEndUserInfoKey]
        
        let keyboardheight:CGFloat = (keyboardinfo?.CGRectValue.size.height)!
        
        self.bview.frame = CGRectMake(0, HEIGHT-HEIGHT/4-64-49 - 70 - keyboardheight , WIDTH, 80)
        self.table.frame = CGRectMake(0, 0, WIDTH, HEIGHT-HEIGHT/4-64-49 - 70 - keyboardheight)
        
        print("键盘弹起")
        print(keyboardheight)
        
    }
    
    func keyboardDidAppear(notification:NSNotification) {
        keyboardShowState = true
    }
    
    func keyboardWillDisappear(notification:NSNotification){
        UIView.animateWithDuration(0.3) {
            //            self.contentTableView.contentOffset = CGPoint.init(x: 0, y: self.contentTableView.contentSize.height-self.contentTableView.frame.size.height)
            self.bview.frame = CGRectMake(0, HEIGHT-HEIGHT/4-64-40-49 - 80, WIDTH, 80)
            //                self.bview.hidden = true
            self.table.frame = CGRectMake(0, 0, self.view.frame.size.width, HEIGHT-HEIGHT/4-64-40-49)
        }
        print("键盘落下")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let chid = NSUserDefaults.standardUserDefaults()
        let userid = chid.stringForKey("userid")
        
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=school&a=SetComment"
        let param = [
            "userid":userid!,
            "id":self.noticeSource.objectlist[self.num].mid,
            "type":"7",
            "content":self.contentTextView.text!,
            ]
        Alamofire.request(.POST, url, parameters: param).response { request, response, json, error in
            if(error != nil){
            }
            else{
                print("request是")
                print(request!)
                print("====================")
                let result = Httpresult(JSONDecoder(json!))
                print("状态是")
                print(result.status)
                if(result.status == "error"){
                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.mode = MBProgressHUDMode.Text
                    hud.labelText = result.errorData
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                if(result.status == "success"){
                    print("Success")
                    textField.text = ""
                    self.table.frame = CGRectMake(0, 0, self.view.frame.size.width, HEIGHT-HEIGHT/4-64-40-49)
                    self.loadData()
                }
                
            }
            
        }
        
        textField.resignFirstResponder()
        return true
        
    }
    
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if keyboardShowState == true {
            self.view.endEditing(true)
            keyboardShowState = false
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.table.frame = CGRectMake(0, 0, self.view.frame.size.width, HEIGHT-HEIGHT/4-64-40-49)
        contentTextView.text = ""
    }

}

