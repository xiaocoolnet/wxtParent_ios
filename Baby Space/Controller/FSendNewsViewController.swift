//
//  FSendNewsViewController.swift
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

class FSendNewsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let table = UITableView()
    var messageSource = sendMessageList()
    var messagesSource = sendMessagesList()
    var photoSource = QCPhotoList()
    
    let arrayPeople = NSMutableArray()
    
    var dataSource = FSendList()
    
    
    
    override func viewWillAppear(animated: Bool) {
        //  是否显示分栏控制器
        self.tabBarController?.tabBar.hidden = true
        //  下拉刷新
        //        self.DropDownUpdate()
        self.loadData()
        let useDefaults = NSUserDefaults.standardUserDefaults()
        useDefaults.removeObjectForKey("count")
    }
    
    override func viewWillDisappear(animated: Bool) {
        let useDefaults = NSUserDefaults.standardUserDefaults()
        useDefaults.removeObjectForKey("count")
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.lightGrayColor()
        
        self.title = "群发消息"
        self.createTable()
        self.loadData()
    }
    //    //    开始刷新
    //    func DropDownUpdate(){
    //        self.table.headerView = XWRefreshNormalHeader(target: self, action: #selector(HomeworkViewController.loadData))
    //        self.table.reloadData()
    //        self.table.headerView?.beginRefreshing()
    //    }
    //    创建表
    func createTable(){
        table.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .None
        table.backgroundColor = RGBA(242.0, g: 242.0, b: 242.0, a: 1)
        self.view.addSubview(table)
        
//        table.registerClass(FSendNewsTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    //    加载数据
    func loadData(){
        
        //  http://wxt.xiaocool.net/index.php?g=Apps&m=Message&a=user_reception_message&receiver_user_id=682
        
        //下面两hid句代码是从缓存中取出userid（入参）值
        let defalutid = NSUserDefaults.standardUserDefaults()
        let chid = defalutid.stringForKey("chid")
        let url = "http://wxt.xiaocool.net/index.php?g=Apps&m=Message&a=user_reception_message"
        let param = [
            "receiver_user_id":chid!,
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
                    //                    self.messageSource = sendMessageList(status.data!)
                    
                    self.dataSource = FSendList(status.data!)
                    
                    self.table.reloadData()
                    self.table.headerView?.endRefreshing()
                }
            }
        }
    }
    //    分区数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    //    行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return messageSource.count
        print(dataSource.objectlist.count)
        return dataSource.objectlist.count
    }

    
    //    单元格
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: String(indexPath.row))
        
        cell.selectionStyle = .None
        // 修改之后
        let model = self.dataSource.objectlist[indexPath.row]
        let messageModel = model.send_message
        //        let picModel = model.picture
        let receiveModel = (model.receiver)
       
        
        
        let contentLabel = UILabel()
        let teacherLabel = UILabel()
        let comment = UIButton()
        let timeLabel = UILabel()
        let dianzanBtn = UIButton()
        let allLable = UILabel()
        let already = UILabel()
        let weiDu = UILabel()
        let picBtn = UIButton()
        let zong = UILabel()
        let yiDu = UILabel()
        let meiDu = UILabel()
        
//        contentLabel.textColor = UIColor.lightGrayColor()
        cell.contentView.addSubview(contentLabel)
        cell.contentView.addSubview(teacherLabel)
        cell.contentView.addSubview(comment)
        
        timeLabel.textColor = UIColor.lightGrayColor()
        timeLabel.font = UIFont.systemFontOfSize(15)
        cell.contentView.addSubview(timeLabel)
        cell.contentView.addSubview(dianzanBtn)
        cell.contentView.addSubview(allLable)
        cell.contentView.addSubview(weiDu)
        cell.contentView.addSubview(picBtn)
        
        zong.text = "总发"
        cell.contentView.addSubview(zong)
        
        yiDu.text = "已读"
        cell.contentView.addSubview(yiDu)
        
        meiDu.text = "未读"
        cell.contentView.addSubview(meiDu)
        
        contentLabel.frame = CGRectMake(10, 10, WIDTH - 20, 30)
        contentLabel.text = messageModel.first?.message_content
        contentLabel.numberOfLines = 0
        contentLabel.sizeToFit()
        // 计算群发内容高度
        let options : NSStringDrawingOptions = NSStringDrawingOptions.UsesLineFragmentOrigin
        let screenBounds:CGRect = UIScreen.mainScreen().bounds
        let boundingRect = String(contentLabel.text).boundingRectWithSize(CGSizeMake(screenBounds.width, 0), options: options, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(17)], context: nil)
        let contentheight = boundingRect.size.height + 10
        
        
        //  图片
        var image_h = CGFloat()
        var pic = model.picture
        
        var button:CustomBtn?
        
        
        //判断图片张数显示
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
                        button = CustomBtn()
                        button?.flag = i
                        button!.frame = CGRectMake(CGFloat(x), contentheight + 10, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
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
                                button!.frame = CGRectMake(CGFloat(x), contentheight+10, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                                
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
                                button!.frame = CGRectMake(CGFloat(x), contentheight+10+(WIDTH - 40)/3.0 + 5, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
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
                                button!.frame = CGRectMake(CGFloat(x), contentheight+10, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
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
                                button!.frame = CGRectMake(CGFloat(x), contentheight+10+(WIDTH - 40)/3.0 + 5, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
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
                                button!.frame = CGRectMake(CGFloat(x), contentheight+10+(WIDTH - 40)/3.0 + 5+(WIDTH - 40)/3.0 + 5, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
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
                                button!.frame = CGRectMake(CGFloat(x), contentheight+10, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
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
                                button!.frame = CGRectMake(CGFloat(x), contentheight+10+(WIDTH - 40)/3.0 + 5, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
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
                                button!.frame = CGRectMake(CGFloat(x), contentheight+10+(WIDTH - 40)/3.0 + 5+(WIDTH - 40)/3.0 + 5, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
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
        
        
        teacherLabel.frame = CGRectMake(40, contentheight + image_h + 20, 100, 20)
        teacherLabel.text = messageModel.first?.send_user_name
        timeLabel.frame = CGRectMake(WIDTH - 150, contentheight + image_h + 20, 140, 20)
        timeLabel.textAlignment = NSTextAlignment.Right
        timeLabel.text = changeTime((model.send_message.first?.message_time)!)
        
        
        zong.frame = CGRectMake(10, 10 + contentLabel.frame.height + 10 + image_h + 40, 30, 30)
        zong.font = UIFont.systemFontOfSize(15)
        zong.textColor = UIColor.orangeColor()
        allLable.frame = CGRectMake(40, 10 + contentLabel.frame.height + 10 + image_h + 40, 20, 30)
        allLable.font = UIFont.systemFontOfSize(15)
        allLable.textColor = UIColor.orangeColor()
        yiDu.frame = CGRectMake(65, 10 + contentLabel.frame.height + 10 + image_h + 40, 40, 30)
        yiDu.font = UIFont.systemFontOfSize(15)
        yiDu.textColor = UIColor.orangeColor()
        already.frame = CGRectMake(100, 10 + contentLabel.frame.height + 10 + image_h + 40, 20, 30)
        already.font = UIFont.systemFontOfSize(15)
        already.textColor = UIColor.orangeColor()
        meiDu.frame = CGRectMake(125, 10 + contentLabel.frame.height + 10 + image_h + 40, 40, 30)
        meiDu.font = UIFont.systemFontOfSize(15)
        meiDu.textColor = UIColor.orangeColor()
        weiDu.frame = CGRectMake(155, 10 + contentLabel.frame.height + 10 + image_h + 40, 40, 30)
        weiDu.font = UIFont.systemFontOfSize(15)
        weiDu.textColor = UIColor.orangeColor()
        
        let line = UILabel()
        line.frame = CGRectMake(1, contentLabel.frame.height + 10 + image_h + 20, WIDTH - 2, 0.5)
        line.backgroundColor = UIColor.lightGrayColor()
        cell.addSubview(line)
        
        let imageView = UIImageView()
        imageView.frame = CGRectMake(10, contentheight + image_h + 20, 21, 21)
        imageView.image = UIImage.init(named: "ic_fasong")
        cell.contentView.addSubview(imageView)
        
        allLable.text = String(receiveModel.count)
        let array = NSMutableArray()
        for i in 1...receiveModel.count {
            let str = receiveModel[i - 1].read_time
            if str == "" {
                array.addObject(str)
                print(receiveModel[i - 1].receiver_user_name)
                
            }
            
        }
        already.text = String(receiveModel.count - array.count)
        cell.contentView.addSubview(already)
        
        let view = UIView()
        view.frame = CGRectMake(0, weiDu.frame.maxY, WIDTH, 20)
        view.backgroundColor = RGBA(242.0, g: 242.0, b: 242.0, a: 1)
        cell.addSubview(view)
        weiDu.text = String(array.count)
        cell.contentView.addSubview(weiDu)
        
        //  已读
        let readLabel = UILabel()
        readLabel.frame = CGRectMake(WIDTH - 60, 10 + contentLabel.frame.height + 10 + image_h + 40, 50, 30)
        //        readLabel.text = "已读"
        readLabel.font = UIFont.systemFontOfSize(17)
//        readLabel.textColor = UIColor.redColor()
        cell.contentView.addSubview(readLabel)
        
        
//        if receiveModel.read_time != "" {
//            readLabel.text = "已读"
//        }else{
//            readLabel.text = "未读"
//        }
        
        for i in 1...receiveModel.count {
            let defalutid = NSUserDefaults.standardUserDefaults()
            let chid = defalutid.stringForKey("chid")
            if receiveModel[i - 1].receiver_user_id == chid {
                let str = receiveModel[i - 1].read_time
                if str != "" {
                    readLabel.text = "已读"
                    readLabel.textColor = UIColor(red: 155/255, green: 229/255, blue: 180/255, alpha: 1)
                }else{
                    readLabel.text = "未读"
                    readLabel.textColor = UIColor.orangeColor()
                }
            }
            
        }

        
        table.rowHeight = 40 + contentLabel.frame.height + 10 + image_h + 10 + 20 + 3 + 20 + 6
        
        
        return cell
    }
    
    
    func clickBtn(sender:CustomBtn){
        let vc = GroupPicViewController()
        vc.arrayInfo = self.dataSource.objectlist[(sender.tag)].picture
        vc.nu = vc.arrayInfo.count
        vc.count = sender.flag!
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = FSendDetailViewController()
        let model = self.dataSource.objectlist[indexPath.row]
        let str = model.message_id
        self.createState(str!)
        vc.dataSource = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //时间戳转时间
    func changeTime(string:String)->String{
        let dateformate = NSDateFormatter()
        dateformate.dateFormat = "yyyy-MM-dd HH:mm"//获得日期
        let date = NSDate(timeIntervalSince1970: NSTimeInterval(string)!)
        let str:String = dateformate.stringFromDate(date)
        return str
    }
    
    func createState(str:String){
        //        http://wxt.xiaocool.net/index.php?g=apps&m=student&a=read_homework&receiverid=599&homework_id=11
        
        let defalutid = NSUserDefaults.standardUserDefaults()
        let receiverid = defalutid.stringForKey("chid")
        let url = "http://wxt.xiaocool.net/index.php?g=Apps&m=Message&a=read_message"
        let param = [
            //            "classid":classid!,
            "receiver_user_id":receiverid!,
            "message_id":str
            
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
                    self.loadData()
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
