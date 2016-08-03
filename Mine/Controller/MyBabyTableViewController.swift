//
//  MyBabyTableViewController.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/1/31.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
//  我的宝宝
class MyBabyTableViewController: UITableViewController {

    @IBOutlet var dataTableView: UITableView!
    
    var dataSource = ChildrenList()
    override func viewDidLoad() {
        super.viewDidLoad()
        GetChildrenUser()
        self.tabBarController?.tabBar.hidden = true
    }
    
    func GetChildrenUser(){
        let userid = NSUserDefaults.standardUserDefaults()
        let uid = userid.stringForKey("userid")
        let url = apiUrl+"GetUserRelation"
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
                }
                
                if(status.status == "success"){
                    self.dataSource = ChildrenList(status.data!)
                    self.dataTableView.reloadData()
                
                }
            }
            
        }
    }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return dataSource.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BabyCell", forIndexPath: indexPath) as! BabyTableViewCell
        cell.selectionStyle = .None
        let childInfo = self.dataSource.objectlist[indexPath.section]
        cell.babyName.text = childInfo.studentname
        let imgUrl = imageUrl + childInfo.studentavatar!
        let photourl = NSURL(string: imgUrl)
        cell.babyAvator.yy_setImageWithURL(photourl, placeholder: UIImage(named: "Logo.png"))
        cell.babyBtn.addTarget(self, action: #selector(MyBabyTableViewController.chooseBaby(_:)), forControlEvents: .TouchUpInside)
        cell.babyBtn.tag = indexPath.section
        return cell
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        return 0.01
        
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    func chooseBaby(sender:UIButton){
        let btn:UIButton = sender
        let childInfo = self.dataSource.objectlist[btn.tag]
//        先清除后保存
        NSUserDefaults.standardUserDefaults().removeObjectForKey("chid")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("chidname")
        let studentid = NSUserDefaults.standardUserDefaults()
        studentid.setValue(childInfo.studentid , forKey: "chid")
        let studentname = NSUserDefaults.standardUserDefaults()
        studentname.setValue(childInfo.studentname , forKey: "chidname")
        NSUserDefaults.standardUserDefaults().synchronize()
        
//        提示
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.mode = MBProgressHUDMode.Text;
        hud.labelText = "切换成功"
        hud.margin = 10.0
        hud.removeFromSuperViewOnHide = true
        hud.hide(true, afterDelay: 1)
    }
}
