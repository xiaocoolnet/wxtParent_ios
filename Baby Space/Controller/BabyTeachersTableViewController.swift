//
//  BabyTeachersTableViewController.swift
//  WXT_Parents
//
//  Created by 牛尧 on 16/2/24.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import XWSwiftRefresh

class BabyTeachersTableViewController: UITableViewController,UISearchBarDelegate{

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var tableSource: UITableView!
    var teacherSource = BabyTeacherList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        GetDate()
        self.DropDownUpdate()
    }
    //    开始刷新
    func DropDownUpdate(){
        self.tableSource.headerView = XWRefreshNormalHeader(target: self, action: #selector(BabyTeachersTableViewController.GetDate))
        self.tableSource.reloadData()
        self.tableSource.headerView?.beginRefreshing()
    }
    func GetDate(){
        let defalutid = NSUserDefaults.standardUserDefaults()
        let sid = defalutid.stringForKey("schoolid")
        let clid = defalutid.stringForKey("classid")
        let url = apiUrl + "OnlineLeaveTeacher"
        let param = [
            //  获取还在所在班级的classid  和 schoolid
            "schoolid":sid!,
            "classid":clid!
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
                    self.teacherSource = BabyTeacherList(status.data!)
                    self.tableSource.reloadData()
                    self.tableSource.headerView?.endRefreshing()
                }
            }
        }
    }
    //行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teacherSource.count
    }
    
    //    单元格
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BabyTeachersCell", forIndexPath: indexPath) as!BabyTeachersTableViewCell
        
        let teacherInfo = self.teacherSource.objectlist[indexPath.row]
        cell.teacherNameLbl.text = teacherInfo.teachername
        cell.messgaeBtn.addTarget(self, action: #selector(BabyTeachersTableViewController.messagePress(_:)), forControlEvents: .TouchUpInside)
        cell.messgaeBtn.tag = indexPath.row
        cell.callBtn.addTarget(self, action: #selector(BabyTeachersTableViewController.callPress(_:)), forControlEvents: .TouchUpInside)
        cell.callBtn.tag = indexPath.row
        
        return cell
    }
    //    －－－－－－－－－－－－－－－－－UISearchBarDelegate－－－－－－－－－－－－－－－－
    //    搜索
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        if searchText == ""{
        }else{
            for teacherInfo in self.teacherSource.objectlist {
                let nameStr:String = teacherInfo.teachername!
                if nameStr.lowercaseString.hasPrefix(searchText.lowercaseString){
                    self.teacherSource.objectlist.removeAll()
                    self.teacherSource.objectlist.append(teacherInfo)
                }
            }
        }
        self.tableSource.reloadData()
    }
    //    发消息
    func messagePress(sender:UIButton){
        let btn:UIButton = sender
        let teacherInfo = self.teacherSource.objectlist[btn.tag]
        let chatView = ChatViewController(conversationChatter: teacherInfo.teacherid!, conversationType: EMConversationType.eConversationTypeChat)
        chatView.title = teacherInfo.teachername!
        self.navigationController?.pushViewController(chatView, animated: true)
    }
    //    打电话
    func callPress(sender:UIButton){
        let btn:UIButton = sender
        let teacherInfo = self.teacherSource.objectlist[btn.tag]
        var phone = String()
        phone = "telprompt:\(String(teacherInfo.teacherphone!))"
        UIApplication.sharedApplication().openURL(NSURL.init(string: phone)!)
    }
}
