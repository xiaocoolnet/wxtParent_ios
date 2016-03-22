//
//  ClassActivitiesTableViewController.swift
//  WXT_Parents
//
//  Created by 牛尧 on 16/2/24.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
class ClassActivitiesTableViewController: UITableViewController {

    @IBOutlet var tableSource: UITableView!
    var actSource = ActList()
    var imageCache = Dictionary<String,UIImage>()

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
        let url = apiUrl+"ClassActivity"
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
                    
                    self.tableView.headerView?.endRefreshing()
                    self.actSource = ActList(status.data!)
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
        return actSource.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ActivitiesCell", forIndexPath: indexPath) as! ClassActivitiesTableViewCell

        // Configure the cell...
        //cell.ClassActivitiesImages.image = UIImage(named: "奥数")
        //cell.ClassActivitiesLabel.text = "标题"
        let actInfo = self.actSource.objectlist[indexPath.row]
        let dateformate = NSDateFormatter()
        dateformate.dateFormat = "MM-dd"
        cell.ClassActivitiesLabel.text = actInfo.activity_title!
        cell.ClassActivitiesContent.text = actInfo.activity_content!
        cell.ClassActivitesTime.text = actInfo.activity_time!
        let imgUrl = classActivitiesImageUrl+(actInfo.activity_pic!)
        
        let image = self.imageCache[imgUrl] as UIImage?
        let avatarUrl = NSURL(string: imgUrl)
        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
        //异步获取
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
            if(data != nil){
                let imgTmp = UIImage(data: data!)
                self.imageCache[imgUrl] = imgTmp
                cell.ClassActivitiesImages.image = imgTmp
                cell.ClassActivitiesImages.alpha = 1.0
                
            }
        })

        return cell
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        return 1.0
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5.0
    }

}
