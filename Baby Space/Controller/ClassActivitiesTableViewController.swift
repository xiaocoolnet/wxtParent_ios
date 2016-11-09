//
//  ClassActivitiesTableViewController.swift
//  WXT_Parents
//
//  Created by 牛尧 on 16/2/24.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import YYWebImage
import XWSwiftRefresh
import MBProgressHUD

class ClassActivitiesTableViewController: UITableViewController {

    @IBOutlet var tableSource: UITableView!
    var activitySource = ActivityList()
    var activity_listSource = activity_listList()
    var apply_countSource = apply_countList()
    var picSource = picList()
    var user_Source = user_List()
    let arrayPeople = NSMutableArray()

    override func viewWillAppear(animated: Bool) {
        
        self.DropDownUpdate()
        let useDefaults = NSUserDefaults.standardUserDefaults()
        useDefaults.removeObjectForKey("activityArr")
    }
    
    override func viewWillDisappear(animated: Bool) {
        let useDefaults = NSUserDefaults.standardUserDefaults()
        useDefaults.removeObjectForKey("activityArr")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.DropDownUpdate()
//        tableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT + 20)
//        tableView.backgroundColor = UIColor.lightGrayColor()
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ClassActivitiesTableViewController.gameOver(_:)), name: "push", object: nil)
    
    }
    
    func gameOver(title:NSNotification)
    {
//        if title == 1{
            let vc = TeacherCommentsTableViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            
//        }
    }

    
    
    //    开始刷新
    func DropDownUpdate(){
        self.tableSource.headerView = XWRefreshNormalHeader(target: self, action: #selector(ClassActivitiesTableViewController.GetDate))
        self.tableSource.reloadData()
        self.tableSource.headerView?.beginRefreshing()
    }
//    获取活动列表
    func GetDate(){

//        http://wxt.xiaocool.net/index.php?g=apps&m=student&a=getactivitylist&receiverid=597
        //下面两句代码是从缓存中取出userid（入参）值
        let defalutid = NSUserDefaults.standardUserDefaults()
        let receiverid = defalutid.stringForKey("chid")
//        let classid = defalutid.stringForKey("classid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=getactivitylist&receiverid="+receiverid!
//        let param = [
//            "receiverid ":receiverid!
////            "classid":classid!
//        ]
        print(receiverid)
        Alamofire.request(.GET, url, parameters: nil).response { request, response, json, error in
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
                    self.activitySource = ActivityList(status.data!)
                    self.tableSource.reloadData()
                    self.tableSource.headerView?.endRefreshing()
                }
            }
        }
        
    }
//    分区数
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
//    行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.activitySource.count
    }
    
//    单元格
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: String(indexPath.row))
        cell.selectionStyle = .None
        tableSource.separatorStyle = .None
        let activityInfo = self.activitySource.activityList[indexPath.row]
        self.activity_listSource = activity_listList(activityInfo.activity_list!)
        self.apply_countSource = apply_countList(activityInfo.apply_count!)
        self.picSource = picList(activityInfo.pic!)
        
        //  得到活动中的内容
        let activity_listModel = self.activity_listSource.activityList[0]

        //  活动标题
        let titleLbl = UILabel()
        titleLbl.frame = CGRectMake(10, 10, WIDTH - 20, 30)
        titleLbl.textAlignment = NSTextAlignment.Center
        titleLbl.font=biaotifont
        titleLbl.textColor = biaotiColor
        titleLbl.text = activity_listModel.title
        cell.contentView.addSubview(titleLbl)
        
        
        
        //  活动内容
        let contentLbl = UILabel()
        contentLbl.frame = CGRectMake(10, 50, WIDTH - 20, 20)
        contentLbl.font = neirongfont
        contentLbl.textColor = neirongColor
        contentLbl.text = activity_listModel.content
        cell.contentView.addSubview(contentLbl)
        //        自适应行高
        let options : NSStringDrawingOptions = NSStringDrawingOptions.UsesLineFragmentOrigin
        let screenBounds:CGRect = UIScreen.mainScreen().bounds
        let boundingRect = String(contentLbl.text).boundingRectWithSize(CGSizeMake(screenBounds.width, 0), options: options, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(15)], context: nil)
        let height = boundingRect.size.height + 10 + 50
        //  活动图片

        var pic = self.picSource.activityList
//        print(picModel.count)
        
        
        
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
                                button!.frame = CGRectMake(CGFloat(x), height+(WIDTH - 40)/3.0 + 5, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
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
                                button!.frame = CGRectMake(CGFloat(x), height, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
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
                                button!.frame = CGRectMake(CGFloat(x), height+(WIDTH - 40)/3.0 + 5, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
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
                                button!.frame = CGRectMake(CGFloat(x), height+(WIDTH - 40)/3.0 + 5+(WIDTH - 40)/3.0 + 5, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
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
                                button!.frame = CGRectMake(CGFloat(x), height, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
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
                                button!.frame = CGRectMake(CGFloat(x), height+(WIDTH - 40)/3.0 + 5, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
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
                                button!.frame = CGRectMake(CGFloat(x), height+(WIDTH - 40)/3.0 + 5+(WIDTH - 40)/3.0 + 5, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                                let imgTmp = UIImage(data: data!)
                            
                                button!.setImage(imgTmp, forState: .Normal)
                                if button?.imageView?.image == nil{
                                    button!.setImage(UIImage(named: "Logo"), forState: .Normal)
                                }
                                button?.tag = indexPath.row
                                button?.addTarget(self, action: #selector(self.clickBtn(_:)), forControlEvents: .TouchUpInside)
                                cell.contentView.addSubview(button!)
                            }
                        })
                        
                    }
                    
                }
                
            }}
        tableView.rowHeight = height + image_h + 100
        
        let imageView = UIImageView()
        imageView.frame = CGRectMake(10, height + image_h + 10, 21, 21)
        imageView.image = UIImage.init(named: "ic_fasong")
        cell.contentView.addSubview(imageView)
        
        let senderLbl = UILabel()
        senderLbl.frame = CGRectMake(40, height + image_h + 10, 100, 20)
        senderLbl.font = UIFont.systemFontOfSize(16)
        self.user_Source = user_List(activity_listModel.user_info!)
        if self.user_Source.activityList.count != 0 {
            let userModel = self.user_Source.activityList[0]
            senderLbl.textColor = timeColor
            senderLbl.font = timefont
            senderLbl.text = userModel.name
            cell.contentView.addSubview(senderLbl)
            print("aaaaaaaaaaa")
            print(senderLbl.text)
        }
        
        //  活动时间
        let dateformate = NSDateFormatter()
        dateformate.dateFormat = "yyyy-MM-dd HH:mm"
        let date = NSDate(timeIntervalSince1970: NSTimeInterval(activity_listModel.create_time!)!)
        let str:String = dateformate.stringFromDate(date)
        let timeLbl = UILabel()
        timeLbl.frame = CGRectMake(110, height+image_h+10, WIDTH - 120, 20)
        timeLbl.textAlignment = NSTextAlignment.Right
        timeLbl.font = timefont
        timeLbl.textColor = timeColor
        timeLbl.text = str
        cell.contentView.addSubview(timeLbl)
        
        let line = UILabel()
        line.frame = CGRectMake(1, height + 39.5 + image_h, WIDTH - 2, 0.5)
        line.backgroundColor = UIColor.lightGrayColor()
        cell.addSubview(line)
        
        let baoming = UILabel()
        baoming.frame = CGRectMake(15, height + 50 + image_h, WIDTH - 30, 20)
        baoming.text = "已报名\(self.apply_countSource.activityList.count)"
        baoming.font=UIFont.systemFontOfSize(15)
        baoming.textColor = UIColor.orangeColor()
        if activity_listModel.starttime != "0" {
            
            cell.addSubview(baoming)
        }
        
        let state = UILabel()
        state.frame = CGRectMake(WIDTH - 70, height + 50 + image_h, 60, 20)
        cell.addSubview(state)
        
        var answerInfo = NSString()
        for j in 0 ..< self.apply_countSource.activityList.count {
            answerInfo = self.apply_countSource.activityList[j].userid!
        }
        let userid = NSUserDefaults.standardUserDefaults()
        let uid = userid.stringForKey("userid")
        if answerInfo != uid {
//            state.text = "未报名"
//            state.textColor = UIColor.orangeColor()
        }else{
            state.text = "已报名"
            state.font=UIFont.systemFontOfSize(15)
            state.textColor = UIColor(red: 155/255, green: 229/255, blue: 180/255, alpha: 1)
        }
        
        let view = UIView()
        view.frame = CGRectMake(0, height + 80 + image_h, WIDTH, 20)
        view.backgroundColor = RGBA(242.0, g: 242.0, b: 242.0, a: 1)
        cell.addSubview(view)
        
        
        
        //  已报名
//        cell.signUpLbl.text = "已报名\(activityInfo.readcount!)"

        return cell
    }
//    分区头的高度
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 0.01
    }
    
    func clickBtn(sender:CustomBtn){
        let activityInfo = self.activitySource.activityList[sender.tag]
        let detailsVC = PicDetailViewController()

        detailsVC.activitySource = activityInfo
        detailsVC.activity_listSource = activity_listList(activityInfo.activity_list!)
        detailsVC.apply_countSource = apply_countList(activityInfo.apply_count!)
        detailsVC.picSource = picList(activityInfo.pic!)
        detailsVC.count = sender.flag!
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        let activityInfo = self.activitySource.activityList[indexPath.row]
        //  进行传值
        let detailsVC = QCDetailsClassActiveVC()
        detailsVC.id = activityInfo.activity_id
        detailsVC.activitySource = activityInfo
        detailsVC.activity_listSource = activity_listList(activityInfo.activity_list!)
        detailsVC.apply_countSource = apply_countList(activityInfo.apply_count!)
        detailsVC.picSource = picList(activityInfo.pic!)
//        detailsVC.user_Source = user_List(activity_listModel.user_info!)
        self.navigationController?.pushViewController(detailsVC, animated: true)
        
        
    }
//    点赞
    func dianZan(sender:UIButton){
        let btn:UIButton = sender
        let activityInfo = self.activitySource.activityList[btn.tag]
        if btn.selected {
            btn.selected = false
            self.xuXiaoDianZan(activityInfo.id!)
        }else{
            btn.selected = true
            self.getDianZan(activityInfo.id!)
        }
        
    }
    //    去点赞
    func getDianZan(id:String){
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=school&a=SetLike"
        let userid = NSUserDefaults.standardUserDefaults()
        let uid = userid.stringForKey("userid")
        let param = [
            "id":id,
            "userid":uid!,
            "type":5
        ]
        Alamofire.request(.GET, url, parameters: param as? [String : AnyObject]).response { request, response, json, error in
            if(error != nil){
            }
            else{
                print("request是")
                print(request!)
                print("====================")
                let status = MineModel(JSONDecoder(json!))
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
                    hud.labelText = "点赞成功"
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
//                    刷新
                    self.GetDate()
                }
                
            }
            
        }
        
    }
    //    取消点赞
    func xuXiaoDianZan(id:String){
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=school&a=ResetLike"
        let userid = NSUserDefaults.standardUserDefaults()
        let uid = userid.stringForKey("userid")
        let param = [
            "id":id,
            "userid":uid!,
            "type":5
        ]
        Alamofire.request(.GET, url, parameters: param as? [String : AnyObject]).response { request, response, json, error in
            if(error != nil){
            }
            else{
                print("request是")
                print(request!)
                print("====================")
                let status = MineModel(JSONDecoder(json!))
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
                    hud.labelText = "取消点赞"
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                    self.GetDate()
                }
                
            }
            
        }
    }
//    评论
    func pingLun(sender:UIButton){
        let btn:UIButton = sender
        let activityInfo = self.activitySource.activityList[btn.tag]
        let vc = CAPLViewController()
        vc.id = String(activityInfo.id!)
        self.navigationController?.pushViewController(vc, animated: true)
    }


}
