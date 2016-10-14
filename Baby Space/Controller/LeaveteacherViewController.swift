//
//  LeaveteacherViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/5/5.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

protocol ToolTwoProrocol1:NSObjectProtocol{
    //代理方法
    func didRecieveTeacherInfo(teacherid:String,teacherName:String)
}

class LeaveteacherViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    var studentName:String?
    var studentid:String?
    let table = UITableView()
    var addSource = AddList()
    var teacherSource =  TeaList()
    var dataSource = TeaList()
    var dic = NSMutableDictionary()
    weak var delegate:ToolTwoProrocol1?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.hidden = true

        self.title = "教师列表"
        self.view.backgroundColor = UIColor.whiteColor()
        self.createTable()
        self.GetDate()
    }
    //创建表
    func createTable(){
        table.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .None
        self.view.addSubview(table)
        
        table.registerNib(UINib.init(nibName: "TeacherInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "TeacherInfoID")
    }
//    加载数据
    func GetDate(){
//        http://wxt.xiaocool.net/index.php?g=apps&m=teacher&a=getstudentclasslistandteacherlist&studentid=661
//        let defalutid = NSUserDefaults.standardUserDefaults()
//        let uid = defalutid.stringForKey("chid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=teacher&a=getstudentclasslistandteacherlist"
        let param = [
            "studentid":self.studentid
        ]
        Alamofire.request(.GET, url, parameters: param as?[String:String]).response { request, response, json, error in
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
                    self.dataSource = TeaList(status.data!)
                    self.table.reloadData()
                }
            }
        }
        
    }
    //    每个分区的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dataSource.objectlist.count == 0 {
            return 1
        }else{
            return self.dataSource.objectlist[0].teacherlist.count
        }
    }
    //    单元格
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TeacherInfoID", forIndexPath: indexPath)
            as! TeacherInfoTableViewCell
        cell.selectionStyle = .None
        
        if self.dataSource.objectlist.count != 0 {
            let model = self.dataSource.objectlist[0].teacherlist[indexPath.row]
            
            cell.nameLbl.text = model.name
            let pi = model.photo
            let imgUrl = microblogImageUrl + pi
            let photourl = NSURL(string: imgUrl)
            cell.headImageView.sd_setImageWithURL(photourl, placeholderImage: UIImage(named: "Logo"))
            
        }
        return cell
    }
    //    行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    //    单元格点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let teacherInfo = self.dataSource.objectlist[0].teacherlist[indexPath.row]
        self.delegate?.didRecieveTeacherInfo(teacherInfo.id, teacherName: teacherInfo.name)
        self.navigationController?.popViewControllerAnimated(true)
    }
}
