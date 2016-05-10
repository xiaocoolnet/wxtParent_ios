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

class LeaveteacherViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    var studentName:String?
    var studentid:String?
    let table = UITableView()
    var teacherSource = TeacherList()
    var classSource = ClassListModel()
    var dic = NSMutableDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "教师列表"
        self.view.backgroundColor = UIColor.whiteColor()
        self.createTable()
        self.getClassData()
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
    //    获取班级列表
    func getClassData(){
        //http://wxt.xiaocool.net/index.php?g=apps&m=student&a=getclasslist&studentid=597
        
        //下面两句代码是从缓存中取出userid（入参）值
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=getclasslist"
        let param = [
            "studentid":"597"//有数据的时候就用传过来的studentid
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
                    self.classSource = ClassListModel(status.data!)
                    //                   获取教师列表
                    for i in 0..<self.classSource.count {
                        let classInfo = self.classSource.classList[i]
                        self.getTeacherData(classInfo.classid!)
                    }
                }
            }
        }
    }
    //    获取老师的列表
    func getTeacherData(classid:String) {
        //http://wxt.xiaocool.net/index.php?g=apps&m=student&a=getclassteacherlist&studentid=597&classid=1
        
        //下面两句代码是从缓存中取出userid（入参）值
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=getclassteacherlist"
        let param = [
            "studentid":"597",//有数据的时候就用传过来的studentid
            "classid":classid
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
                    self.teacherSource = TeacherList(status.data!)
                    //                    将分区组标题和每组的个数存成字典
                    for i in 0..<self.classSource.count {
                        let classInfo = self.classSource.classList[i]
                        self.dic.setValue(self.teacherSource.count, forKey:classInfo.classname! )
                    }
                    self.table.reloadData()
                }
            }
        }
    }
    //    分区数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.classSource.count
    }
    //    分区标题
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        let classInfo = self.classSource.classList[section]
        return classInfo.classname!
    }
    //    每组的个数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let classInfo = self.classSource.classList[section]
        let str: String = classInfo.classname!
        let num = dic[str] as! Int
        return num
    }
    //    行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    //    单元格
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TeacherInfoID", forIndexPath: indexPath)
            as! TeacherInfoTableViewCell
        cell.selectionStyle = .None
        let teacherInfo = self.teacherSource.teacherList[indexPath.row]
        cell.nameLbl.text = teacherInfo.name
        let imgUrl = imageUrl + teacherInfo.avatar!
        let photourl = NSURL(string: imgUrl)
        cell.headImageView.yy_setImageWithURL(photourl, placeholder: UIImage(named: "Logo.png"))
        return cell
    }
    //    单元格点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let teacherInfo = self.teacherSource.teacherList[indexPath.row]
        let vc = WriteQJViewController()
        vc.studentid = self.studentid!
        vc.teacherid = teacherInfo.id!
        vc.teacherName = teacherInfo.name!
        vc.studentName = self.studentName!
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
