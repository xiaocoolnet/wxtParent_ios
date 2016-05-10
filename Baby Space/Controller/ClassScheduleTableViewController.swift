//
//  ClassScheduleTableViewController.swift
//  WXT_Parents
//
//  Created by 牛尧 on 16/2/24.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
class ClassScheduleTableViewController: UITableViewController {
    @IBOutlet var tableSource: UITableView!
    var ScheduleSource = ScheduleList()
    override func viewDidLoad() {
        super.viewDidLoad()
        GetDate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func GetDate(){
        //下面两句代码是从缓存中取出userid（入参）值
        let defalutid = NSUserDefaults.standardUserDefaults()
        let sid = defalutid.stringForKey("classid")
        let schid = defalutid.stringForKey("schoolid")

        let url = apiUrl + "ClassSyllabus"
        let param = [
            "classid":sid!,
            "schoolid":schid!
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
                    self.ScheduleSource = ScheduleList(status.data!)
                    self.tableSource.reloadData()
                }
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(section == 0){
            return ScheduleSource.count
            //let teacherList = self.ScheduleSource.objectlist[0]
           // print(teacherList.syllabus_name)
           // return   teacherList.syllabus_name
        }
        if(section == 1){
           return ScheduleSource.count
        }
        if(section == 2){
           return ScheduleSource.count
        }
        if(section == 3){
            return ScheduleSource.count
        }
        if(section == 4){
            return ScheduleSource.count
        }
            return 0
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String{
        
        if(section == 0)
        {
            return "周一"
        }
       if(section == 1)
        {
            return  "周二"
        }
        if(section == 2)
        {
            return  "周三"
        }
        if(section == 3)
        {
            return  "周四"
        }
        if(section == 4)
        {
            return  "周五"
        }
        return "WQE"
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ScheduleCell", forIndexPath: indexPath) as! ClassScheduleTableViewCell
           // cell.ScheduleLabel.text = "标题1"
        
        let schInfo = self.ScheduleSource.objectlist[indexPath.row]
        let dateformate = NSDateFormatter()
        dateformate.dateFormat = "MM-dd"
        cell.ScheduleLabel.text = schInfo.syllabus_name!
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        return 30.0
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5.0
    }

}
