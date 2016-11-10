//
//  AddressBookTableViewController.swift
//  WXT_Parents
//
//  Created by 牛尧 on 16/2/24.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
class AddressBookTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    
    let table = UITableView()
    var addSource = AddList()
    var teacherSource =  TeaList()
    var dic = NSMutableDictionary()
    var index = Int()
    
    var dataSource = TeaList()
//    var dataSource3 = Array<chatInfo> ()
    var dataSource3 = chatList()
    var str = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createTable()
        GetDate()
        
    }


    
//    创建表
    func createTable(){
        table.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-40)
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 70
        table.separatorStyle = .None
        self.view.addSubview(table)
//        注册cell
        table.registerNib(UINib.init(nibName: "AddressBookTableViewCell", bundle: nil), forCellReuseIdentifier: "AddressCell")
    }
//    获取通讯录
    func GetDate(){
//        http://wxt.xiaocool.net/index.php?g=apps&m=teacher&a=getstudentclasslistandteacherlist&studentid=661
        let defalutid = NSUserDefaults.standardUserDefaults()
        let uid = defalutid.stringForKey("chid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=teacher&a=getstudentclasslistandteacherlist"
        let param = [
            "studentid":uid!
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
//                    self.addSource = AddList(status.data!)
////                    将分区组的标题和每个分区的cell的数目作为字典存起来
//                    if self.addSource.count != 0{
//                        for i in 0..<self.addSource.count {
//                            let addInfo = self.addSource.objectlist[i]
////                            let teacherList = self.addSource.objectlist[i]
//                            self.teacherSource = TeaList(addInfo.teacherinfo!)
//                            self.dic.setValue(self.teacherSource.count, forKey:addInfo.classname! )
//                        }
//                    }
                
                    self.dataSource = TeaList(status.data!)
                    self.table.reloadData()
                }
            }
        }
        
    }
//    分区数
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return self.addSource.count
//    }
//    分区标题
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
//        let addInfo = self.addSource.objectlist[section]
//        return addInfo.classname!
//    }
//    每个分区的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let addInfo = self.addSource.objectlist[section]
//        let str: String = addInfo.classname!
//        let num = dic[str] as! Int
//        return num
        if self.dataSource.objectlist.count == 0 {
            return 1
        }else{
            
            return self.dataSource.objectlist[0].teacherlist.count
        }
    }
//    单元格
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AddressCell", forIndexPath: indexPath) as! AddressBookTableViewCell
        cell.selectionStyle = .None

//        let teacherList = self.addSource.objectlist[indexPath.section]
//        self.teacherSource = TeaList(teacherList.teacherinfo!)
//        let teacherInfo = self.teacherSource.objectlist[indexPath.row]
        if self.dataSource.objectlist.count != 0 {
            let mode = self.dataSource.objectlist[0]
            let model = mode.teacherlist[indexPath.row]
            cell.nameLbl.text = model.name
            cell.numberBtn.setTitle(model.phone, forState: .Normal)
            //  设置电话的图标
            cell.phoneButton.setTitle(model.phone, forState: .Normal)
            //  信息按钮添加点击事件
            cell.phoneButton.addTarget(self, action: #selector(AddressBookTableViewController.callNumber(_:)), forControlEvents: .TouchUpInside)
            
            
            //        cell.messageButton.setTitle(String(indexPath), forState: .Normal)
            cell.messageButton.tag = indexPath.row
            cell.messageButton.addTarget(self, action: #selector(messageAction(_:)), forControlEvents: .TouchUpInside)
            
            let pi = model.photo
            let imgUrl = microblogImageUrl + pi
            let photourl = NSURL(string: imgUrl)
            cell.headImageView.sd_setImageWithURL(photourl, placeholderImage: UIImage(named: "默认头像"))
            cell.headImageView.layer.cornerRadius = 25
            cell.headImageView.clipsToBounds = true
            //分割线
            let lineView = UIView()
            lineView.frame = CGRectMake(0, 69.5, WIDTH, 0.5)
            lineView.backgroundColor = tableView.separatorColor
            cell.contentView.addSubview(lineView)
        }

        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
//    打电话
    func callNumber(sender:AnyObject){
        let btn:UIButton = sender as! UIButton
        var phone = String()
        phone = "telprompt:\(String(btn.currentTitle!))"
        UIApplication.sharedApplication().openURL(NSURL.init(string: phone)!)
    }
    func messageAction(sender:AnyObject){
        index = sender.tag
//        let addInfo = self.addSource.objectlist[0]
//        self.teacherSource = TeaList(addInfo.teacherinfo!)
//        let teacherInfo = self.teacherSource.objectlist[index]
        let mode = self.dataSource.objectlist[0].teacherlist
        let model = mode[index]
        let chatView = ChatViewController(conversationChatter: model.id, conversationType: EMConversationType.eConversationTypeChat)
        chatView.title = model.name
//        self.navigationController?.pushViewController(chatView, animated: true)
        let receive_uid = model.id
        self.str = model.name
        GetChatMessage(receive_uid)
    }
    
    func GetChatMessage(receive_uid:String){
        let defalutid = NSUserDefaults.standardUserDefaults()
        let chid = defalutid.stringForKey("userid")
        let studentid = defalutid.stringForKey("chid");
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=message&a=xcGetChatData"
        let param = [
            "send_uid":chid!,
            "receive_uid":receive_uid,
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
                        vc.receive_uid = receive_uid
                        print(vc.receive_uid)
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }else{
                        vc.receive_uid = receive_uid
                        vc.titleTop = self.str
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                    
                }
            }
        }
    }

}
