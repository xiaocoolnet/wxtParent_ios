//
//  KnowledgeTableViewController.swift
//  WXT_Parents
//
//  Created by 牛尧 on 16/3/19.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class KnowledgeTableViewController: UITableViewController {
    @IBOutlet var tableSource: UITableView!
    var knowSource = KnowList()
    var imageCache = Dictionary<String,UIImage>()
    override func viewDidLoad() {
        super.viewDidLoad()
        GetDate()
    }
    
    func GetDate(){
        let defalutid = NSUserDefaults.standardUserDefaults()
        let sid = defalutid.stringForKey("schoolid")
        let url = apiUrl+"ParentingKnowledge"
        let param = [
            "schoolid":sid!
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
                    self.knowSource = KnowList(status.data!)
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
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return knowSource.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("KnowCell", forIndexPath: indexPath)as! KnowledgeTableViewCell
        let knowyInfo = self.knowSource.objectlist[indexPath.row]
        let dateformate = NSDateFormatter()
        dateformate.dateFormat = "MM-dd"
        cell.KnowTitle.text = knowyInfo.happy_title!
        cell.KnowTime.text = knowyInfo.happy_time!
        cell.KnowContent.text = knowyInfo.happy_content!
        cell.KnowName.text = knowyInfo.releasename!
        let imgUrl = happyImageUrl+(knowyInfo.happy_pic!)
        
        let image = self.imageCache[imgUrl] as UIImage?
        let avatarUrl = NSURL(string: imgUrl)
        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
        //异步获取
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
            if(data != nil){
                let imgTmp = UIImage(data: data!)
                self.imageCache[imgUrl] = imgTmp
                cell.KnowImages.image = imgTmp
                cell.KnowImages.alpha = 1.0
                
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
