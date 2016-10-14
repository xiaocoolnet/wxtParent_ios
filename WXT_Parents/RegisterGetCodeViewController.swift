//
//  RegisterGetCodeViewController.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/1/15.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class RegisterGetCodeViewController: UIViewController {
    
    

    @IBOutlet weak var phoneNumberText: UITextField!
    
    @IBOutlet weak var codeText: UITextField!
    
    @IBOutlet weak var getCodeButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var timeNamal:NSTimer!
    var timeNow:NSTimer!
    var count:Int = 60
    var alerView0:UIAlertView!
    var alerView1:UIAlertView!
    var alerView2:UIAlertView!
    var alerView3:UIAlertView!
    var alerView4:UIAlertView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //      取消隐藏导航栏
        self.navigationController?.navigationBar.hidden = false
        getCodeButton.addTarget(self, action: #selector(ForgetPasswordViewController.GetCode), forControlEvents: UIControlEvents.TouchUpInside)
        nextButton.addTarget(self, action: #selector(ForgetPasswordViewController.Next), forControlEvents: UIControlEvents.TouchUpInside)
        timeLabel.hidden = true
    }
    //    发送验证码
    func GetCode(){
        let phoneNum:String =  (phoneNumberText.text)!
        if (phoneNum.isEmpty)
        {
            let alerView:UIAlertView = UIAlertView()
            alerView.title = "手机号输入错误"
            alerView.message = "请重新输入"
            alerView.addButtonWithTitle("确定")
            alerView.cancelButtonIndex = 0
            alerView.delegate = self
            alerView.tag = 1
            alerView.show()
        }else{
            let alerView:UIAlertView = UIAlertView()
            alerView.title = "发送验证码到"
            alerView.message = "\(phoneNumberText.text!)"
            alerView.addButtonWithTitle("取消")
            alerView.addButtonWithTitle("确定")
            alerView.cancelButtonIndex = 0
            alerView.delegate = self
            alerView.tag = 0
            alerView.show()
        }
        
    }
    
    func Next(){
        if PandKong()==true{
            Yanzheng()
        }
        
    }
    //    验证
    func Yanzheng(){
        let url = apiUrl+"forgetPass_Verify"
        let params = [
            "phone":phoneNumberText.text!,
            "code":codeText.text!
        ]
        Alamofire.request(.GET, url, parameters: params).response { request, response, json, error in
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
                let status = Httpresult(JSONDecoder(json!))
                print("状态是")
                print(status.status)
                if(status.status == "error"){
                    messageHUD(self.view, messageData: status.errorData!)
                }
                
                if(status.status == "success"){
                    print("Success")
                    successHUD(self.view, successData: "登录成功")
                    let userDefaults = NSUserDefaults.standardUserDefaults()
                    userDefaults.setValue(status.data?.id, forKey: "userid")
                    
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                    let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ForgetPasswordView")
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    
                }
                
            }
            
        }
        
    }
    //    判空
    func PandKong()->Bool{
        
        if(phoneNumberText.text!.isEmpty){
            messageHUD(self.view, messageData: "请输入手机号")
            return false
        }
        
        if(codeText.text!.isEmpty){
            messageHUD(self.view, messageData: "请输入验证码")
            return false
        }
        return true
    }
    //   开始倒计时
    func timeDow()
    {
        let time1 = NSTimer.scheduledTimerWithTimeInterval(1.0, target:self, selector: #selector(ForgetPasswordViewController.updateTime), userInfo: nil, repeats: true)
        timeNow = time1
    }
    //    倒计时
    func showRepeatButton()
    {
        timeLabel.hidden=true
        getCodeButton.hidden = false
        getCodeButton.enabled = true
    }
    //    更新时间
    func updateTime()
    {
        count -= 1
        if (count <= 0)
        {
            count = 60
            self.showRepeatButton()
            timeNow.invalidate()
        }
        timeLabel.text = "\(count)S"
        
    }
    //    提示框点击事件
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if alertView.tag == 0
        {
            if buttonIndex == 1
            {
                self.senderMessage()
                getCodeButton.hidden = true
                timeLabel.hidden = false
                self.timeDow()
            }
        }
        if alertView.tag == 1
        {}
        if alertView.tag == 2
        {}
    }
    //    发送验证码
    func senderMessage()
    {
        let url = apiUrl+"SendMobileCode"
        let param = [
            "phone":self.phoneNumberText.text!,
            ]
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            if(error != nil){
            }else{
                print(request)
            }
        }
    }
    //    收键盘
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}
