//
//  MineMainTableViewController.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/1/20.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
//  一个tableView
class MineMainTableViewController: UITableViewController {

    @IBOutlet weak var userAvatar: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var serviceLabel: UILabel!
    
    @IBOutlet weak var serviceTimeLabel: UILabel!
    
    
    @IBAction func PersonalSettings(sender: AnyObject) {
        let personSettingVC = QCPersonSettingVC()
        self.navigationController?.pushViewController(personSettingVC, animated: true)
    }
    var imageCache = Dictionary<String,UIImage>()
    var imgUrl:String?
    var phone:String?
    let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3.0 * Double(NSEC_PER_SEC)))
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "个人中心"
        //  设置右按钮
        //  进入的加载
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        //hud.mode = MBProgressHUDMode.Text
        hud.labelText = "正在加载"
        //hud.margin = 10.0
        hud.removeFromSuperViewOnHide = true
        hud.hide(true, afterDelay: 1)
        //  得到数据
        GetUserInfo()
        userAvatar.layer.cornerRadius = 40
        userAvatar.layer.masksToBounds = true

    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
    }

    @IBAction func AccountDetails(sender: AnyObject) {
        //  账户明细
        let accountDetailsVC = AccountDetailsVC()
        self.navigationController?.pushViewController(accountDetailsVC, animated: true)
        
    }
    
    
    @IBAction func PayMoney(sender: AnyObject) {
        //  支付费用
        let payMoneyVC = QCPayMoneyVC()
        self.navigationController?.pushViewController(payMoneyVC, animated: true)

    }
    
    
    
    func GetUserInfo(){
        //  得到沙盒
        let userid = NSUserDefaults.standardUserDefaults()
        //  把userid存入沙盒
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
                //  进行数据解析
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
                    //  手机号
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
//    //  退出登录
//    func Exitlogin(){
//        let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("确认注销？", comment: "empty message"), preferredStyle: .Alert)
//        
//        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
//        let doneAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
////          清除登录信息
//            NSUserDefaults.standardUserDefaults().removeObjectForKey("userid")
//            NSUserDefaults.standardUserDefaults().removeObjectForKey("name")
//            NSUserDefaults.standardUserDefaults().removeObjectForKey("password")
//            NSUserDefaults.standardUserDefaults().removeObjectForKey("schoolid")
//            NSUserDefaults.standardUserDefaults().removeObjectForKey("classid")
//            NSUserDefaults.standardUserDefaults().removeObjectForKey("chid")
//            NSUserDefaults.standardUserDefaults().removeObjectForKey("chidname")
//            NSUserDefaults.standardUserDefaults().synchronize()
////            退出环信
//            EaseMob.sharedInstance().chatManager.asyncLogoffWithUnbindDeviceToken(false)
//            
//            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
//            let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("FirstView")
//            self.navigationController?.pushViewController(vc, animated: true)
//            
//        }
//        alertController.addAction(doneAction)
//        alertController.addAction(cancelAction)
//        self.presentViewController(alertController, animated: true, completion: nil)
//        
//    }
//    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        return 0.01
        
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5.0
    }

}
