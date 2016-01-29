//
//  MyTableViewController.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/1/29.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import ImageSlideshow
import Alamofire
import XWSwiftRefresh

class MyTableViewController: UITableViewController {

    var diarySource = DiaryList()
    var imageCache = Dictionary<String,UIImage>()
    
    @IBOutlet weak var ImageSlide: ImageSlideshow!
    @IBOutlet var tableSource: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        DropDownUpdate()
        ScrollViewImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func DropDownUpdate(){
        self.tableView.headerView = XWRefreshNormalHeader(target: self, action: "GetDate")
        self.tableView.headerView?.beginRefreshing()
        
    }
    
    func GetDate(){
        let defalutid = NSUserDefaults.standardUserDefaults()
        let cid = defalutid.stringForKey("chid")
        let url = apiUrl+"BabyGrow"
        let param = [
            "babyid":cid!,
            "beginid":"0"
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
                    hud.mode = MBProgressHUDMode.Text;
                    hud.labelText = status.errorData
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                
                if(status.status == "success"){
                    
                    self.tableView.headerView?.endRefreshing()
                    self.diarySource = DiaryList(status.data!)
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
        return diarySource.count
    }
    
    func ScrollViewImage(){
        ImageSlide.slideshowInterval = 5.0
        ImageSlide.setImageInputs([AFURLSource(urlString: "http://www.xiaocool.cn:8016/uploads/Viwepager/1.png")!, AFURLSource(urlString: "http://www.xiaocool.cn:8016/uploads/Viwepager/2.png")!, AFURLSource(urlString: "http://www.xiaocool.cn:8016/uploads/Viwepager/3.png")!])
    }


    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DiaryCell", forIndexPath: indexPath) as! DiaryTableViewCell

        var diaryInfo = self.diarySource.objectlist[indexPath.row]
        let dateformate = NSDateFormatter()
        dateformate.dateFormat = "MM-dd"
        var datedouble: Double?
        var dateint: Int?
        var create_time:NSDate?
        dateint = Int(diaryInfo.write_time!)
        datedouble = Double(dateint!)
        create_time = NSDate(timeIntervalSince1970: datedouble!)
        
        cell.timeLabel.text = dateformate.stringFromDate(create_time!)
        cell.TitleLabel.text = diaryInfo.title!
        let imgUrl = growCoverImageUrl+(diaryInfo.cover_photo!)
        
        let image = self.imageCache[imgUrl] as UIImage?
        let avatarUrl = NSURL(string: imgUrl)
        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
        //异步获取
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
            if(data != nil){
                let imgTmp = UIImage(data: data!)
                self.imageCache[imgUrl] = imgTmp
                cell.diaryImage.image = imgTmp
                cell.diaryImage.alpha = 1.0
                
            }
        })
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
