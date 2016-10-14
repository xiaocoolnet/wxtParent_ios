//
//  TabViewController.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/26.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import YYWebImage
import XWSwiftRefresh
import MBProgressHUD

class TabViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()
    var homeworkSource = HomeworkList()
    var dianzanSource = DianZanList()
    var commentSource = HCommentList()
    var homeWorkArr = QCHomeWorkList()
    var photoArr = QCPictureList()
    let arrayPeople = NSMutableArray()
    
    
    var dataSouce = NewsLi()
    var likeSource = LikeList()
    
    var picSource = PiList()
    var a = 0
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        //        self.createTable()
                self.loadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGrayColor()
        
        self.tabBarController?.tabBar.hidden = true
        self.DropDownUpdate()
        self.createTable()
//        self.loadData()
        self.title = "作业"
        
    }
    //    开始刷新
    func DropDownUpdate(){
        self.tableView.headerView = XWRefreshNormalHeader(target: self, action: #selector(HomeworkViewController.loadData))
        self.tableView.reloadData()
        self.tableView.headerView?.beginRefreshing()
    }
    //    创建表
    func createTable(){
        tableView.frame = self.view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        //  隐藏线
        tableView.separatorStyle = .None
        self.view.addSubview(tableView)
        //        注册cell
        //        table.registerNib(UINib.init(nibName: "HomeworkTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeworkCellID")
//        tableView.registerClass(HomeworkTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    //    获取作业列表
    func loadData(){
        //  需要进行接口的修改
        
        //       http://wxt.xiaocool.net/index.php?g=apps&m=student&a=gethomeworkmessage&receiverid=599
        //下面两句代码是从缓存中取出userid（入参）值
        let defalutid = NSUserDefaults.standardUserDefaults()
        let receiverid = defalutid.stringForKey("chid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=gethomeworkmessage"
        let param = [
            //            "classid":classid!,
            "receiverid":receiverid!
            //  这里为空了
            
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
                    hud.mode = MBProgressHUDMode.Text
                    hud.labelText = status.errorData
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                if(status.status == "success"){
                    self.homeworkSource = HomeworkList(status.data!)
                    
                    
                    //                    self.tableView.reloadData()
                    
                    
                    self.dataSouce = NewsLi(status.data!)
                    self.likeSource = LikeList(status.data!)
                    self.picSource = PiList(status.data!)
                    
                    self.tableView.reloadData()
                    self.tableView.headerView?.endRefreshing()
                }
            }
        }
    }
    
    //    行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(homeworkSource.count)
        
        //        return homeworkSource.count
        return dataSouce.objectlist.count
    }
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 430
//    }
    //    单元格
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //  先走了两次改方法
        
        let cell = UITableViewCell(style: .Default, reuseIdentifier: String(indexPath.row))
        cell.selectionStyle = .None
        
        let mode = self.dataSouce.objectlist[indexPath.row]
        let model = mode.homework_inf.first
        let info = mode.receive_list
        
       
        //  标题
        let titleLbl = UILabel()
        
        titleLbl.frame = CGRectMake(10, 10, WIDTH - 20, 30)
        titleLbl.text = model?.title
        titleLbl.textAlignment = NSTextAlignment.Center
//        titleLbl.setTitle(model?.title, forState: .Normal)
//        titleLbl.setTitleColor(UIColor.blackColor(), forState: .Normal)
        cell.contentView.addSubview(titleLbl)
        
        //  内容
        let contentLbl = UILabel()
        
        contentLbl.frame = CGRectMake(10, 50, WIDTH - 20, 20)
//        contentLbl.textColor = UIColor.lightGrayColor()
        contentLbl.text = model?.content
        contentLbl.numberOfLines = 0
        contentLbl.sizeToFit()
        contentLbl.font = UIFont.boldSystemFontOfSize(16)
        cell.contentView.addSubview(contentLbl)
        //        自适应行高
        let options : NSStringDrawingOptions = NSStringDrawingOptions.UsesLineFragmentOrigin
        let screenBounds:CGRect = UIScreen.mainScreen().bounds
        let boundingRect = String(contentLbl.text).boundingRectWithSize(CGSizeMake(screenBounds.width, 0), options: options, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(17)], context: nil)
        let height = boundingRect.size.height + 60
        
        var blogimage:UIImageView?
        var image_h = CGFloat()
        let pic = mode.pictur
        
        var button:CustomBtn?
        
        
        //判断图片张数显示
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
                    if pciInfo.picture_url != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.picture_url)
                        
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
                    if pciInfo.picture_url != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.picture_url)
                        
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
                                //self.imageCache[imgUrl] = imgTmp
                                blogimage!.image = imgTmp
//
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
                    if pciInfo.picture_url != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.picture_url)
                        
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
                    if pciInfo.picture_url != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.picture_url)
                        
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
                    if pciInfo.picture_url != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.picture_url)
                        
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
                    if pciInfo.picture_url != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.picture_url)
                        
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
                    if pciInfo.picture_url != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.picture_url)
                        
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
                                button?.imageView?.contentMode = .ScaleAspectFill
                                button?.clipsToBounds = true
                                if button?.imageView?.image == nil{
                                    button!.setImage(UIImage(named: "图片默认加载"), forState: .Normal)
                                }
                                button?.tag = indexPath.row
                                button?.addTarget(self, action: #selector(self.clickBtn(_:)), forControlEvents: .TouchUpInside)
                                cell.contentView.addSubview(button!)
                            }
                        })
                        
                    }
                    
                }
                
            }
        }
        tableView.rowHeight=height+image_h + 10 + 26 + 10 + 39
        
        //  老师
        let imageView = UIImageView()
        imageView.frame = CGRectMake(10, height+image_h + 10, 21, 21)
        imageView.image = UIImage.init(named: "ic_fasong")
        cell.contentView.addSubview(imageView)
        
        let senderLbl = UILabel()
        senderLbl.frame = CGRectMake(35, height+image_h + 10, 100, 21)
        senderLbl.text = model?.name
        senderLbl.font = UIFont.systemFontOfSize(14)
        cell.contentView.addSubview(senderLbl)
        
        //已读未读
        let readStatusLabel = UILabel()
        readStatusLabel.frame = CGRectMake(10, height+image_h + 41, 200, 30)
        readStatusLabel.textColor = UIColor.orangeColor()
        readStatusLabel.font = UIFont.systemFontOfSize(15)
        cell.contentView.addSubview(readStatusLabel)
        
        //计算已读未读人数
        let allReader = info.count
        let array = NSMutableArray()
        for i in 1...info.count {
            let str = info[i - 1].read_time
            if str == "" {
                array.addObject(str)
                
            }
        }
        readStatusLabel.text = "总发\(allReader) 已读 \(allReader-array.count) 未读 \(array.count)"
        
        //  已读
        let readLabel = UILabel()
        readLabel.frame = CGRectMake(WIDTH - 60, height+image_h + 41, 40, 30)
        //        readLabel.text = "已读"
        readLabel.font = UIFont.systemFontOfSize(17)
        readLabel.textAlignment = NSTextAlignment.Right
        cell.contentView.addSubview(readLabel)
        if mode.read_time != nil {
            readLabel.text = "已读"
            readLabel.textColor = UIColor(red: 155/255, green: 229/255, blue: 180/255, alpha: 1)
        }else{
            readLabel.text = "未读"
            readLabel.textColor = UIColor.orangeColor()
        }

        
        let timeLbl = UILabel()
        timeLbl.frame = CGRectMake(WIDTH - 130, height+image_h + 10, 120, 21)
//        cell.timeLbl.text = "04-23 16:30"
        timeLbl.textColor = UIColor.lightGrayColor()
        timeLbl.font = UIFont.systemFontOfSize(14)
        cell.contentView.addSubview(timeLbl)

        //  时间
        let dateformate = NSDateFormatter()
        dateformate.dateFormat = "yyyy-MM-dd HH:mm"
        let date = NSDate(timeIntervalSince1970: NSTimeInterval(model!.create_time)!)
        let str:String = dateformate.stringFromDate(date)
        timeLbl.text = str
        
        let aview = UIView()
        aview.frame = CGRectMake(0, height+image_h + 10 + 26 + 10 + 30, WIDTH, 9)
        aview.backgroundColor = RGBA(242.0, g: 242.0, b: 242.0, a: 1)
        cell.contentView.addSubview(aview)
        
        let btn = UIButton()
        btn.frame = CGRectMake(0, 0, WIDTH, 150)
        btn.backgroundColor = UIColor.clearColor()
        btn.tag = indexPath.row
        btn.addTarget(self, action: #selector(self.click(_:)), forControlEvents: .TouchUpInside)
        cell.contentView.addSubview(btn)
        
        
        
        return cell
    }

    
    func click(sender:UIButton){
        print(111)
        let vc = HomeDetailViewController()
        vc.dataInfo = self.dataSouce.objectlist[sender.tag]
        vc.homeInfo = (vc.dataInfo?.homework_inf)!
        vc.pic = (vc.dataInfo?.pictur)!
        let str = self.dataSouce.objectlist[sender.tag].homework_id
        self.createState(str!)
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    func clickBtn(sender:CustomBtn){
        let vc = HomeWorkDetailViewController()
        vc.arrayInfo = self.dataSouce.objectlist[(sender.tag)].pictur
        vc.nu = vc.arrayInfo.count
        vc.count = sender.flag!
        let str = self.dataSouce.objectlist[sender.tag].homework_id
        self.createState(str!)
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func createState(str:String){
//        http://wxt.xiaocool.net/index.php?g=apps&m=student&a=read_homework&receiverid=599&homework_id=11
        
        let defalutid = NSUserDefaults.standardUserDefaults()
        let receiverid = defalutid.stringForKey("chid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=read_homework"
        let param = [
            //            "classid":classid!,
            "receiverid":receiverid!,
            "homework_id":str
            
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
                    hud.mode = MBProgressHUDMode.Text
                    hud.labelText = status.errorData
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                if(status.status == "success"){
                    
                }
            }
        }

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
