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
    
    @IBOutlet weak var ServiceBtn: UIButton!
    
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
        GetService()
        userAvatar.layer.cornerRadius = 40
        userAvatar.layer.masksToBounds = true

    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
        GetUserInfo()
    }

    @IBAction func AccountDetails(sender: AnyObject) {
        //  账户明细
//        let accountDetailsVC = AccountDetailsVC()
//        self.navigationController?.pushViewController(accountDetailsVC, animated: true)
        messageHUD(self.view, messageData: "此app暂无此功能")
        
    }
    
    
    @IBAction func PayMoney(sender: AnyObject) {
        //  支付费用
//        let payMoneyVC = QCPayMoneyVC()
//        self.navigationController?.pushViewController(payMoneyVC, animated: true)
        messageHUD(self.view, messageData: "此app暂无此功能")
    }
    
    
    @IBAction func clickSeviceBtn(sender: AnyObject) {
        var phone = String()
        phone = "telprompt:\(String(ServiceBtn.currentTitle!))"
        UIApplication.sharedApplication().openURL(NSURL.init(string: phone)!)
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
                        self.imgUrl = microblogImageUrl+(status.data?.avatar)!
                        
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        return 0.01
        
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5.0
    }
    
    func GetService(){
        let defalutid = NSUserDefaults.standardUserDefaults()
        let cid = defalutid.stringForKey("schoolid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=index&a=service_phone"
        let param = [
            "schoolid":cid!
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
//                    self.ServiceBtn.titleLabel?.text = status.data?.phone!
                    self.ServiceBtn.setTitle(status.data?.phone!, forState: .Normal)
                }
            }
            
        }

    }

}
