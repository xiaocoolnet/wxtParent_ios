//
//  BabyTeachersTableViewController.swift
//  WXT_Parents
//
//  Created by 牛尧 on 16/2/24.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
class BabyTeachersTableViewController: UITableViewController {

    @IBOutlet var tableSource: UITableView!
    var BabySource = BabyTeacherList()
    override func viewDidLoad() {
        super.viewDidLoad()
        GetDate()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    func GetDate(){
        let defalutid = NSUserDefaults.standardUserDefaults()
        let sid = defalutid.stringForKey("schoolid")
        let clid = defalutid.stringForKey("classid")
        let url = apiUrl + "OnlineLeaveTeacher"
        let param = [
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
                    self.BabySource = BabyTeacherList(status.data!)
                    self.tableSource.reloadData()
                }
            }
        }

    
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return BabySource.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BabyTeachersCell", forIndexPath: indexPath) as!BabyTeachersTableViewCell
        //cell.BabyTeacherLabel.text = "李老师"
        let babyInfo = self.BabySource.objectlist[indexPath.row]
        let dateformate = NSDateFormatter()
        dateformate.dateFormat = "MM-dd"
        cell.BabyTeacherLabel.text = babyInfo.teachername!
        cell.TeacherPhone.text = babyInfo.teacherphone!
    
        // Configure the cell...

        return cell
    }

}
