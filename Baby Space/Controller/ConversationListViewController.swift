//
//  ConversationListViewController.swift
//  Demo
//
//  Created by zhang on 16/4/28.
//  Copyright © 2016年 xiaocool. All rights reserved.
//

import UIKit
import Alamofire
import YYWebImage
import XWSwiftRefresh
import MBProgressHUD

class ConversationListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    let conversationsArray = NSMutableArray()
    let networkStateView = UIView()
    var lable = UILabel()
    var homework = UILabel()
    let tableView = UITableView()
    var dataSource = MessageList()
    var dataSource3 = chatList()
    var str = String()

    override func viewWillAppear(animated: Bool) {
       
        self.tabBarController?.tabBar.hidden = true
        
        let chid = NSUserDefaults.standardUserDefaults()
        
        if chid.valueForKey("homeworkArr") != nil {
            
            let arr = chid.valueForKey("homeworkArr") as! NSArray
            homework.text = String(arr.count)
        }else{
            homework.removeFromSuperview()
        }
        if homework.text == "0" {
            homework.removeFromSuperview()
        }
        if chid.valueForKey("messageArr") != nil {
            
            let arr = chid.valueForKey("messageArr") as! NSArray
            lable.text = String(arr.count)
        }else{
            lable.removeFromSuperview()
        }
        if lable.text == "0" {
            lable.removeFromSuperview()
        }
       GetMessageList()
    }
    
    func game(count:NSNotification){
//        let arr = count.object as! NSArray
        lable.text = String((count.object as! NSArray).count)
        print("lable =", count.object as? String)
    }
    func daijie(count:NSNotification){
//        let arr = count.object as! NSArray
        homework.text = String((count.object as! NSArray).count)
        print("lable =", count.object as? String)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.daijie(_:)), name: "homeworkArr", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.game(_:)), name: "messageArr", object: nil)
        
        self.title = "聊天列表"
        
        createUI()
        addTableView()
    }
//    创建界面
    func createUI(){
        let v = UIView(frame:CGRectMake(0,0,self.view.frame.size.width,281))
        v.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(v)
        
        let imageView1 = UIImageView(frame:CGRectMake(10,10,50,50))
        imageView1.layer.cornerRadius = 25
        imageView1.image = UIImage(named: "最新消息")
//        v.addSubview(imageView1)
        
        let lbl1 = UILabel(frame:CGRectMake(70,10,100,20))
        lbl1.text = "系统消息"
//        v.addSubview(lbl1)
        
        let lbl11 = UILabel(frame:CGRectMake(70,40,100,20))
        lbl11.text = "最新系统消息"
        lbl11.font = UIFont.systemFontOfSize(14)
        lbl11.textColor = UIColor.lightGrayColor()

        
        let lineview = UIView(frame:CGRectMake(0,70,self.view.frame.size.width,1))
        lineview.backgroundColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1)
//        v.addSubview(lineview)
        
        let imageView2 = UIImageView(frame:CGRectMake(10,10,50,50))
        imageView2.layer.cornerRadius = 25
        imageView2.image = UIImage(named: "最新消息")
        v.addSubview(imageView2)
        
        let lbl2 = UILabel(frame:CGRectMake(70,10,100,20))
        lbl2.text = "群发消息"
        v.addSubview(lbl2)
        let user = NSUserDefaults.standardUserDefaults()
        
        let lbl21 = UILabel(frame:CGRectMake(70,40,100,20))
        let qunfa = user.valueForKey("qunfa") as? String
        if qunfa=="" || qunfa==nil {
            lbl21.text = "暂无消息"
        }else{
        lbl21.text = qunfa
        }
        lbl21.font = UIFont.systemFontOfSize(14)
        lbl21.textColor = UIColor.lightGrayColor()
        v.addSubview(lbl21)
        
        let lineview1 = UIView(frame:CGRectMake(0,70,self.view.frame.size.width,1))
        lineview1.backgroundColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1)
        v.addSubview(lineview1)
        
        let imageView3 = UIImageView(frame:CGRectMake(10,80,50,50))
        imageView3.layer.cornerRadius = 25
        imageView3.image = UIImage(named: "ic_wodezuoye.png")
        v.addSubview(imageView3)
        
        
        lable.frame = CGRectMake(38, 0, 18, 18)
        lable.backgroundColor = UIColor.redColor()
        lable.textColor = UIColor.whiteColor()
        lable.layer.cornerRadius = 9
        lable.layer.masksToBounds = true
        lable.font = UIFont.systemFontOfSize(12)
        lable.textAlignment = NSTextAlignment.Center
        imageView2.addSubview(lable)
        
    
        homework.frame = CGRectMake(38, 0, 18, 18)
        homework.backgroundColor = UIColor.redColor()
        homework.textColor = UIColor.whiteColor()
        homework.layer.cornerRadius = 9
        homework.layer.masksToBounds = true
        homework.font = UIFont.systemFontOfSize(12)
        homework.textAlignment = NSTextAlignment.Center
        imageView3.addSubview(homework)
        
        let lbl3 = UILabel(frame:CGRectMake(70,80,100,20))
        lbl3.text = "我的作业"
        let zuoye = user.valueForKey("zuoye") as? String
        
        v.addSubview(lbl3)
        
        let lbl31 = UILabel(frame:CGRectMake(70,110,100,20))
        if zuoye=="" || zuoye==nil {
            lbl31.text = "暂无消息"
        }else{
        lbl31.text = zuoye
        }
        lbl31.font = UIFont.systemFontOfSize(14)
        lbl31.textColor = UIColor.lightGrayColor()
        v.addSubview(lbl31)
        
        let lineview2 = UIView(frame:CGRectMake(0,140,self.view.frame.size.width,1))
        lineview2.backgroundColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1)
        v.addSubview(lineview2)
        
        let imageView4 = UIImageView(frame:CGRectMake(10,150,50,50))
        imageView4.layer.cornerRadius = 25
        imageView4.clipsToBounds = true
        imageView4.image = UIImage(named: "Logo")
        v.addSubview(imageView4)
        
        let lbl4 = UILabel(frame:CGRectMake(70,150,100,20))
        lbl4.text = "通讯录"
        v.addSubview(lbl4)
        
        let lbl41 = UILabel(frame:CGRectMake(70,180,100,20))
        lbl41.text = "老师通讯录"
        lbl41.font = UIFont.systemFontOfSize(14)
        lbl41.textColor = UIColor.lightGrayColor()
        v.addSubview(lbl41)
        
        let lineview3 = UIView(frame:CGRectMake(0,210,self.view.frame.size.width,1))
        lineview3.backgroundColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1)
        v.addSubview(lineview3)
        
        let btn = UIButton(frame: CGRectMake(0,0,WIDTH,70))
        btn.backgroundColor = UIColor.clearColor()
//        btn.addTarget(self, action: #selector(ConversationListViewController.systemNewsBtn), forControlEvents: .TouchUpInside)
//        v.addSubview(btn)
        
        let btn1 = UIButton(frame: CGRectMake(0,0,WIDTH,70))
        btn1.backgroundColor = UIColor.clearColor()
        btn1.addTarget(self, action: #selector(ConversationListViewController.groupNewsBtn), forControlEvents: .TouchUpInside)
        v.addSubview(btn1)
        
        let btn2 = UIButton(frame: CGRectMake(0,70,WIDTH,70))
        btn2.backgroundColor = UIColor.clearColor()
        btn2.addTarget(self, action: #selector(ConversationListViewController.homeworkBtn), forControlEvents: .TouchUpInside)
        v.addSubview(btn2)
        
        let btn3 = UIButton(frame: CGRectMake(0,140,WIDTH,70))
        btn3.backgroundColor = UIColor.clearColor()
        btn3.addTarget(self, action: #selector(ConversationListViewController.addressBtn), forControlEvents: .TouchUpInside)
        v.addSubview(btn3)
        

    }
//    我的作业
    func homeworkBtn(){
//        let vc = HomeworkViewController()
        let vc = TabViewController()
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
//    通讯录
    func addressBtn(){
        let vc = AddressViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

//    群发消息
    func groupNewsBtn(){
//        let vc = GroupNewsViewController()
        let vc = FSendNewsViewController()
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func addTableView(){
        tableView.frame = CGRectMake(0, 215, WIDTH, HEIGHT - 64 - 215)
        tableView.delegate = self
        tableView.dataSource = self
        //  隐藏线
        tableView.separatorStyle = .None
        self.view.addSubview(tableView)
    }
    
    //    分区数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    //    行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.objectlist.count
    }
    //    行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    //    单元格
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: String(indexPath.row))
        cell.selectionStyle = .None
        let model = self.dataSource.objectlist[indexPath.row]
        
        let imgView = UIImageView.init(frame: CGRectMake(10, 10, 40, 40));
        let pi = model.other_face
        let imgUrl = microblogImageUrl + pi
        let photourl = NSURL(string: imgUrl)
        imgView.layer.cornerRadius = 20
        imgView.clipsToBounds = true
        imgView.sd_setImageWithURL(photourl, placeholderImage: UIImage(named: "Logo"))
        cell.contentView.addSubview(imgView)
        
        let name = UILabel.init(frame: CGRectMake(60, 10, WIDTH - 150, 20));
        name.text = model.other_nickname
        name.font = UIFont.systemFontOfSize(16)
        cell.contentView.addSubview(name)
        
        let time = UILabel.init(frame: CGRectMake(WIDTH - 90, 10, 80, 20))
        time.text = model.create_time
        time.textColor = UIColor.lightGrayColor()
        time.textAlignment = .Right
        time.font = UIFont.systemFontOfSize(13)
        cell.contentView.addSubview(time)
        
        let content = UILabel.init(frame: CGRectMake(60, 35, WIDTH - 70, 20))
        content.textColor = UIColor.lightGrayColor()
        content.text = model.last_content
        content.font = UIFont.systemFontOfSize(14)
        cell.contentView.addSubview(content)
        
        let aview = UIView()
        aview.frame = CGRectMake(0, 59.5, WIDTH, 0.5)
        aview.backgroundColor = RGBA(242.0, g: 242.0, b: 242.0, a: 1)
        cell.contentView.addSubview(aview)
        
        return cell
    }
    
    func GetMessageList(){
        let defalutid = NSUserDefaults.standardUserDefaults()
        let chid = defalutid.stringForKey("userid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=message&a=xcGetChatListData"
        let param = [
            "uid":chid!,
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
                    
                    self.dataSource = MessageList(status.data!)
                    
                    self.tableView.reloadData()
                   
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = self.dataSource.objectlist[indexPath.row]
        
        let defalutid = NSUserDefaults.standardUserDefaults()
        let chid = defalutid.stringForKey("userid")
        let studentid = defalutid.stringForKey("chid");
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=message&a=xcGetChatData"
        let param = [
            "send_uid":chid!,
            "receive_uid":model.chat_uid,
            "studentid":studentid
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
                    let vc = ChetViewController()
                    let dat = NSMutableArray()
                    self.dataSource3 = chatList(status.data!)
                    print(self.dataSource3)
                    if self.dataSource3.objectlist.count != 0{
                        for num in 0...self.dataSource3.objectlist.count-1{
                            let dic = NSMutableDictionary()
                            dic.setObject(self.dataSource3.objectlist[num].id!, forKey: "id")
                            dic.setObject(self.dataSource3.objectlist[num].send_uid!, forKey: "send_uid")
                            dic.setObject(self.dataSource3.objectlist[num].receive_uid!, forKey: "receive_uid")
                            dic.setObject(self.dataSource3.objectlist[num].content!, forKey: "content")
                            dic.setObject(self.dataSource3.objectlist[num].status!, forKey: "status")
                            dic.setObject(self.dataSource3.objectlist[num].create_time!, forKey: "create_time")
                            if self.dataSource3.objectlist[num].send_face != nil{
                                dic.setObject(self.dataSource3.objectlist[num].send_face!, forKey: "send_face")
                            }
                            
                            if self.dataSource3.objectlist[num].send_nickname != nil{
                                dic.setObject(self.dataSource3.objectlist[num].send_nickname!, forKey: "send_nickname")
                            }
                            
                            if self.dataSource3.objectlist[num].receive_face != nil{
                                dic.setObject(self.dataSource3.objectlist[num].receive_face!, forKey: "receive_face")
                            }
                            
                            if self.dataSource3.objectlist[num].receive_nickname != nil{
                                dic.setObject(self.dataSource3.objectlist[num].receive_nickname!, forKey: "receive_nickname")
                            }
                            
                            
                            dat.addObject(dic)
                            
                            //                vc.datasource2.addObject(dic)
                            
                        }
                        
                        print(dat)
                        vc.datasource2 = NSArray.init(array: dat) as Array
                        vc.receive_uid = model.chat_uid
                        print(vc.receive_uid)
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }else{
                        vc.receive_uid = model.chat_uid
                        vc.titleTop = model.other_nickname
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                    
                }
            }
        }

    }
}
