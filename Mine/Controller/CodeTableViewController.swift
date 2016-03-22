
//  WXT_Parents
//
//  Created by 牛尧 on 16/3/20.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire

class CodeTableViewController: UITableViewController {
    @IBOutlet var tableSource: UITableView!
    //var codeSource = CodeList()
    var imgUrl:String?
    var imageCache = Dictionary<String,UIImage>()
    override func viewDidLoad() {
        super.viewDidLoad()
        GetDate()
    }
    
    func GetDate(){
        let defalutid = NSUserDefaults.standardUserDefaults()
        let sid = defalutid.stringForKey("chid")
        let url = apiUrl + "StuCode"
        let param = [
            "stuid":sid!
        ]
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            if(error != nil){
            }
            else{
                print("request是")
                print(request!)
                print("====================")
                let status = CodeResult(JSONDecoder(json!))
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
                    self.imgUrl = codeImageUrl + (status.data?.codename)!
                    self.tableSource.reloadData()
                }
            }
        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return codeSource.count
        return 1
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ErweimaCell", forIndexPath:
            indexPath)as! ErweimaTableViewCell
        if imgUrl != nil{
            let dateformate = NSDateFormatter()
            dateformate.dateFormat = "MM-dd"
            let avatarUrl = NSURL(string: imgUrl!)
            let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
            //异步获取
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                if(data != nil){
                    let imgTmp = UIImage(data: data!)
                    self.imageCache[self.imgUrl!] = imgTmp
                    cell.images.image = imgTmp
                    cell.images.alpha = 1.0
                }
            })
        }
        return cell
    }

}
