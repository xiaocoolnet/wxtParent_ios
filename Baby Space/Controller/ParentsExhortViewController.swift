//
//  ParentsExhortViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/4/29.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import XWSwiftRefresh
import MBProgressHUD
class ParentsExhortViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    let table = UITableView()
    var parentsExhortSource = ParentsExhortList()
    
    let aview = UIView()
    
    
    override func viewWillAppear(animated: Bool) {
        self.createTable()
        self.DropDownUpdate()
        self.tabBarController?.tabBar.hidden = false
        let useDefaults = NSUserDefaults.standardUserDefaults()
        useDefaults.removeObjectForKey("trustArr")
    }
    
    override func viewWillDisappear(animated: Bool) {
        let useDefaults = NSUserDefaults.standardUserDefaults()
        useDefaults.removeObjectForKey("trustArr")
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(ParentsExhortViewController.wirteExhort))
    }
    //    开始刷新
    func DropDownUpdate(){
        self.table.headerView = XWRefreshNormalHeader(target: self, action: #selector(ParentsExhortViewController.loadData))
        self.table.reloadData()
        self.table.headerView?.beginRefreshing()
    }
//    写叮嘱
    func wirteExhort(){
       let vc = WriteExhortViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
//    创建表
    func createTable(){
        table.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)
        table.delegate = self
        table.dataSource = self
        //  去掉cell中的白线
        table.separatorStyle = .None
        self.view.addSubview(table)
        
    }
//    获取数据
    func loadData(){
        //        http://wxt.xiaocool.net/index.php?g=apps&m=student&a=getentrustlist&userid=12
        
        //下面两句代码是从缓存中取出userid（入参）值
        let defalutid = NSUserDefaults.standardUserDefaults()
        let uid = defalutid.stringForKey("userid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=getentrustlist"
        let param = [
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
                    hud.mode = MBProgressHUDMode.Text
                    hud.labelText = status.errorData
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                if(status.status == "success"){
                    self.parentsExhortSource = ParentsExhortList(status.data!)
                    self.table.reloadData()
                    self.table.headerView?.endRefreshing()
                }
            }
        }
    }
//    行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parentsExhortSource.objectlist.count
    }
//单元格
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .Default, reuseIdentifier:String(indexPath.row))
        cell.selectionStyle = .None
        let exhortInfo = self.parentsExhortSource.objectlist[indexPath.row]
        var pic = exhortInfo.pic
        // 名字
        let username = UILabel()
        username.frame = CGRectMake(10, 10, 100, 20)
        username.text = exhortInfo.studentname
        cell.contentView.addSubview(username)
        // 描述详情
        let content = UILabel()
        content.frame = CGRectMake(10, 40, WIDTH - 20, 20)
        content.textColor = neirongColor
        content.font = UIFont.systemFontOfSize(15)
        content.text = exhortInfo.content
        cell.contentView.addSubview(content)
        //        自适应行高
        let options : NSStringDrawingOptions = NSStringDrawingOptions.UsesLineFragmentOrigin
        let screenBounds:CGRect = UIScreen.mainScreen().bounds
        let boundingRect = String(content.text).boundingRectWithSize(CGSizeMake(screenBounds.width, 0), options: options, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(15)], context: nil)
        let heigh = boundingRect.size.height + 50
        
        //  图片
        var image_h = CGFloat()
        var button:CustomBtn?
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
                        button!.frame = CGRectMake(10, heigh, WIDTH - 20, 300)
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
                            button!.frame = CGRectMake(CGFloat(x), heigh, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
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
                                button!.frame = CGRectMake(CGFloat(x), heigh, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                                
                                let imgTmp = UIImage(data: data!)
                                
                                button!.setImage(imgTmp, forState: .Normal)
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
                                button!.frame = CGRectMake(CGFloat(x), heigh+(WIDTH - 40)/3.0 + 5, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                                let imgTmp = UIImage(data: data!)
                                
                                button!.setImage(imgTmp, forState: .Normal)
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
                                button!.frame = CGRectMake(CGFloat(x), heigh, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                                let imgTmp = UIImage(data: data!)
                                
                                button!.setImage(imgTmp, forState: .Normal)
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
                                button!.frame = CGRectMake(CGFloat(x), heigh+(WIDTH - 40)/3.0 + 5, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                                let imgTmp = UIImage(data: data!)
                                
                                button!.setImage(imgTmp, forState: .Normal)
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
                                button!.frame = CGRectMake(CGFloat(x), heigh+(WIDTH - 40)/3.0 + 5+(WIDTH - 40)/3.0 + 5, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                                let imgTmp = UIImage(data: data!)
                                
                                button!.setImage(imgTmp, forState: .Normal)
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
                                button!.frame = CGRectMake(CGFloat(x), heigh, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                                let imgTmp = UIImage(data: data!)
                                
                                button!.setImage(imgTmp, forState: .Normal)
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
                                button!.frame = CGRectMake(CGFloat(x), heigh+(WIDTH - 40)/3.0 + 5, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                                let imgTmp = UIImage(data: data!)
                                
                                button!.setImage(imgTmp, forState: .Normal)
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
                                button!.frame = CGRectMake(CGFloat(x), heigh+(WIDTH - 40)/3.0 + 5+(WIDTH - 40)/3.0 + 5, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                                let imgTmp = UIImage(data: data!)
                                
                                button!.setImage(imgTmp, forState: .Normal)
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
       
        let imgBtn = UIButton()
        imgBtn.frame = CGRectMake(10, heigh + image_h + 10, 20, 20)
//        let imgUrl = microblogImageUrl + exhortInfo.teacheravatar!
//        let teacheravatar = NSURL(string: imgUrl)
        imgBtn.setImage(UIImage(named: "ic_jieshouren"), forState: .Normal)
        cell.contentView.addSubview(imgBtn)
        //  老师名字
        let teachername = UILabel()
        teachername.frame = CGRectMake(40, heigh + image_h + 10, 140, 20)
        teachername.textColor = UIColor.lightGrayColor()
        teachername.text = exhortInfo.teachername
        cell.contentView.addSubview(teachername)
        
        let dateformate = NSDateFormatter()
        dateformate.dateFormat = "yyyy-MM-dd HH:mm"
        let date = NSDate(timeIntervalSince1970: NSTimeInterval(exhortInfo.create_time!)!)
        let str:String = dateformate.stringFromDate(date)
        
        let create_time = UILabel()
        create_time.frame = CGRectMake(180, heigh + image_h + 10, WIDTH - 190, 20)
        create_time.textColor = UIColor.lightGrayColor()
        create_time.font = UIFont.systemFontOfSize(15)
        create_time.text = str
        create_time.textAlignment = NSTextAlignment.Right
        cell.contentView.addSubview(create_time)
        
        let agreeLable = UILabel()
        agreeLable.frame  = CGRectMake(WIDTH - 90, 10, 80, 30)
//        agreeLable.textColor = UIColor.redColor()
        agreeLable.textAlignment = NSTextAlignment.Right
        cell.contentView.addSubview(agreeLable)
        
        let commentModel = exhortInfo.comment
        if commentModel.count != 0 {
            agreeLable.text = "已回复"
            agreeLable.textColor = UIColor(red: 155/255, green: 229/255, blue: 180/255, alpha: 1)
            let view = UIView()
            view.frame = CGRectMake(8, heigh + 40 + image_h, WIDTH - 16 , 60 * CGFloat(commentModel.count))
            view.backgroundColor = RGBA(242.0, g: 242.0, b: 242.0, a: 1)
            cell.contentView.addSubview(view)
            for i in 1...commentModel.count {
                let com = commentModel[i - 1]
                let photo  = UIImageView()
                photo.frame = CGRectMake(10, 10 * CGFloat(i), 40, 40)
                let imgUrl = microblogImageUrl + com.photo!
                let teach = NSURL(string: imgUrl)
                photo.sd_setImageWithURL(teach, placeholderImage: UIImage(named: "默认头像"))
                view.addSubview(photo)
                
                let name = UILabel()
                name.frame = CGRectMake(60, 10 * CGFloat(i), 100, 20)
                name.backgroundColor = RGBA(242.0, g: 242.0, b: 242.0, a: 1)
                name.text = com.name
                name.font = UIFont.systemFontOfSize(15)
                view.addSubview(name)
                
                let conLab = UILabel()
                conLab.frame = CGRectMake(60, 30 * CGFloat(i), WIDTH - 196, 30)
                conLab.backgroundColor = RGBA(242.0, g: 242.0, b: 242.0, a: 1)
                conLab.text = com.content
                conLab.numberOfLines = 0
                conLab.textColor = UIColor.lightGrayColor()
                conLab.font = UIFont.systemFontOfSize(15)
                view.addSubview(conLab)
                
                let dateformate = NSDateFormatter()
                dateformate.dateFormat = "yyyy-MM-dd HH:mm"
                let date = NSDate(timeIntervalSince1970: NSTimeInterval(com.comment_time!)!)
                let str:String = dateformate.stringFromDate(date)
                let time = UILabel()
                time.frame = CGRectMake(170, 10 * CGFloat(i), WIDTH - 196, 20)
                time.backgroundColor = RGBA(242.0, g: 242.0, b: 242.0, a: 1)
                time.text = str
                time.font = UIFont.systemFontOfSize(15)
                time.textAlignment = NSTextAlignment.Right
                time.textColor = UIColor.lightGrayColor()
                view.addSubview(time)
                
            }
            
        }else{
            agreeLable.text = "未回复"
            agreeLable.textColor = UIColor.orangeColor()
        }
        let line = UILabel()
        line.backgroundColor = UIColor.lightGrayColor()
        line.frame = CGRectMake(1, heigh + image_h + 40 + 60 * CGFloat(commentModel.count) + 9.5, WIDTH - 2, 0.5)
        cell.contentView.addSubview(line)
         tableView.rowHeight = heigh + image_h + 40 + 60 * CGFloat(commentModel.count) + 10
        return cell
    }
    
    func clickBtn(sender:CustomBtn){
        let vc = ExhortPicViewController()
        vc.arrayInfo = self.parentsExhortSource.objectlist[(sender.tag)].pic
        vc.nu = vc.arrayInfo.count
        vc.count = sender.flag!
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
