    //
//  LoginViewController.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/1/6.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//
import UIKit
import Alamofire
import MBProgressHUD

class LoginViewController: UIViewController ,UITextFieldDelegate{

    @IBOutlet weak var AccountText: UITextField!
    @IBOutlet weak var PasswordText: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    var dataSource = ChildrenList()
    var ClassData = ClassList()
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        XKeyBoard.registerKeyBoardHide(self)
        XKeyBoard.registerKeyBoardShow(self)
        //self.navigationController?.navigationBar.hidden = true
        AccountText.delegate = self
        PasswordText.delegate = self
        LoginButton.addTarget(self, action: #selector(LoginViewController.Login), forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = true
        self.tabBarController?.tabBar.hidden = true
    }
//        键盘消失的通知方法
    func keyboardWillHideNotification(notification:NSNotification){
        UIView.animateWithDuration(0.3) { () -> Void in
            self.topConstraint.constant = 233
            self.view.layoutIfNeeded()
        }
        
    }
//     键盘出现的通知方法
    func keyboardWillShowNotification(notification:NSNotification){
        UIView.animateWithDuration(0.3) { () -> Void in
            self.topConstraint.constant = 150
            self.view.layoutIfNeeded()
        }
    }
//点击登录
    func Login(){
        if(AccountText.text!.isEmpty){
            messageHUD(self.view, messageData: "请输入账号")
            return
        }
        if(PasswordText.text!.isEmpty){
            messageHUD(self.view, messageData: "请输入密码")
            return
        }
        //  http://wxt.xiaocool.net/index.php?g=apps&m=index&a=applogin&phone=18672910380&password=123
        let url = apiUrl+"applogin"
//       let userDefaults = NSUserDefaults.standardUserDefaults()
//       let deviceToken = userDefaults.stringForKey("deviceToken")
        
        let param = [
            "phone":self.AccountText.text!,
            "password":self.PasswordText.text!,
//          "jgtoken":deviceToken
        ]
        Alamofire.request(.GET, url, parameters: param as![String:String]).response { request, response, json, error in
                if(error != nil){
                }
                else{
                    print("request是")
                    print(request!)
                    print("response是")
                    print(response!)
                    print("data是")
                    print(json!)
                    print("====================")
                    let result = Httpresult(JSONDecoder(json!))
                    print("状态是")
                    print(result.status)
                    if(result.status == "error"){
                        messageHUD(self.view, messageData:result.errorData!)
                    }
                    
                    if(result.status == "success"){
                        print("Success")
                        successHUD(self.view, successData: "登录成功")

                        //  沙盒存取用户端信息
                        let userDefaults = NSUserDefaults.standardUserDefaults()
                        userDefaults.setValue(result.data?.id, forKey: "userid")
                        userDefaults.setValue(result.data?.name, forKey: "name")
                        userDefaults.setValue(self.PasswordText.text!, forKey: "password")

                        userDefaults.setValue(result.data?.photo, forKey: "photo")
                        userDefaults.setValue(result.data?.phone, forKey: "phone")
                        
//                        获取孩子信息
                        self.GetChildrenUser((result.data?.id)!)
                        
                }
            }
        }
    }
//    获取孩子信息
//      http://wxt.xiaocool.net/index.php?g=apps&m=index&a=GetUserRelation&userid=597
    //  http://wxt.xiaocool.net/index.php?g=apps&m=index&a=GetUserRelation&userid=681
    func GetChildrenUser(id:String){
        let url = apiUrl+"GetUserRelation"
        let param = [
            "userid":id
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

                    NSUserDefaults.standardUserDefaults().removeObjectForKey("userid")
                    NSUserDefaults.standardUserDefaults().removeObjectForKey("name")
                    NSUserDefaults.standardUserDefaults().removeObjectForKey("password")
   
                    NSUserDefaults.standardUserDefaults().removeObjectForKey("photo")
                    NSUserDefaults.standardUserDefaults().removeObjectForKey("phone")
                }
                if(status.status == "success"){
                    var defalut:String?
                    self.dataSource = ChildrenList(status.data!)
//                    for i in 0..<self.dataSource.count{
                        let chirdinfo = self.dataSource.objectlist[0]
                        defalut = chirdinfo.preferred!
                    var child = chirdinfo.classlist
                        print(chirdinfo.preferred!)
                        if(defalut == "0"){
                            let userDefaults = NSUserDefaults.standardUserDefaults()
                            print(chirdinfo.studentid!)
                            userDefaults.setValue(chirdinfo.studentid!, forKey: "chid")
                            userDefaults.setValue(chirdinfo.school_name, forKey: "school_name")
                            userDefaults.setValue(chirdinfo.studentname, forKey: "chidname")
//                            self.GetChildrenClass(chirdinfo.studentid!)
                            userDefaults.setValue(child[0].classid!, forKey: "classid")
                            userDefaults.setValue(child[0].schoolid!, forKey: "schoolid")
//                            userDefaults.setValue(child[0].classname!, forKey: "schoolid")
                            print(chirdinfo.studentid)
//                        }
                    }
//                    环信登录
                    let easeMob:EaseMob = EaseMob()
                    easeMob.registerSDKWithAppKey("xiaocool#zhixiaoyuan", apnsCertName: "wxtpush_dev")
                    //        接口调用注册
                    easeMob.chatManager?.asyncRegisterNewAccount(id, password:id)
                    //        设置自动登录
                    easeMob.chatManager?.asyncLoginWithUsername(id, password:id)
                    //        检测是否设置了自动登录
                    let isAutoLogin:Bool = easeMob.chatManager?.isAutoLoginEnabled ?? false
                    if(!isAutoLogin){
                        easeMob.chatManager?.asyncLoginWithUsername(id,password:id)
                    }
                    print("++++++++++++++++++++++++++++++++")
                    let defalutid = NSUserDefaults.standardUserDefaults()
                    let studentid = defalutid.stringForKey("chid")
                    JPUSHService.setTags(nil, aliasInbackground: studentid)
                    let defau = NSNotificationCenter.defaultCenter()
                    
                    defau.addObserver(self, selector: #selector(self.networkDidLogin), name: kJPFNetworkDidLoginNotification, object: nil)
//                    跳转界面
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                    let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("MainView")
                    self.presentViewController(vc, animated: true, completion: nil)
                    
                }
            }
        }
    }
    
    func networkDidLogin(){
        print("++++++++++++++++++++++++++++++++")
        let defalutid = NSUserDefaults.standardUserDefaults()
        let studentid = defalutid.stringForKey("userid")
        JPUSHService.setTags(nil, aliasInbackground: studentid)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kJPFNetworkDidLoginNotification, object: nil)
        print(studentid)
        print(callBack)
    }

    //  http://wxt.xiaocool.net/index.php?g=apps&m=index&a=GetUserRelation&userid=597
    //  http://wxt.xiaocool.net/index.php?g=apps&m=student&a=getclasslist&studentid=682
    func GetChildrenClass(id:String){
        //  进行数据请求
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=getclasslist"
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let studentid = userDefaults.valueForKey("chid")
        print(studentid)
        let pmara = ["studentid":studentid]
        Alamofire.request(.GET, url, parameters: pmara as? [String:AnyObject]).response { request, response, json, error in
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
//                    var defalut:String?
//                    self.dataSource = ChildrenList(status.data!)
//                    for i in 0..<self.dataSource.count{
//                        let chirdinfo = self.dataSource.objectlist[i]
//                        defalut = chirdinfo.preferred!
//                        print(chirdinfo.preferred!)
//                        if(defalut == "0"){
//                            let userDefaults = NSUserDefaults.standardUserDefaults()
//                            print(chirdinfo.studentid!)
//                            userDefaults.setValue(chirdinfo.studentid!, forKey: "chid")
//                            
//                            userDefaults.setValue(chirdinfo.studentname, forKey: "chidname")
                    
//                        }
                    
//                    }
                    self.ClassData = ClassList(status.data!)
//                    for i in 0..<self.ClassData.count{
                    if self.ClassData.count != 0{
                        
                        let classInfo = self.ClassData.objectlist[0]
                        userDefaults.setValue(classInfo.classid!, forKey: "classid")
                        userDefaults.setValue(classInfo.schoolid!, forKey: "schoolid")
                    }
                    
//                    }
                    
                }
            }
        }
    }
                
            
            

        //  进行数据请求
        
    
    
    //点击return收回键盘
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        //  键盘收起的方法
        AccountText.resignFirstResponder()
        PasswordText.resignFirstResponder()
        return true
    }
    
    //点击空白处回收键盘
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}
