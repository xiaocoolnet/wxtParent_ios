//
//  HappyTableViewController.swift
//  WXT_Parents
//
//  Created by Mac on 16/3/19.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class HappyTableViewController: UITableViewController {

    @IBOutlet var tableSource: UITableView!
    var happySource = HappyList()
    var imageCache = Dictionary<String,UIImage>()

    override func viewDidLoad() {
        super.viewDidLoad()
        //  数据请求
        GetDate()
        }
    
    func GetDate(){
        let defalutid = NSUserDefaults.standardUserDefaults()
        let sid = defalutid.stringForKey("schoolid")
        let url = apiUrl+"HappySchool"
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
                    messageHUD(self.view, messageData: status.errorData!)
                }
                
                if(status.status == "success"){
                    self.happySource = HappyList(status.data!)
                    self.tableSource.reloadData()
                }
            }
        }
        
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return happySource.count

    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HappyCell", forIndexPath: indexPath)as! HappyTableViewCell
        let happyInfo = self.happySource.objectlist[indexPath.row]
        let dateformate = NSDateFormatter()
        dateformate.dateFormat = "MM-dd"
        cell.Title.text = happyInfo.happy_title!
        cell.Time.text = happyInfo.happy_time!
        cell.Content.text = happyInfo.happy_content!
        cell.Name.text = happyInfo.releasename!
        let imgUrl = happyImageUrl+(happyInfo.happy_pic!)
        
        let image = self.imageCache[imgUrl] as UIImage?
        let avatarUrl = NSURL(string: imgUrl)
        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
        //异步获取
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
            if(data != nil){
                let imgTmp = UIImage(data: data!)
                self.imageCache[imgUrl] = imgTmp
                cell.images.image = imgTmp
                cell.images.alpha = 1.0
                
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
