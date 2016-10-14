//
//  ClassViewController.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/2/18.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import YYWebImage
import XWSwiftRefresh
import MBProgressHUD

class ClassViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate{

    let table = UITableView()
    var dataSource = BabyPhotoList()
    var zanBtn = UIButton()
    var isLike:Bool = false
    var bview = UIView()
    var keyboardShowState = false
    var num = 0
    let contentTextView = UITextField()
    
    
    override func viewWillAppear(animated: Bool) {
        self.loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bview = UIView()
        bview.backgroundColor = UIColor.lightGrayColor()
        bview.frame = CGRectMake(0, HEIGHT - 180, WIDTH, 80)
        self.view.addSubview(bview)
        self.createTable()
        self.DropDownUpdate()
    }
    //    刷新
    func DropDownUpdate(){
        self.table.headerView = XWRefreshNormalHeader(target: self, action: #selector(MyPhotoViewController.loadData))
        //self.sourceList.reloadData()
        self.table.reloadData()
        self.table.headerView?.beginRefreshing()
    }
    //    创建表
    func createTable(){
        table.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-40 - 64)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .None
        self.view.addSubview(table)
        
        //        table.registerNib(UINib.init(nibName: "PhotoTableViewCell", bundle: nil), forCellReuseIdentifier: "PhotoCellID")
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
            "type":"2"
        ]
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
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
                    self.dataSource = BabyPhotoList(status.data!)
                    self.table.reloadData()
                }
            }
            
        }
        self.table.headerView?.endRefreshing()
    }
    //    行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.objectlist.count
    }
    //    单元格
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCellID", forIndexPath: indexPath)
        //            as! PhotoTableViewCell
        let cell = UITableViewCell(style: .Default, reuseIdentifier:String(indexPath.row))
        cell.selectionStyle = .None
        let model = self.dataSource.objectlist[indexPath.row]
        
        let photo = UIImageView()
        photo.frame = CGRectMake(10, 10, 60, 60)
        let pi = model.photo
        let imgUrl = microblogImageUrl + pi
        let photourl = NSURL(string: imgUrl)
        photo.layer.cornerRadius = 30
        photo.clipsToBounds = true
        photo.sd_setImageWithURL(photourl, placeholderImage: UIImage(named: "Logo"))
        cell.contentView.addSubview(photo)
        
        let nameLab = UILabel()
        nameLab.frame = CGRectMake(80, 15, WIDTH - 70, 20)
        nameLab.text = model.name
        nameLab.textColor = UIColor(red: 155/255, green: 229/255, blue: 180/255, alpha: 1)
        cell.contentView.addSubview(nameLab)
        
        let dateformat = NSDateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd"
        let dat = NSDate(timeIntervalSince1970: NSTimeInterval(model.write_time)!)
        let st:String = dateformat.stringFromDate(dat)
        let timeLb = UILabel()
        timeLb.frame = CGRectMake(80, 45, WIDTH - 70, 20)
        timeLb.text = st
        timeLb.font = UIFont.systemFontOfSize(16)
        timeLb.textColor = UIColor.lightGrayColor()
        cell.contentView.addSubview(timeLb)

        
        // 内容
        let contentlbl = UILabel()
        contentlbl.frame = CGRectMake(10, 90, WIDTH - 20, 20)
        contentlbl.text = model.content
        contentlbl.numberOfLines = 0
        contentlbl.sizeToFit()
        cell.contentView.addSubview(contentlbl)
        //        自适应行高
        let options : NSStringDrawingOptions = NSStringDrawingOptions.UsesLineFragmentOrigin
        let screenBounds:CGRect = UIScreen.mainScreen().bounds
        let boundingRect = String(contentlbl.text).boundingRectWithSize(CGSizeMake(screenBounds.width, 0), options: options, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(17)], context: nil)
        let height = boundingRect.size.height + 20 + 80
        
        
        //  图片
        var image_h = CGFloat()
        var button:CustomBtn?
        //判断图片张数显示
        
        let pic  = model.pic
        
        if(pic.count>0&&pic.count<=3){
            image_h=(WIDTH - 40)/3.0
            for i in 1...pic.count{
                var x = 12
                let pciInfo = pic[i-1]
                let imgUrl = microblogImageUrl+(pciInfo.pictureurl)!
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
                        let imgUrl = microblogImageUrl+(pciInfo.pictureurl)!
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
                                    button!.setImage(UIImage(named: "图片默认加载"), forState: .Normal)
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
                        let imgUrl = microblogImageUrl+(pciInfo.pictureurl)!
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
                                    button!.setImage(UIImage(named: "图片默认加载"), forState: .Normal)
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
                        let imgUrl = microblogImageUrl+(pciInfo.pictureurl)!
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
                                    button!.setImage(UIImage(named: "图片默认加载"), forState: .Normal)
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
                        let imgUrl = microblogImageUrl+(pciInfo.pictureurl)!
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
                                    button!.setImage(UIImage(named: "图片默认加载"), forState: .Normal)
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
                        let imgUrl = microblogImageUrl+(pciInfo.pictureurl)!
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
                                    button!.setImage(UIImage(named: "图片默认加载"), forState: .Normal)
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
                        let imgUrl = microblogImageUrl+(pciInfo.pictureurl)!
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
                                    button!.setImage(UIImage(named: "图片默认加载"), forState: .Normal)
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
                        let imgUrl = microblogImageUrl+(pciInfo.pictureurl)!
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
                                    button!.setImage(UIImage(named: "图片默认加载"), forState: .Normal)
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
                        let imgUrl = microblogImageUrl+(pciInfo.pictureurl)!
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
                                    button!.setImage(UIImage(named: "图片默认加载"), forState: .Normal)
                                }
                                button?.tag = indexPath.row
                                button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                                cell.contentView.addSubview(button!)
                            }
                        })
                        
                    }
                    
                }
                
            }}
        
        let img = UIImageView()
        img.frame = CGRectMake(10, height + image_h + 10, 20, 20)
        img.image = UIImage(named: "ic_fasong")
        cell.contentView.addSubview(img)
        let senderLbl = UILabel()
        senderLbl.frame = CGRectMake(40, height + image_h + 10, 120, 20)
        senderLbl.font = UIFont.systemFontOfSize(16)
        senderLbl.text = "发自 \(model.name)"
        senderLbl.textColor = UIColor.lightGrayColor()
        cell.contentView.addSubview(senderLbl)
        
        let dateformate = NSDateFormatter()
        dateformate.dateFormat = "yyyy-MM-dd HH:mm"
        let date = NSDate(timeIntervalSince1970: NSTimeInterval(model.write_time)!)
        let str:String = dateformate.stringFromDate(date)
        let timeLbl = UILabel()
        timeLbl.frame = CGRectMake(160, height + image_h + 10, WIDTH - 170, 20)
        timeLbl.text = str
        timeLbl.font = UIFont.systemFontOfSize(16)
        timeLbl.textColor = UIColor.lightGrayColor()
        timeLbl.textAlignment = NSTextAlignment.Right
        cell.contentView.addSubview(timeLbl)
        
        let line = UILabel()
        line.frame = CGRectMake(1, height + image_h + 39.5, WIDTH - 2, 0.5)
        line.backgroundColor = UIColor.lightGrayColor()
        cell.contentView.addSubview(line)
        
        self.zanBtn = UIButton()
        zanBtn.frame = CGRectMake(WIDTH - 100, height + image_h + 50, 20, 20)
        zanBtn.setBackgroundImage(UIImage(named: "已点赞"), forState: .Normal)
        zanBtn.tag = indexPath.row
        zanBtn.addTarget(self, action: #selector(self.clickZan), forControlEvents: .TouchUpInside)
        cell.contentView.addSubview(zanBtn)
        
        let pinglunBtn = UIButton()
        pinglunBtn.frame = CGRectMake(WIDTH - 40, height + image_h + 50, 20, 20)
        pinglunBtn.setBackgroundImage(UIImage(named: "评论"), forState: .Normal)
        pinglunBtn.tag = indexPath.row
        pinglunBtn.addTarget(self, action: #selector(self.pinglunBtn(_:)), forControlEvents: .TouchUpInside)
        cell.contentView.addSubview(pinglunBtn)
        
        let view = UIView()
        if model.like.count != 0 {
            view.frame = CGRectMake(10, height + image_h + 80, WIDTH - 20, 30)
            cell.contentView.addSubview(view)
            let btn = UIButton()
            btn.frame = CGRectMake(10, 5, 20, 20)
            btn.setBackgroundImage(UIImage(named: "已点赞"), forState: .Normal)
            view.addSubview(btn)
            for i in 1...model.like.count {
                let str = model.like[i - 1].name
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
        if model.comment.count != 0 {
            for i in 1...model.comment.count {
                pingView = UIView()
                h = CGFloat( 50 * (i))
                pingView.frame = CGRectMake(10, height + image_h + 90 + view.frame.size.height , WIDTH - 20, h)
//                pingView.backgroundColor = UIColor.lightGrayColor()
                cell.contentView.addSubview(pingView)
                let name = UILabel()
                name.frame = CGRectMake(50, 5 + CGFloat( 50 * (i - 1)), 60, 20)
                name.text = model.comment[i - 1].name
                name.font = UIFont.systemFontOfSize(15)
                pingView.addSubview(name)
                
                let img = UIImageView()
                img.frame = CGRectMake(10, 5 + CGFloat( 50 * (i - 1)), 30, 30)
                let pict = model.comment[i - 1].avatar
                let imgUrl = microblogImageUrl + pict
                let photourl = NSURL(string: imgUrl)
                img.sd_setImageWithURL(photourl, placeholderImage: UIImage(named: "Logo"))
                pingView.addSubview(img)
                
                let dateformat = NSDateFormatter()
                dateformat.dateFormat = "yyyy-MM-dd HH:mm"
                let date = NSDate(timeIntervalSince1970: NSTimeInterval(model.comment[i - 1].comment_time)!)
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
                con.text = model.comment[i - 1].content
                con.numberOfLines = 0
                con.sizeToFit()
                pingView.addSubview(con)
            }
        }
        
        let aview = UIView()
        aview.frame = CGRectMake(0, height + image_h + 90 + view.frame.size.height + h, WIDTH, 10)
        aview.backgroundColor = RGBA(242.0, g: 242.0, b: 242.0, a: 1)
        cell.contentView.addSubview(aview)
        
        tableView.rowHeight = height + image_h + 100 + view.frame.size.height + h
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = MyPhotoDetailViewController()
        vc.dataSource = self.dataSource.objectlist[indexPath.row]
        vc.num = indexPath.row
        vc.type = "2"
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    // 点击图片跳转
    func clickBtn(sender:CustomBtn){
        let vc = ImagesViewController()
        vc.arrayInfo = self.dataSource.objectlist[sender.tag].pic
        vc.nu = vc.arrayInfo.count
        vc.count = sender.flag
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //    点赞
    func clickZan(sender:UIButton){
        let user = NSUserDefaults.standardUserDefaults()
        let uid = user.stringForKey("userid")
        print(uid)
        let model = self.dataSource.objectlist[sender.tag]
        
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
                "type":"2"
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
                        self.loadData()
                        
                    }
                }
            }
        }else{
            let url = "http://wxt.xiaocool.net/index.php?g=apps&m=school&a=ResetLike"
            let param = [
                "id":model.mid,
                "userid":uid!,
                "type":"2"
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
                        self.loadData()
                    }
                }
                
            }
            
        }
        
    }
    
    // 评论
    func pinglunBtn(sender:UIButton) {
        
        
        //        let contentTextView = UITextField()
        table.frame = CGRectMake(0, 0, WIDTH, HEIGHT - 64 - 49 - 100)
        bview.hidden = false
        contentTextView.frame = CGRectMake(20 , 20, WIDTH - 40, 40)
        contentTextView.borderStyle = UITextBorderStyle.RoundedRect
        contentTextView.placeholder = "评论"
        contentTextView.returnKeyType = UIReturnKeyType.Send
        contentTextView.delegate = self
        bview.addSubview(contentTextView)
        
        print(1111)
        
        self.num = sender.tag
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ClassViewController.keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardDidAppear), name: UIKeyboardDidShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ClassViewController.keyboardWillDisappear(_:)), name:UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func keyboardWillAppear(notification: NSNotification) {
        
        // 获取键盘信息
        let keyboardinfo = notification.userInfo![UIKeyboardFrameEndUserInfoKey]
        
        let keyboardheight:CGFloat = (keyboardinfo?.CGRectValue.size.height)!
        
        UIView.animateWithDuration(0.3) {
            //            self.contentTableView.contentOffset = CGPoint.init(x: 0, y: self.contentTableView.contentSize.height-keyboardheight-49)
            self.bview.frame = CGRectMake(0, HEIGHT - keyboardheight - 185, WIDTH, 80)
            self.table.frame = CGRectMake(0, 0, WIDTH, HEIGHT - keyboardheight - 185)
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
            self.bview.frame = CGRectMake(0, HEIGHT - 180, WIDTH, 80)
            //                self.bview.hidden = true
            self.table.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        }
        print("键盘落下")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let chid = NSUserDefaults.standardUserDefaults()
        let userid = chid.stringForKey("userid")
        
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=school&a=SetComment"
        let param = [
            "userid":userid!,
            "id":self.dataSource.objectlist[self.num].mid,
            "type":"2",
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
                    self.table.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
                    self.loadData()
                    self.bview.hidden = true
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
        contentTextView.text = ""
    }
    
    
}
