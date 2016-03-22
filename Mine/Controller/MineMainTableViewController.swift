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
    var imgUrl:String?
    var phone:String?
    let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3.0 * Double(NSEC_PER_SEC)))
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        //hud.mode = MBProgressHUDMode.Text
        hud.labelText = "正在加载"
        //hud.margin = 10.0
        hud.removeFromSuperViewOnHide = true
        hud.hide(true, afterDelay: 1)
        GetUserInfo()
        userAvatar.layer.cornerRadius = 40
        userAvatar.layer.masksToBounds = true
        Logout.addTarget(self, action: #selector(MineMainTableViewController.Exitlogin), forControlEvents: UIControlEvents.TouchUpInside)
        self.GetDefalutChildrenInfo()

    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
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
                    self.phone = status.data?.phoneNumber!
                    self.userName.text = status.data?.name
                    if(status.data?.avatar != nil){
                        self.imgUrl = imageUrl+(status.data?.avatar)!
                        
                        //let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: self.imgUrl!)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        //异步获取
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                let imgTmp = UIImage(data: data!)
                                self.imageCache[self.imgUrl!] = imgTmp
                                self.userAvatar.image = imgTmp
                                self.userAvatar.alpha = 1.0
                                
                            }
                        })

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
            let userid = NSUserDefaults.standardUserDefaults()
            userid.setValue("", forKey: "userid")
            let defalutid = NSUserDefaults.standardUserDefaults()
            //cid = defalutid.stringForKey("chid")
            defalutid.setValue("", forKey: "cid")
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("LoginView") as! UINavigationController
            self.presentViewController(vc, animated: true, completion: nil)
        }
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "MineInfo"){
            let info = segue.destinationViewController as! MineInfoTableViewController
            info.imageUrl = self.imgUrl!
            info.phone = self.phone!
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        return 0.01
        
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5.0
    }

}
