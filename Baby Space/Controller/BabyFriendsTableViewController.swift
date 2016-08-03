//
//  BabyFriendsTableViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/5/27.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import XWSwiftRefresh

class BabyFriendsTableViewController: UITableViewController,UISearchBarDelegate{

    
    @IBOutlet weak var searchBar: UISearchBar!//搜索框
    @IBOutlet var tableSource: UITableView!
    var teacherSource = BabyFirendList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.hidden = true
        searchBar.delegate = self
        GetDate()
        
        self.DropDownUpdate()
        
    }
    //    开始刷新
    func DropDownUpdate(){
        self.tableSource.headerView = XWRefreshNormalHeader(target: self, action: #selector(BabyFriendsTableViewController.GetDate))
        self.tableSource.reloadData()
        self.tableSource.headerView?.beginRefreshing()
    }
//    加载数据
    func GetDate(){

        //  http://wxt.xiaocool.net/index.php?g=apps&m=student&a=getfriendlist&studentid=682
        //下面两句代码是从缓存中取出userid（入参）值
        let defalutid = NSUserDefaults.standardUserDefaults()
        let sid = defalutid.stringForKey("chid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=getfriendlist"
        let param = [
            "studentid":sid!,
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
                    messageHUD(self.view, messageData: status.errorData!)
                }
                if(status.status == "success"){
                    self.teacherSource = BabyFirendList(status.data!)
                    
                    self.tableSource.reloadData()
                    self.tableSource.headerView?.endRefreshing()
                }
            }
        }
    }
    
//    行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teacherSource.count
    }
//    单元格
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BabyFriendsCell", forIndexPath: indexPath) as! BabyFriendsTableViewCell
//        赋值
        cell.selectionStyle = .None
        //  添加箭头
        cell.accessoryType = .DisclosureIndicator
        let teacherInfo = self.teacherSource.objectlist[indexPath.row]
//        cell.nameLbl.text = teacherInfo.name
////        头像
//        let imgUrl = imageUrl + teacherInfo.photo!
//        let photourl = NSURL(string: imgUrl)
//        cell.headImageView.yy_setImageWithURL(photourl, placeholder: UIImage(named: "Logo.png"))
        cell.fillCellWithModel(teacherInfo)
        cell.contentLabel.text = nil
        
        return cell
    }
//    行高
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
//    单元格点击事件（老师点评）
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let teacherInfo = self.teacherSource.objectlist[indexPath.row]
//        let vc = TCommentsViewController()
//        vc.teacherid = teacherInfo.id
//        vc.title = "\(teacherInfo.name!)老师点评记录"
//        self.navigationController?.pushViewController(vc, animated: true)
        
        //  得到ID
        let teacherInfo = self.teacherSource.objectlist[indexPath.row]
        let id = teacherInfo.id
        //  进行正向传值
        
    }
// MARK: －－－UISearchBarDelegate－－－－－（搜查框的代理方法）
    //    搜索
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        if searchText == ""{
        }else{
            for teacherInfo in self.teacherSource.objectlist {
                let nameStr:String = teacherInfo.name!
                //  点击旁边的内容则取消搜索内容并且返回原来的页面
                if nameStr.lowercaseString.hasPrefix(searchText.lowercaseString){
                    self.teacherSource.objectlist.removeAll()
                    self.teacherSource.objectlist.append(teacherInfo)
                }
            }
        }
        self.tableSource.reloadData()
    }

}
