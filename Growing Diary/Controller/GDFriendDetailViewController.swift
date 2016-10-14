//
//  GDFriendDetailViewController.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/8/17.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import YYWebImage
import XWSwiftRefresh
import MBProgressHUD

class GDFriendDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    let tableView = UITableView()
    var noticeSource = QCBabyFriendList()

    var zanBtn = UIButton()
    var isLike:Bool = false
    var bview = UIView()
    var keyboardShowState = false
    var num = 0
    let contentTextView = UITextField()
    
    var type = String()
    
    var arr = [[String:Any]]()
    
    
    
    override func viewDidAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createTable()
        self.DropDownUpdate()
        self.view.backgroundColor = UIColor.lightGrayColor()
        
        self.bview = UIView()
        bview.backgroundColor = UIColor.lightGrayColor()
        bview.frame = CGRectMake(0, HEIGHT - 140, WIDTH, 80)
        
        self.view.addSubview(bview)
        
        
        contentTextView.frame = CGRectMake(20 , 20, WIDTH - 40, 40)
        contentTextView.borderStyle = UITextBorderStyle.RoundedRect
        contentTextView.placeholder = "评论"
        contentTextView.returnKeyType = UIReturnKeyType.Send
        contentTextView.delegate = self
        bview.addSubview(contentTextView)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MyPhotoViewController.keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardDidAppear), name: UIKeyboardDidShowNotification, object: nil)
//
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MyPhotoViewController.keyboardWillDisappear(_:)), name:UIKeyboardWillHideNotification, object: nil)
        
        self.title = "评论"
        
        self.loadData()
    }
    //    刷新
    func DropDownUpdate(){
        self.tableView.headerView = XWRefreshNormalHeader(target: self, action: #selector(BlogDetailViewController.loadData))
        //self.sourceList.reloadData()
        self.tableView.reloadData()
        self.tableView.headerView?.beginRefreshing()
    }
    //    创建表
    func createTable(){
        tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 140)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        self.view.addSubview(tableView)
        tableView.backgroundColor = UIColor.whiteColor()
        
    }
    
    func loadData(){
        //      http://wxt.xiaocool.net/index.php?g=apps&m=student&a=GetFriendsGrow&studentid=597
        
        let defalutid = NSUserDefaults.standardUserDefaults()
        let studentid = defalutid.stringForKey("chid")
        let param = ["studentid":studentid]
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=GetFriendsGrow"
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
                    self.noticeSource = QCBabyFriendList(status.data!)
                    
                    
                    self.arr = [[String:Any]]()
                    for i in 0...self.noticeSource.objectlist.count - 1{
                        var dic = Dictionary<String, Any>()
                        let strName = self.noticeSource.objectlist[i].name
                        let strPhoto = self.noticeSource.objectlist[i].photo
                        dic["strPhoto"] = strPhoto
                        dic["strName"] = strName
                        let mic = self.noticeSource.objectlist[i].microblog_info
                        if mic.count != 0{
                            for j in 0...mic.count - 1{
                                let content = mic[j].content
                                let pic = mic[j].pic
                                let write_time = mic[j].write_time
                                let like = mic[j].like
                                let comment = mic[j].comment
                                let mid  = mic[j].mid
                                dic["content"] = content
                                dic["pic"] = pic
                                dic["write_time"] = write_time
                                dic["like"] = like
                                dic["comment"] = comment
                                dic["mid"] = mid
                                self.arr.append(dic)
                            }
                        }
                    }
                    
                    if self.arr.count > 1 {
                        
                        self.arr = self.arr.sort({ (n2: Dictionary, n1: Dictionary) -> Bool in
                            //进行从小到大的排序
                            return n2["write_time"] as! String > n1["write_time"] as! String
                        })
                    }
                    self.tableView.reloadData()
                    self.tableView.headerView?.endRefreshing()
                }
            }
        }
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arr.count == 0 {
            return 0
        }else{
            
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier:String(indexPath.row))
        cell.selectionStyle = .None
        
        let model = self.arr[num]
        
        let photo = UIImageView()
        photo.frame = CGRectMake(10, 15, 40, 40)
        let pi = model["strPhoto"] as! String
        let imgUrl = microblogImageUrl + pi
        let photourl = NSURL(string: imgUrl)
        photo.sd_setImageWithURL(photourl, placeholderImage: UIImage(named: "Logo"))
        cell.contentView.addSubview(photo)
        
        let nameLab = UILabel()
        nameLab.frame = CGRectMake(60, 10, WIDTH - 70, 20)
        nameLab.text = model["strName"] as? String
        nameLab.textColor = UIColor(red: 155/255, green: 229/255, blue: 180/255, alpha: 1)
        cell.contentView.addSubview(nameLab)
        
        
        
        let contentlbl = UILabel()
        contentlbl.frame = CGRectMake(10, 80, WIDTH - 20, 20)
        contentlbl.text = model["content"] as? String
        contentlbl.numberOfLines = 0
        contentlbl.sizeToFit()
        cell.contentView.addSubview(contentlbl)
        //        自适应行高
        let options : NSStringDrawingOptions = NSStringDrawingOptions.UsesLineFragmentOrigin
        let screenBounds:CGRect = UIScreen.mainScreen().bounds
        let boundingRect = String(contentlbl.text).boundingRectWithSize(CGSizeMake(screenBounds.width, 0), options: options, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(17)], context: nil)
        let height = boundingRect.size.height + 80
        
        
        //  图片
        var image_h = CGFloat()
        var button:CustomBtn?
        //判断图片张数显示
        
        //判断图片张数显示
        let pic = model["pic"] as! Array<BabyFriendPicInfo>
        
        if(pic.count>0&&pic.count<=3){
            image_h=(WIDTH - 40)/3.0
            for i in 1...pic.count{
                var x = 12
                let pciInfo = pic[i-1]
                let imgUrl = microblogImageUrl+(pciInfo.pictureurl)
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
                            button?.setBackgroundImage(UIImage(named: "Logo"), forState: .Normal)
                        }
                        button?.tag = indexPath.row
                        button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                        cell.contentView.addSubview(button!)
                        
                    }
                })
                
            }
        }
        if(pic.count>3&&pic.count<=6){
            image_h=(WIDTH - 40)/3.0*2 + 10
            for i in 1...pic.count{
                if i <= 3 {
                    var x = 12
                    let pciInfo = pic[i-1]
                    if pciInfo.pictureurl != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.pictureurl)
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
                                    button!.setImage(UIImage(named: "Logo"), forState: .Normal)
                                }
                                button?.tag = indexPath.row
                                button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                                cell.contentView.addSubview(button!)
                            }
                        })
                    }}else{
                    var x = 12
                    let pciInfo = pic[i-1]
                    if pciInfo.pictureurl != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.pictureurl)
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
                                button?.imageView?.contentMode = .ScaleAspectFill
                                button?.clipsToBounds = true
                                if button?.imageView?.image == nil{
                                    button!.setImage(UIImage(named: "Logo"), forState: .Normal)
                                }
                                button?.tag = indexPath.row
                                button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                                cell.contentView.addSubview(button!)
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
                    if pciInfo.pictureurl != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.pictureurl)
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
                                    button!.setImage(UIImage(named: "Logo"), forState: .Normal)
                                }
                                button?.tag = indexPath.row
                                button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                                cell.contentView.addSubview(button!)
                            }
                        })
                        
                    }}else if (i>3&&i<=6){
                    var x = 12
                    let pciInfo = pic[i-1]
                    if pciInfo.pictureurl != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.pictureurl)
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
                                button?.imageView?.contentMode = .ScaleAspectFill
                                button?.clipsToBounds = true
                                if button?.imageView?.image == nil{
                                    button!.setImage(UIImage(named: "Logo"), forState: .Normal)
                                }
                                button?.tag = indexPath.row
                                button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                                cell.contentView.addSubview(button!)
                            }
                        })
                        
                    } }else{
                    var x = 12
                    let pciInfo = pic[i-1]
                    if pciInfo.pictureurl != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.pictureurl)
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
                                button?.imageView?.contentMode = .ScaleAspectFill
                                button?.clipsToBounds = true
                                if button?.imageView?.image == nil{
                                    button!.setImage(UIImage(named: "Logo"), forState: .Normal)
                                }
                                button?.tag = indexPath.row
                                button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                                cell.contentView.addSubview(button!)
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
                    if pciInfo.pictureurl != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.pictureurl)
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
                                button?.imageView?.contentMode = .ScaleAspectFill
                                button?.clipsToBounds = true
                                if button?.imageView?.image == nil{
                                    button!.setImage(UIImage(named: "Logo"), forState: .Normal)
                                }
                                button?.tag = indexPath.row
                                button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                                cell.contentView.addSubview(button!)
                            }
                        })
                        
                    }}else if (i>3&&i<=6){
                    var x = 12
                    let pciInfo = pic[i-1]
                    if pciInfo.pictureurl != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.pictureurl)
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
                                button?.imageView?.contentMode = .ScaleAspectFill
                                button?.clipsToBounds = true
                                if button?.imageView?.image == nil{
                                    button!.setImage(UIImage(named: "Logo"), forState: .Normal)
                                }
                                button?.tag = indexPath.row
                                button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                                cell.contentView.addSubview(button!)
                            }
                        })
                        
                    } }else{
                    var x = 12
                    let pciInfo = pic[i-1]
                    if pciInfo.pictureurl != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.pictureurl)
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
                                button?.imageView?.contentMode = .ScaleAspectFill
                                button?.clipsToBounds = true
                                if button?.imageView?.image == nil{
                                    button!.setImage(UIImage(named: "Logo"), forState: .Normal)
                                }
                                button?.tag = indexPath.row
                                button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                                cell.contentView.addSubview(button!)
                            }
                        })
                        
                    }
                    
                }
                
            }}
        
        
        
        let dateformate = NSDateFormatter()
        dateformate.dateFormat = "yyyy-MM-dd HH:mm"
        let date = NSDate(timeIntervalSince1970: NSTimeInterval((model["write_time"] as? String)!)!)
        let str:String = dateformate.stringFromDate(date)
        let timeLbl = UILabel()
        timeLbl.frame = CGRectMake(60, 40, WIDTH - 70, 20)
        timeLbl.text = str
        timeLbl.font = UIFont.systemFontOfSize(16)
        timeLbl.textColor = UIColor.lightGrayColor()
        //        timeLbl.textAlignment = NSTextAlignment.Right
        cell.contentView.addSubview(timeLbl)
        
        let line = UILabel()
        line.frame = CGRectMake(1, height + image_h + 39.5, WIDTH - 2, 0.5)
        line.backgroundColor = UIColor.lightGrayColor()
        cell.contentView.addSubview(line)
        
        self.zanBtn = UIButton()
        zanBtn.frame = CGRectMake(WIDTH - 100, height + image_h + 10, 20, 20)
        zanBtn.setBackgroundImage(UIImage(named: "已点赞"), forState: .Normal)
        zanBtn.tag = indexPath.row
        zanBtn.addTarget(self, action: #selector(self.clickZan), forControlEvents: .TouchUpInside)
        cell.contentView.addSubview(zanBtn)
        
        let pinglunBtn = UIButton()
        pinglunBtn.frame = CGRectMake(WIDTH - 40, height + image_h + 10, 20, 20)
        pinglunBtn.setBackgroundImage(UIImage(named: "评论"), forState: .Normal)
        pinglunBtn.tag = indexPath.row
        pinglunBtn.addTarget(self, action: #selector(self.pinglunBtn(_:)), forControlEvents: .TouchUpInside)
        cell.contentView.addSubview(pinglunBtn)
        
        let view = UIView()
        let likes = model["like"] as! Array<BabyFriendLikeInfo>
        if likes.count != 0 {
            view.frame = CGRectMake(10, height + image_h + 50, WIDTH - 20, 30)
            cell.contentView.addSubview(view)
            let btn = UIButton()
            btn.frame = CGRectMake(10, 5, 20, 20)
            btn.setBackgroundImage(UIImage(named: "已点赞"), forState: .Normal)
            view.addSubview(btn)
            for i in 1...likes.count {
                let str = likes[i - 1].name
                let lable = UILabel()
                var x = 40
                x = x+((i-1)*Int((WIDTH - 40)/4 + 5))
                lable.frame = CGRectMake(CGFloat(x), 5, (WIDTH - 50)/4, 20)
                lable.text = str
                lable.textColor = UIColor(red: 115/255.0, green: 229/255.0, blue: 180/255.0, alpha: 1.0)
                lable.font = UIFont.systemFontOfSize(15)
                view.addSubview(lable)
            }
        }
        
        var pingView = UIView()
        var h = CGFloat()
        let comments = model["comment"] as! Array<BabyFriendCommentInfo>
        if comments.count != 0 {
            for i in 1...comments.count {
                pingView = UIView()
                h = CGFloat( 50 * (i))
                pingView.frame = CGRectMake(10, height + image_h + 70 + view.frame.size.height , WIDTH - 20, h)
                cell.contentView.addSubview(pingView)
                let name = UILabel()
                name.frame = CGRectMake(50, 5 + CGFloat( 50 * (i - 1)), 60, 20)
                name.text = comments[i - 1].name
                name.font = UIFont.systemFontOfSize(15)
                pingView.addSubview(name)
                
                let img = UIImageView()
                img.frame = CGRectMake(10, 5 + CGFloat( 50 * (i - 1)), 30, 30)
                let pict = comments[i - 1].avatar
                let imgUrl = microblogImageUrl + pict
                let photourl = NSURL(string: imgUrl)
                img.sd_setImageWithURL(photourl, placeholderImage: UIImage(named: "Logo"))
                pingView.addSubview(img)
                
                let dateformat = NSDateFormatter()
                dateformat.dateFormat = "yyyy-MM-dd HH:mm"
                let date = NSDate(timeIntervalSince1970: NSTimeInterval(comments[i - 1].comment_time)!)
                let st:String = dateformat.stringFromDate(date)
                let time = UILabel()
                time.frame = CGRectMake(110, 5 + CGFloat( 50 * (i - 1)), WIDTH - 130, 20)
                time.font = UIFont.systemFontOfSize(15)
                time.textAlignment = NSTextAlignment.Right
                time.text = st
                pingView.addSubview(time)
                
                let con = UILabel()
                con.frame = CGRectMake(50, 25 + CGFloat( 50 * (i - 1)), WIDTH - 50, 20)
                con.font = UIFont.systemFontOfSize(15)
                con.text = comments[i - 1].content
                con.numberOfLines = 0
                con.sizeToFit()
                pingView.addSubview(con)
            }
        }
        
        tableView.rowHeight =  height + image_h + view.frame.size.height + pingView.frame.size.height + 70 + h + 20
        
        
        return cell
    }
    
    // 点击图片跳转
    func clickBtn(sender:CustomBtn){
        let vc = GDPicViewController()
        let arrayInf = self.arr[sender.tag]
        vc.arrayInfo = arrayInf["pic"] as! Array<BabyFriendPicInfo>
        vc.nu = vc.arrayInfo.count
        vc.count = sender.flag!
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //    点赞
    func clickZan(sender:UIButton){
        let user = NSUserDefaults.standardUserDefaults()
        let uid = user.stringForKey("userid")
        print(uid)
        let mode = self.arr[sender.tag]
        let model = mode["mid"] as! String
        
        
        let str = mode["like"] as! Array<BabyFriendLikeInfo>
        //        let strr = str[sender.tag]
        
        var answerInfo = NSString()
        
        for j in 0 ..< str.count {
            answerInfo = str[j].userid
        }
        
        if answerInfo != uid {
            let url = "http://wxt.xiaocool.net/index.php?g=apps&m=school&a=SetLike"
            let param = [
                "id":model,
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
                        let hud = MBProgressHUD.showHUDAddedTo(UIApplication.sharedApplication().keyWindow, animated: true)
                        hud.mode = MBProgressHUDMode.Text
                        hud.labelText = status.errorData
                        hud.margin = 10.0
                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 1)
                    }
                    if(status.status == "success"){
                        
                        let hud = MBProgressHUD.showHUDAddedTo(UIApplication.sharedApplication().keyWindow, animated: true)
                        hud.mode = MBProgressHUDMode.Text;
                        hud.labelText = "点赞成功"
                        hud.margin = 10.0
                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 1)
                        user.setObject("true", forKey: "isLike")
                        self.isLike=true
                        //                        let dic = ["name",user.stringForKey("name")]
                        //
                        self.tableView.reloadData()
                        //                        self.table = UITableView()
                        self.loadData()
                        
                    }
                }
            }
        }else{
            let url = "http://wxt.xiaocool.net/index.php?g=apps&m=school&a=ResetLike"
            let param = [
                "id":model,
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
                        self.tableView.reloadData()
                        self.loadData()
                    }
                }
                
            }
            
        }
        
    }
    
    // 评论
    func pinglunBtn(sender:UIButton) {
        
        
        contentTextView.borderStyle = UITextBorderStyle.RoundedRect
        contentTextView.returnKeyType = UIReturnKeyType.Send
        
        self.num = sender.tag
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MyPhotoViewController.keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardDidAppear), name: UIKeyboardDidShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MyPhotoViewController.keyboardWillDisappear(_:)), name:UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func keyboardWillAppear(notification: NSNotification) {
        
        // 获取键盘信息
        let keyboardinfo = notification.userInfo![UIKeyboardFrameEndUserInfoKey]
        
        let keyboardheight:CGFloat = (keyboardinfo?.CGRectValue.size.height)!
        
        UIView.animateWithDuration(0.3) {
            
            self.bview.frame = CGRectMake(0, HEIGHT - keyboardheight - 145, WIDTH, 80)
            self.tableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT - keyboardheight - 145)
        }
        
        print("键盘弹起")
        print(keyboardheight)
        
    }
    
    func keyboardDidAppear(notification:NSNotification) {
        keyboardShowState = true
    }
    
    func keyboardWillDisappear(notification:NSNotification){
        UIView.animateWithDuration(0.3) {
            //            self.contentTableView.contentOffset = CGPoint.init(x: 0, y: self.contentTableView.contentSize.height-self.contentTableView.frame.size.height)
            self.bview.frame = CGRectMake(0, HEIGHT - 140, WIDTH, 80)
            self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 80)
        }
        print("键盘落下")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let chid = NSUserDefaults.standardUserDefaults()
        let userid = chid.stringForKey("userid")
        
        let mode = self.arr[self.num]
        let model = mode["mid"] as! String
        
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=school&a=SetComment"
        let param = [
            "userid":userid!,
            "id":model,
            "type":"7",
            "content":self.contentTextView.text!,
            ]

        Alamofire.request(.POST, url, parameters: param ).response { request, response, json, error in
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
                    self.loadData()
                    self.tableView.reloadData()
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


}
