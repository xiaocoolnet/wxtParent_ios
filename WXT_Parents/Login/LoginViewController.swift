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
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.mode = MBProgressHUDMode.Text
            hud.labelText = "请输入账号"
            hud.margin = 10.0
            hud.removeFromSuperViewOnHide = true
            hud.hide(true, afterDelay: 1)
            return
        }
        if(PasswordText.text!.isEmpty){
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.mode = MBProgressHUDMode.Text
            hud.labelText = "请输入密码"
            hud.margin = 10.0
            hud.removeFromSuperViewOnHide = true
            hud.hide(true, afterDelay: 1)
            return
        }
        
        let url = apiUrl+"applogin"
        let param = [
            "phone":self.AccountText.text!,
            "password":self.PasswordText.text!
        ]
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
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
                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        hud.mode = MBProgressHUDMode.Text;
                        hud.labelText = result.errorData
                        hud.margin = 10.0
                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 1)
                    }
                    
                    if(result.status == "success"){
                        print("Success")
                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        //hud.mode = MBProgressHUDMode.Text;
                        hud.labelText = "登录成功"
                        //hud.margin = 10.0
                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 1)
                        
                        let userid = NSUserDefaults.standardUserDefaults()
                        userid.setValue(result.data?.id, forKey: "userid")
                        userid.synchronize()
                        let name = NSUserDefaults.standardUserDefaults()
                        name.setValue(result.data?.name, forKey: "name")
                        name.synchronize()
                        let password = NSUserDefaults.standardUserDefaults()
                        password.setValue(self.PasswordText.text!, forKey: "password")
                        password.synchronize()
                        let schoolid = NSUserDefaults.standardUserDefaults()
                        schoolid.setValue(result.data?.schoolid, forKey: "schoolid")
                        schoolid.synchronize()
                        let classid = NSUserDefaults.standardUserDefaults()
                        classid.setValue(result.data?.classid, forKey: "classid")
                        classid.synchronize()
//                        获取孩子信息
                        self.GetChildrenUser()
                        
                }
            }
        }
    }
//    获取孩子信息
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
                        let chirdinfo = self.dataSource.objectlist[i]
                        defalut = chirdinfo.preferred!
                        if(defalut == "1"){
                            let chid = NSUserDefaults.standardUserDefaults()
                            chid.setValue(chirdinfo.studentid!, forKey: "chid")
                            let chidname = NSUserDefaults.standardUserDefaults()
                            chidname.setValue(chirdinfo.studentname, forKey: "chidname")
                        }
                    }
                    let easeMob:EaseMob = EaseMob()
                    easeMob.registerSDKWithAppKey("xiaocool#zhixiaoyuan", apnsCertName: "wxtpush_dev")
                    //        账号
                    let userid = NSUserDefaults.standardUserDefaults()
                    //        接口调用注册
                    easeMob.chatManager.asyncRegisterNewAccount(userid.valueForKey("userid")! as! String, password:userid.valueForKey("userid")! as! String)
                    //        //        设置自动登录
                    easeMob.chatManager.asyncLoginWithUsername(userid.valueForKey("userid")! as! String, password: userid.valueForKey("userid")! as! String)
                    //        检测是否设置了自动登录
                    let isAutoLogin:Bool = easeMob.chatManager.isAutoLoginEnabled!
                    if(!isAutoLogin){
                        easeMob.chatManager.asyncLoginWithUsername(userid.valueForKey("userid")! as! String,password:userid.valueForKey("userid")! as! String)
                    }
                    
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                    let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("MainView")
                    self.presentViewController(vc, animated: true, completion: nil)
                    
                }
            }
        }
    }
    //点击return收回键盘
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        AccountText.resignFirstResponder()
        PasswordText.resignFirstResponder()
        return true
    }
    
    //点击空白处回收键盘
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}
