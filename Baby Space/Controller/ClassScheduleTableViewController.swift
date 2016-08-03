//
//  ClassScheduleTableViewController.swift
//  WXT_Parents
//
//  Created by 牛尧 on 16/2/24.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import XWSwiftRefresh
import MBProgressHUD

//  班级课程的界面

//  需要进行网络数据请求得到对应的课程

class ClassScheduleTableViewController: UITableViewController {
   
   
    @IBOutlet var tableSource: UITableView!
    
    var dataSource = NSMutableArray()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GETData()
        //  刷新
        tableView.registerClass(ClassScheduleTableViewCell.self, forCellReuseIdentifier: "cell")
    }
//    func GETData(){
////        http://wxt.xiaocool.net/index.php?g=apps&m=school&a=ClassSyllabus&schoolid=1&classid=2
//        //下面两句代码是从缓存中取出userid（入参）值
//        
//        let defalutid = NSUserDefaults.standardUserDefaults()
//        let uid = defalutid.stringForKey("classid")
//        let schoolid = defalutid.stringForKey("schoolid")
//        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=school&a=ClassSyllabus"
//        let param = [
//            "schoolid":schoolid,
//            "classid":uid
//        ]
//        Alamofire.request(.GET, url, parameters: param as? [String:String]).response { request, response, json, error in
//            if(error != nil){
//            }
//            else{
//                print("request是")
//                print(request!)
//                print("====================")
//                let status = BabyClassModel(JSONDecoder(json!))
//                print("状态是")
//                print(status.status)
//                if(status.status == "error"){
//                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//                    hud.mode = MBProgressHUDMode.Text
//                    hud.labelText = status.errorData
//                    hud.margin = 10.0
//                    hud.removeFromSuperViewOnHide = true
//                    hud.hide(true, afterDelay: 1)
//                }
//                if(status.status == "success"){
//                    let info:BabyClassInfo = response as! BabyClassInfo
//                    self.dataSource.addObject(info)
//                    self.tableSource.reloadData()
//                    self.tableSource.headerView?.endRefreshing()
//                }
//            }
//        }
//
//    }
    
    func GETData(){
        //        http://wxt.xiaocool.net/index.php?g=apps&m=index&a=GetChange_sta_wei&stuid=599
        //        http://wxt.xiaocool.net/index.php?g=apps&m=index&a=RecordWeight&stuid=599&weight=40
        let defalutid = NSUserDefaults.standardUserDefaults()
        let uid = defalutid.stringForKey("classid")
        let schoolid = defalutid.stringForKey("schoolid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=school&a=ClassSyllabus"
        let param = [
                "schoolid":schoolid,
                "classid":uid
            ]

        Alamofire.request(.GET, url, parameters: param as? [String:String]).response { request, response, json, error in
            if(error != nil){
            }
            else{
                print("request是")
                print(request!)
                print("====================")
                let result = BabyClassModel(JSONDecoder(json!))
                print("状态是")
                print(result.status)
                if(result.status == "error"){
                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.mode = MBProgressHUDMode.Text;
                    hud.labelText = result.errorData
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                
                if(result.status == "success"){
                    print("Success")
                    let info:Array = result.data!.mon
                    let info1:Array = result.data!.tu
                    let info2:Array = result.data!.we
                    let info3:Array = result.data!.th
                    let info4:Array = result.data!.fri
                    let info5:Array = result.data!.sat
                    let info6:Array = result.data!.sun
                    self.dataSource.addObject(info)
                    self.dataSource.addObject(info1)
                    self.dataSource.addObject(info2)
                    self.dataSource.addObject(info3)
                    self.dataSource.addObject(info4)
                    self.dataSource.addObject(info5)
                    self.dataSource.addObject(info6)
                    print(self.dataSource.count)
                    print(info)
                }
                
            }
            
        }
        
    }

//    分区数
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 7
        
    }
//    每个分区的cell数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return  1
    }
    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 260
//    }
//    单元格
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ClassScheduleTableViewCell
        cell.selectionStyle = .None
        tableView.separatorColor = .None
        
//        let model = self.dataSource[indexPath.section] as! BabyClassInfo
//        var dayInfo = Array<MonInfo>()
//        if indexPath.section == 0 {
//            dayInfo = model.mon
//        }else if indexPath.section == 1{
//            dayInfo = model.tu
//        }else if indexPath.section == 2{
//            dayInfo = model.we
//        }else if indexPath.section == 3{
//            dayInfo = model.th
//        }else if indexPath.section == 4{
//            dayInfo = model.fri
//        }else if indexPath.section == 5{
//            dayInfo = model.sat
//        }else if indexPath.section == 6{
//            dayInfo = model.sun
//        }
//        cell.oneLable.text = dayInfo[0].one
//        cell.oneLable.text = dayInfo[0].two
//        cell.oneLable.text = dayInfo[0].three
//        cell.oneLable.text = dayInfo[0].four
//        cell.oneLable.text = dayInfo[0].five
//        cell.oneLable.text = dayInfo[0].six
//        cell.oneLable.text = dayInfo[0].seven
//        cell.oneLable.text = dayInfo[0].eight


        
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UILabel()
        view.backgroundColor = UIColor.greenColor()
        view.frame = CGRectMake(0, 10, WIDTH, 40)
        let array:Array<String> = ["星期一","星期二","星期三","星期四","星期五","星期六","星期日"]
        view.text = array[section]
        return view
    }
    
    

}
