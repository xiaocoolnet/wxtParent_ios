//
//  LeaveViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/5/6.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import XWSwiftRefresh
import MBProgressHUD

class LeaveViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    let tableSource = UITableView()
    var leaveSource = LeaveList()
    
    override func viewWillAppear(animated: Bool) {
//        self.loadData()
        self.DropDownUpdate()
        self.tabBarController?.tabBar.hidden = false
        let useDefaults = NSUserDefaults.standardUserDefaults()
        useDefaults.removeObjectForKey("leaveArr")
    }
    
    override func viewWillDisappear(animated: Bool) {
        let useDefaults = NSUserDefaults.standardUserDefaults()
        useDefaults.removeObjectForKey("leaveArr")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.hidden = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(LeaveViewController.wirteQJ))
        self.createTable()
//        self.DropDownUpdate()
    }
    //    写假条
    func wirteQJ(){
        let vc = WriteQJViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //    开始刷新
    func DropDownUpdate(){
        self.tableSource.headerView = XWRefreshNormalHeader(target: self, action: #selector(LeaveViewController.loadData))
        self.tableSource.reloadData()
        self.tableSource.headerView?.beginRefreshing()
    }
//    请加列表
    func loadData(){
        //http://wxt.xiaocool.net/index.php?g=apps&m=student&a=getleavelist&studentid=12
        //下面两句代码是从缓存中取出userid（入参）值
        let defalutid = NSUserDefaults.standardUserDefaults()
        let chid = defalutid.stringForKey("chid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=getleavelist"
        let param = [
            "studentid":chid
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
                    hud.mode = MBProgressHUDMode.Text
                    hud.labelText = status.errorData
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                if(status.status == "success"){
                    self.leaveSource = LeaveList(status.data!)
                    self.tableSource.reloadData()
                    self.tableSource.headerView?.endRefreshing()
                }
            }
        }
    }
    //    创建表
    func createTable(){
        tableSource.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)
        tableSource.delegate = self
        tableSource.dataSource = self
        tableSource.separatorStyle = .None
        self.view.addSubview(tableSource)
        
//        tableSource.registerNib(UINib.init(nibName: "OnlineQJTableViewCell", bundle: nil), forCellReuseIdentifier: "OnlineQJCell")
    }
//    行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.leaveSource.objectlist.count
    }
//    单元格
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier:String(indexPath.row))
        cell.selectionStyle = .None
        let leaveInfo = self.leaveSource.objectlist[indexPath.row]
        //  下面的一行为空了
        let headImageView = UIImageView()
        headImageView.frame = CGRectMake(10, 10, 40, 40)
        let imgUrl = microblogImageUrl + leaveInfo.parentavatar!
        let photourl = NSURL(string: imgUrl)
        headImageView.yy_setImageWithURL(photourl, placeholder: UIImage(named: "默认头像"))
        headImageView.layer.cornerRadius = 20
        headImageView.clipsToBounds = true
        cell.addSubview(headImageView)
        
        let studentNameLbl = UILabel()
        studentNameLbl.frame = CGRectMake(60, 10, 120, 20)
        studentNameLbl.text = leaveInfo.parentname
        cell.contentView.addSubview(studentNameLbl)
        
        let classLbl = UILabel()
        classLbl.frame = CGRectMake(60, 40, 100, 20)
        classLbl.font = UIFont.systemFontOfSize(16)
        classLbl.textColor = UIColor.lightGrayColor()
        classLbl.text = leaveInfo.classname
        cell.contentView.addSubview(classLbl)
        
        let contentLbl = UILabel()
        contentLbl.frame = CGRectMake(10, 70, WIDTH - 20, 80)
        contentLbl.text = leaveInfo.reason
        contentLbl.numberOfLines = 0
        contentLbl.sizeToFit()
        cell.contentView.addSubview(contentLbl)
    
        //        自适应行高
        let options : NSStringDrawingOptions = NSStringDrawingOptions.UsesLineFragmentOrigin
        let screenBounds:CGRect = UIScreen.mainScreen().bounds
        let boundingRect = String(contentLbl.text).boundingRectWithSize(CGSizeMake(screenBounds.width, 0), options: options, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(17)], context: nil)
        let height = boundingRect.size.height + 80
        
        
        //  图片
        var image_h = CGFloat()
        var button:UIButton?
        //判断图片张数显示
        
        var pic  = leaveInfo.pic
        print(pic.count)
        
        //解决数据返回有null和“”的错误图片显示
        if pic.count==1&&(pic.first?.picture_url=="null"||pic.first?.picture_url=="") {
            pic.removeAll()
        }
        if(pic.count>0&&pic.count<=3){
            image_h=(WIDTH - 40)/3.0
            for i in 1...pic.count{
                var x = 12
                let pciInfo = pic[i-1]
                let imgUrl = microblogImageUrl+(pciInfo.picture_url)
                print(imgUrl)
                
                //let image = self.imageCache[imgUrl] as UIImage?
                let avatarUrl = NSURL(string: imgUrl)
                let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                    if(data != nil){
                        x = x+((i-1)*Int((WIDTH - 40)/3.0 + 10))
                        //                        blogimage = UIImageView(frame: CGRectMake(CGFloat(x), 150, 110, 80))
                        button = UIButton()
                        button!.frame = CGRectMake(CGFloat(x), height, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                        let imgTmp = UIImage(data: data!)
                        
                        button!.setImage(imgTmp, forState: .Normal)
                        if button?.imageView?.image == nil{
                            //                            button!.setImage(UIImage(named: "Logo"), forState: .Normal)
                            button?.setBackgroundImage(UIImage(named: "Logo"), forState: .Normal)
                        }
                        button?.tag = indexPath.row
                        //                        button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
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
                    if pciInfo.picture_url != "" {
                        
                        
                        let imgUrl = microblogImageUrl+(pciInfo.picture_url)
                        
                        //let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-1)*Int((WIDTH - 40)/3.0 + 10))
                                button = UIButton()
                                button!.frame = CGRectMake(CGFloat(x), height, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                                
                                let imgTmp = UIImage(data: data!)
                                
                                button!.setImage(imgTmp, forState: .Normal)
                                if button?.imageView?.image == nil{
                                    button!.setImage(UIImage(named: "Logo"), forState: .Normal)
                                }
                                button?.tag = indexPath.row
                                //                                button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                                cell.contentView.addSubview(button!)
                            }
                        })
                    }}else{
                    var x = 12
                    let pciInfo = pic[i-1]
                    if pciInfo.picture_url != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.picture_url)
                        
                        //let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-4)*Int((WIDTH - 40)/3.0 + 10))
                                button = UIButton()
                                button!.frame = CGRectMake(CGFloat(x), height+(WIDTH - 40)/3.0 + 5, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                                let imgTmp = UIImage(data: data!)
                                
                                button!.setImage(imgTmp, forState: .Normal)
                                if button?.imageView?.image == nil{
                                    button!.setImage(UIImage(named: "Logo"), forState: .Normal)
                                }
                                button?.tag = indexPath.row
                                //                                button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
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
                    if pciInfo.picture_url != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.picture_url)
                        
                        //let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-1)*Int((WIDTH - 40)/3.0 + 10))
                                button = UIButton()
                                button!.frame = CGRectMake(CGFloat(x), height, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                                let imgTmp = UIImage(data: data!)
                                
                                button!.setImage(imgTmp, forState: .Normal)
                                if button?.imageView?.image == nil{
                                    button!.setImage(UIImage(named: "Logo"), forState: .Normal)
                                }
                                button?.tag = indexPath.row
                                //                                button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                                cell.contentView.addSubview(button!)
                            }
                        })
                        
                    }}else if (i>3&&i<=6){
                    var x = 12
                    let pciInfo = pic[i-1]
                    if pciInfo.picture_url != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.picture_url)
                        
                        //let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-4)*Int((WIDTH - 40)/3.0 + 10))
                                button = UIButton()
                                button!.frame = CGRectMake(CGFloat(x), height+(WIDTH - 40)/3.0 + 5, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                                let imgTmp = UIImage(data: data!)
                                
                                button!.setImage(imgTmp, forState: .Normal)
                                if button?.imageView?.image == nil{
                                    button!.setImage(UIImage(named: "Logo"), forState: .Normal)
                                }
                                button?.tag = indexPath.row
                                //                                button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                                cell.contentView.addSubview(button!)
                            }
                        })
                        
                    } }else{
                    var x = 12
                    let pciInfo = pic[i-1]
                    if pciInfo.picture_url != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.picture_url)
                        
                        //let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-7)*Int((WIDTH - 40)/3.0 + 10))
                                button = UIButton()
                                button!.frame = CGRectMake(CGFloat(x), height+(WIDTH - 40)/3.0 + 5+(WIDTH - 40)/3.0 + 5, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                                let imgTmp = UIImage(data: data!)
                                
                                button!.setImage(imgTmp, forState: .Normal)
                                if button?.imageView?.image == nil{
                                    button!.setImage(UIImage(named: "Logo"), forState: .Normal)
                                }
                                button?.tag = indexPath.row
                                //                                button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
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
                    if pciInfo.picture_url != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.picture_url)
                        
                        //let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-1)*Int((WIDTH - 40)/3.0 + 10))
                                print(x)
                                button = UIButton()
                                button!.frame = CGRectMake(CGFloat(x), height, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                                let imgTmp = UIImage(data: data!)
                                
                                button!.setImage(imgTmp, forState: .Normal)
                                if button?.imageView?.image == nil{
                                    button!.setImage(UIImage(named: "Logo"), forState: .Normal)
                                }
                                button?.tag = indexPath.row
                                //                                button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                                cell.contentView.addSubview(button!)
                            }
                        })
                        
                    }}else if (i>3&&i<=6){
                    var x = 12
                    let pciInfo = pic[i-1]
                    if pciInfo.picture_url != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.picture_url)
                        
                        //let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-4)*Int((WIDTH - 40)/3.0 + 10))
                                button = UIButton()
                                button!.frame = CGRectMake(CGFloat(x), height+(WIDTH - 40)/3.0 + 5, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                                let imgTmp = UIImage(data: data!)
                                
                                button!.setImage(imgTmp, forState: .Normal)
                                if button?.imageView?.image == nil{
                                    button!.setImage(UIImage(named: "Logo"), forState: .Normal)
                                }
                                button?.tag = indexPath.row
                                //                                button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                                cell.contentView.addSubview(button!)
                            }
                        })
                        
                    } }else{
                    var x = 12
                    let pciInfo = pic[i-1]
                    if pciInfo.picture_url != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.picture_url)
                        
                        //let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-7)*Int((WIDTH - 40)/3.0 + 10))
                                button = UIButton()
                                button!.frame = CGRectMake(CGFloat(x), height+(WIDTH - 40)/3.0 + 5+(WIDTH - 40)/3.0 + 5, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                                let imgTmp = UIImage(data: data!)
                                
                                button!.setImage(imgTmp, forState: .Normal)
                                if button?.imageView?.image == nil{
                                    button!.setImage(UIImage(named: "Logo"), forState: .Normal)
                                }
                                button?.tag = indexPath.row
                                //                                button?.addTarget(self, action: #selector(self.clickBtn(_:)), forControlEvents: .TouchUpInside)
                                cell.contentView.addSubview(button!)
                            }
                        })
                        
                    }
                    
                }
                
            }}

        let line = UILabel()
        line.frame = CGRectMake(0, height + image_h + 9.5, WIDTH, 0.5)
        line.backgroundColor = RGBA(242.0, g: 242.0, b: 242.0, a: 1)
        cell.contentView.addSubview(line)
        
        let teacherNameLbl = UILabel()
        teacherNameLbl.frame = CGRectMake(10, height + image_h + 20, 150, 30)
        teacherNameLbl.text = "受理人：\(leaveInfo.teachername!)"
        cell.contentView.addSubview(teacherNameLbl)
        
        let statusLbl = UILabel()
        statusLbl.frame = CGRectMake(WIDTH - 60, 15, 60, 30)
//        statusLbl.textColor = UIColor.redColor()
        statusLbl.font = UIFont.systemFontOfSize(16)
        if leaveInfo.status == "0" {
            statusLbl.text = "未反馈"
            statusLbl.textColor = UIColor.orangeColor()
        }else if leaveInfo.status == "1" {
            statusLbl.text = "已同意"
            statusLbl.textColor = UIColor(red: 155/255, green: 229/255, blue: 180/255, alpha: 1)
        }else{
            statusLbl.text = "不同意"
            statusLbl.textColor = UIColor.orangeColor()
        }
        cell.contentView.addSubview(statusLbl)

        let dateformate = NSDateFormatter()
        dateformate.dateFormat = "MM-dd"
        let begintime = NSDate(timeIntervalSince1970: NSTimeInterval(leaveInfo.begintime!)!)
        let str:String = dateformate.stringFromDate(begintime)
        let endtime = NSDate(timeIntervalSince1970: NSTimeInterval(leaveInfo.endtime!)!)
        let str1:String = dateformate.stringFromDate(endtime)
        let timeLbl = UILabel()
        timeLbl.frame = CGRectMake(160, height + image_h + 20, WIDTH - 170, 30)
        timeLbl.textAlignment = NSTextAlignment.Right
        timeLbl.text = "\(str)至\(str1)"
        cell.contentView.addSubview(timeLbl)
        
        let view = UIView()
        view.frame = CGRectMake(0, height + image_h + 50, WIDTH, 8)
        view.backgroundColor = RGBA(242.0, g: 242.0, b: 242.0, a: 1)
        cell.contentView.addSubview(view)
        
        tableView.rowHeight = height + image_h + 58
        return cell
    }
}
