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
//        http://wxt.xiaocool.net/index.php?g=apps&m=index&a=MessageAddress&userid=597
        let defalutid = NSUserDefaults.standardUserDefaults()
        let uid = defalutid.stringForKey("userid")
        let url = apiUrl+"MessageAddress"
        let param = [
            "userid":uid!
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
                    self.addSource = AddList(status.data!)
//                    将分区组的标题和每个分区的cell的数目作为字典存起来
                    if self.addSource.count != 0{
                        for i in 0..<self.addSource.count {
                            let addInfo = self.addSource.objectlist[i]
//                            let teacherList = self.addSource.objectlist[i]
                            self.teacherSource = TeaList(addInfo.teacherinfo!)
                            self.dic.setValue(self.teacherSource.count, forKey:addInfo.classname! )
                        }
                    }
                    self.table.reloadData()
                }
            }
        }
        
    }
//    分区数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.addSource.count
    }
//    分区标题
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        let addInfo = self.addSource.objectlist[section]
        return addInfo.classname!
    }
//    每个分区的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let addInfo = self.addSource.objectlist[section]
        let str: String = addInfo.classname!
        let num = dic[str] as! Int
        return num
    }
//    单元格
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AddressCell", forIndexPath: indexPath) as! AddressBookTableViewCell
        cell.selectionStyle = .None

        let teacherList = self.addSource.objectlist[indexPath.section]
        self.teacherSource = TeaList(teacherList.teacherinfo!)
        let teacherInfo = self.teacherSource.objectlist[indexPath.row]
        cell.nameLbl.text = teacherInfo.name
        cell.numberBtn.setTitle(teacherInfo.phone, forState: .Normal)
        //  设置电话的图标
        cell.phoneButton.setTitle(teacherInfo.phone, forState: .Normal)
        //  信息按钮添加点击事件
        cell.phoneButton.addTarget(self, action: #selector(AddressBookTableViewController.callNumber(_:)), forControlEvents: .TouchUpInside)
        
        
//        cell.messageButton.setTitle(String(indexPath), forState: .Normal)
        cell.messageButton.tag = indexPath.row
        cell.messageButton.addTarget(self, action: #selector(messageAction(_:)), forControlEvents: .TouchUpInside)

        return cell
    }
//    分区头的高度
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 30.0
    }
//    单元格的点击事件（聊天）
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //  聊天事件
        
        //  聊天事件
//        let addInfo = self.addSource.objectlist[indexPath.section]
//        self.teacherSource = TeaList(addInfo.teacherinfo!)
//        let teacherInfo = self.teacherSource.objectlist[indexPath.row]
//        let chatView = ChatViewController(conversationChatter: teacherInfo.id!, conversationType: EMConversationType.eConversationTypeChat)
//        chatView.title = teacherInfo.name!
//        self.navigationController?.pushViewController(chatView, animated: true)
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
        let addInfo = self.addSource.objectlist[0]
        self.teacherSource = TeaList(addInfo.teacherinfo!)
        let teacherInfo = self.teacherSource.objectlist[index]
        let chatView = ChatViewController(conversationChatter: teacherInfo.id!, conversationType: EMConversationType.eConversationTypeChat)
        chatView.title = teacherInfo.name!
        self.navigationController?.pushViewController(chatView, animated: true)

    }

}
