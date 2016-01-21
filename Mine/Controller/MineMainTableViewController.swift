//
//  MineMainTableViewController.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/1/20.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire

class MineMainTableViewController: UITableViewController {

    @IBOutlet weak var userAvatar: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var serviceLabel: UILabel!
    
    @IBOutlet weak var serviceTimeLabel: UILabel!
    
    @IBOutlet weak var Logout: UIButton!
    
    var imageCache = Dictionary<String,UIImage>()
    var dataSource = ChildrenList()
    let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3.0 * Double(NSEC_PER_SEC)))
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.mode = MBProgressHUDMode.Text;
        hud.labelText = "正在加载"
        hud.margin = 10.0
        hud.removeFromSuperViewOnHide = true
        hud.hide(true, afterDelay: 2)
        GetUserInfo()
        userAvatar.layer.cornerRadius = 40
        userAvatar.layer.masksToBounds = true
        Logout.addTarget(self, action: Selector("Exitlogin"), forControlEvents: UIControlEvents.TouchUpInside)
        dispatch_after(self.popTime, dispatch_get_main_queue()) { () -> Void in
            self.GetDefalutChildrenInfo()
            
            }
        
        self.GetChildrenUser()
        
        

    }

    func GetUserInfo(){
        
        let userid = NSUserDefaults.standardUserDefaults()
        let uid = userid.stringForKey("userid")
        let url = apiUrl+"GetUsers"
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
                let status = MineModel(JSONDecoder(json!))
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
                    print("Success")
                    self.userName.text = status.data?.name
                    if(status.data?.avatar != nil){
                        let imgUrl = imageUrl+(status.data?.avatar)!
                        
                        let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        //异步获取
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                let imgTmp = UIImage(data: data!)
                                self.imageCache[imgUrl] = imgTmp
                                self.userAvatar.image = imgTmp
                                self.userAvatar.alpha = 1.0
                                
                            }
                        })

                    }
                }
                
            }
            
        }
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
                    var defalut:String?
                    self.dataSource = ChildrenList(status.data!)
                    print(self.dataSource.count)
                    for i in 0..<self.dataSource.count{
                        var chirdinfo = self.dataSource.objectlist[i]
                        defalut = chirdinfo.preferred!
                        if(defalut == "1"){
                            
                            let chid = NSUserDefaults.standardUserDefaults()
                            chid.setValue(chirdinfo.childrenid!, forKey: "chid")
                            let defalutid = userid.valueForKey("chid")
                        }
                    }
                }
            }
            
        }
        

    }
    
    func GetDefalutChildrenInfo(){
        let defalutid = NSUserDefaults.standardUserDefaults()
        let cid = defalutid.stringForKey("chid")
        let url = apiUrl+"GetSeverStatus"
        let param = [
            "stuid":cid!
        ]
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            if(error != nil){
            }
            else{
                print("request是")
                print(request!)
                print("====================")
                let status = ServiceModel(JSONDecoder(json!))
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
                    if(status.data?.status == "1"){
                        self.serviceLabel.text = "服务中"
                        print(status.data!.endtime!)
                        self.serviceTimeLabel!.text = "截至日期\(status.data!.endtime!)"
                    }
                    else{
                        self.serviceLabel.text = "未服务"
                        self.serviceTimeLabel.text = "截至日期无"
                    }
                }
            }
            
        }
        
        
    }
    func Exitlogin(){
        let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("确认注销？", comment: "empty message"), preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        let doneAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            var userid = NSUserDefaults.standardUserDefaults()
            userid.setValue("", forKey: "userid")
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("LoginView") as! UINavigationController
            self.presentViewController(vc, animated: true, completion: nil)
        }
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        return 0.01
        
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5.0
    }

    // MARK: - Table view data source

        /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
