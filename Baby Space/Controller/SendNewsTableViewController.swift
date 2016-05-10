//
//  SendNewsTableViewController.swift
//  WXT_Parents
//
//  Created by 牛尧 on 16/3/14.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//
import UIKit
import Alamofire
import MBProgressHUD

class SendNewsTableViewController: UITableViewController {
    @IBOutlet var tableSource: UITableView!
    var sendSource = SendList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GetDate()
    }
    
    func GetDate(){
        //下面两句代码是从缓存中取出userid（入参）值
        let defalutid = NSUserDefaults.standardUserDefaults()
        let uid = defalutid.stringForKey("userid")
        let url = apiUrl + "SentMessage"
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
                    self.sendSource = SendList(status.data!)
                    self.tableSource.reloadData()
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sendSource.count
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 10
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5.0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SendCell", forIndexPath: indexPath)
            as! SendNewsTableViewCell
        let sendInfo = self.sendSource.objectlist[indexPath.row]
        let dateformate = NSDateFormatter()
        dateformate.dateFormat = "MM-dd"
        cell.SendName.text = sendInfo.send_user_name!
        cell.SendContent.text = sendInfo.message_content!
        cell.SendTime.text = sendInfo.message_time!
        return cell
    }
    
}


