//
//  GroupNewsViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/6/14.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import YYWebImage
import XWSwiftRefresh
import MBProgressHUD

class GroupNewsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let table = UITableView()
    var messageSource = sendMessageList()
    var messagesSource = sendMessagesList()
    var photoSource = QCPhotoList()

    
//    var homeworkSource = HomeworkList()
//    var dianzanSource = DianZanList()
//    var commentSource = HCommentList()
    let arrayPeople = NSMutableArray()
    
    override func viewWillAppear(animated: Bool) {
        //  是否显示分栏控制器
        self.tabBarController?.tabBar.hidden = true
        //  下拉刷新
//        self.DropDownUpdate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        table.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .None
        table.backgroundColor = RGBA(242.0, g: 242.0, b: 242.0, a: 1)
        self.view.addSubview(table)
        
        table.registerNib(UINib.init(nibName: "GroupNewsTableViewCell", bundle: nil), forCellReuseIdentifier: "GroupNewsCellID")
    }
//    加载数据
    func loadData(){
    
    //  http://wxt.xiaocool.net/index.php?g=Apps&m=Message&a=user_reception_message&receiver_user_id=682
//        
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
                    self.messageSource = sendMessageList(status.data!)
//                    self.messagesSource = sendMessagesList(status.data!)
//                    print(self.messagesSource.count)
//                    print(self.messagesSource)
//                    self.photoSource = QCPhotoList(status.data!)
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
        return messageSource.count
    }
//    行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }
//    单元格
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GroupNewsCellID", forIndexPath: indexPath)
            as! GroupNewsTableViewCell
        cell.selectionStyle = .None
        let messageInfo = self.messageSource.homeworkList[indexPath.row]
        let messagesInfo = self.messagesSource.homeworkList[indexPath.row]
//        let messagesInfo = sendMessagesList(messageInfo.send_message!)
//        self.messagesSource = DianZanList(selfGrownInfo.like!)
        
//        self.messagesSource = sendMessageList(messageInfo.send_message!)

        let photoInfo = self.photoSource.homeworkList[indexPath.row]
        
        //  内容
        cell.contentLabel.text = messagesInfo.message_content
        print(messagesInfo.message_content)
        
//        cell.timeLabel.text = messagesInfo.message_time
        //  总数
        cell.countButton.setTitle("总发\(String(messageInfo.send_num)))", forState: .Normal)
        //  图片
        if photoInfo.picture_url != nil{
            let imgUrl = imageUrl + photoInfo.picture_url!
            cell.imageView1.sd_setImageWithURL(NSURL.init(string: imgUrl), placeholderImage: UIImage.init(named: "园所公告背景.png"))
        }
        
        //  时间
//        let dateformate = NSDateFormatter()
//        dateformate.dateFormat = "yyyy-MM-dd HH:mm"
//        let date = NSDate(timeIntervalSince1970: NSTimeInterval(messagesInfo.message_time!)!)
//        let str:String = dateformate.stringFromDate(date)
//        cell.timeLabel.text = str
        
        cell.teacherLabel.text = messagesInfo.send_user_name
//
//        cell.titleLbl.text = homeworkInfo.title
//        cell.contentLbl.text = messagesInfo.message_content
//
//        let imgUrl = imageUrl + homeworkInfo.photo!
//        let photourl = NSURL(string: imgUrl)
//        cell.bigImageView.yy_setImageWithURL(photourl, placeholder: UIImage(named: "园所公告背景.png"))
//        cell.senderLbl.text = homeworkInfo.username
        
//        cell.readBtn.setTitle("已读\(String(homeworkInfo.readcount!)) 未读\(String(homeworkInfo.allreader!-homeworkInfo.readcount!))", forState: .Normal)
//        cell.readBtn.addTarget(self, action: #selector(HomeworkViewController.readBtn(_:)), forControlEvents: .TouchUpInside)
//        cell.readBtn.tag = indexPath.row
//        点赞
//        cell.dianzanBtn.addTarget(self, action: #selector(GroupNewsViewController.dianZan(_:)), forControlEvents: .TouchUpInside)
//        cell.dianzanBtn.tag = indexPath.row
//        
//        cell.pinglunBtn.addTarget(self, action: #selector(HomeworkViewController.pingLun(_:)), forControlEvents: .TouchUpInside)
//        cell.pinglunBtn.tag = indexPath.row
//        
//        let date = NSDate(timeIntervalSince1970: NSTimeInterval(homeworkInfo.create_time!)!)
//        let str:String = dateformate.stringFromDate(date)
//        cell.timeLbl.text = str
        
//        //        自适应行高
//        let options : NSStringDrawingOptions = NSStringDrawingOptions.UsesLineFragmentOrigin
//        let screenBounds:CGRect = UIScreen.mainScreen().bounds
//        let boundingRect = String(cell.contentLbl.text).boundingRectWithSize(CGSizeMake(screenBounds.width, 0), options: options, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(17)], context: nil)
//        //        判断是有人点赞
//        self.dianzanSource = DianZanList(homeworkInfo.dianzanlist!)
//        if self.dianzanSource.count == 0 {
//            cell.zanListLbl.text = "0人点赞"
//            table.rowHeight = boundingRect.size.height + 391
//        }else{
//            //                先清空
//            arrayPeople.removeAllObjects()
//            //循环遍历点赞数量，对比是否自己点过赞
//            for i in 0..<dianzanSource.count{
//                let dianzanInfo = self.dianzanSource.dianzanlist[i]
//                //如果点过赞，则显示点赞图标
//                let userid = NSUserDefaults.standardUserDefaults()
//                let uid = userid.stringForKey("userid")
//                if(dianzanInfo.dianZanId == uid){
//                    cell.dianzanBtn.selected = true
//                    cell.dianzanBtn.setBackgroundImage(UIImage(named: "已点赞"), forState:.Normal)
//                }else{//如果没点过赞，显示灰色图标
//                    cell.dianzanBtn.selected = false
//                    cell.dianzanBtn.setBackgroundImage(UIImage(named: "点赞"), forState: .Normal)
//                }
//            }
//            if dianzanSource.count>4{
//                for i in 0..<4{
//                    let dianzanInfo = self.dianzanSource.dianzanlist[i]
//                    arrayPeople.addObject(dianzanInfo.dianZanName!)
//                    let peopleArray = arrayPeople.componentsJoinedByString(",")
//                    cell.zanListLbl.text = "\(peopleArray)等\(dianzanSource.count)人觉得很赞"
//                }
//            }else{
//                for i in 0..<dianzanSource.count{
//                    let dianzanInfo = self.dianzanSource.dianzanlist[i]
//                    arrayPeople.addObject(dianzanInfo.dianZanName!)
//                    let peopleArray = arrayPeople.componentsJoinedByString(",")
//                    cell.zanListLbl.text = "\(peopleArray)等\(dianzanSource.count)人觉得很赞"
//                }
//            }
//            
//            table.rowHeight = boundingRect.size.height + 391
//        }
        
        return cell
    }
//    单元格点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let vc = GroupNewsDetailViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    //    点赞c
    func dianZan(sender:UIButton){
        let btn:UIButton = sender
    
//        let homeworkInfo = self.homeworkSource.homeworkList[btn.tag]
        if btn.selected {
            btn.selected = false
//            self.xuXiaoDianZan(homeworkInfo.id!)
        }else{
            btn.selected = true
//            self.getDianZan(homeworkInfo.id!)
        }
    }
//    //    去点赞
//    func getDianZan(id:String){
//        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=school&a=SetLike"
//        let userid = NSUserDefaults.standardUserDefaults()
//        let uid = userid.stringForKey("userid")
//        let param = [
//            "id":id,
//            "userid":uid!,
//            "type":2
//        ]
//        Alamofire.request(.GET, url, parameters: param as? [String : AnyObject]).response { request, response, json, error in
//            if(error != nil){
//            }
//            else{
//                print("request是")
//                print(request!)
//                print("====================")
//                let status = MineModel(JSONDecoder(json!))
//                print("状态是")
//                print(status.status)
//                if(status.status == "error"){
//                    
//                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//                    hud.mode = MBProgressHUDMode.Text;
//                    hud.labelText = status.errorData
//                    hud.margin = 10.0
//                    hud.removeFromSuperViewOnHide = true
//                    hud.hide(true, afterDelay: 1)
//                }
//                
//                if(status.status == "success"){
//                    //self.dianZanBtn.selected == true
//                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//                    hud.mode = MBProgressHUDMode.Text;
//                    hud.labelText = "点赞成功"
//                    hud.margin = 10.0
//                    hud.removeFromSuperViewOnHide = true
//                    hud.hide(true, afterDelay: 1)
//                    self.loadData()
//                }
//                
//            }
//            
//        }
//        
//    }
//    //    取消点赞
//    func xuXiaoDianZan(id:String){
//        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=school&a=ResetLike"
//        let userid = NSUserDefaults.standardUserDefaults()
//        let uid = userid.stringForKey("userid")
//        let param = [
//            "id":id,
//            "userid":uid!,
//            "type":2
//        ]
//        Alamofire.request(.GET, url, parameters: param as? [String : AnyObject]).response { request, response, json, error in
//            if(error != nil){
//            }
//            else{
//                print("request是")
//                print(request!)
//                print("====================")
//                let status = MineModel(JSONDecoder(json!))
//                print("状态是")
//                print(status.status)
//                if(status.status == "error"){
//                    
//                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//                    hud.mode = MBProgressHUDMode.Text;
//                    hud.labelText = status.errorData
//                    hud.margin = 10.0
//                    hud.removeFromSuperViewOnHide = true
//                    hud.hide(true, afterDelay: 1)
//                }
//                
//                if(status.status == "success"){
//                    //self.dianZanBtn.selected == true
//                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//                    hud.mode = MBProgressHUDMode.Text;
//                    hud.labelText = "取消点赞"
//                    hud.margin = 10.0
//                    hud.removeFromSuperViewOnHide = true
//                    hud.hide(true, afterDelay: 1)
//                    self.loadData()
//                }
//                
//            }
//            
//        }
//    }
    
}
