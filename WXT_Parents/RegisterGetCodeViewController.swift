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

        getCodeButton.addTarget(self, action: #selector(RegisterGetCodeViewController.GetCode), forControlEvents: UIControlEvents.TouchUpInside)
        nextButton.addTarget(self, action: #selector(RegisterGetCodeViewController.Next), forControlEvents: UIControlEvents.TouchUpInside)
        timeLabel.hidden = true
        self.navigationController?.navigationBar.hidden = false
        
    }
//    发送验证码
    func GetCode(){
        let phoneNum:String =  (phoneNumberText.text)!
        if (phoneNumberText.text!.isEmpty||phoneNumberText.text?.characters.count != 11)
        {
            let alerView:UIAlertView = UIAlertView()
            alerView.title = "手机号输入错误"
            alerView.message = "请重新输入"
            alerView.addButtonWithTitle("确定")
            alerView.cancelButtonIndex = 0
            alerView.delegate = self
            alerView.tag = 1
            alerView.show()
        }else if (!isTelNumber(phoneNum)){//判断输入是否是电话号码
            let alert = UIAlertController(title: "手机号输入错误", message: "请重新输入", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }else
        {
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
//    下一步
    func Next(){
        if PandKong()==true{
            RegisterYanZheng()
        }

    }
//    注册验证
    func RegisterYanZheng(){
        let url = apiUrl+"UserVerify"
        let param = [
            "phone":self.phoneNumberText.text!,
            "code":self.codeText.text!
        ]
        print(url)
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            if(error != nil){
            }
            else{
                print("request是")
                print(request!)
                print("====================")
                let status = Httpresult(JSONDecoder(json!))
                print(JSONDecoder(json!))
                print("状态是")
                print(status.status)
                if(status.status == "error"){
                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.mode = MBProgressHUDMode.Text;
                    hud.labelText = status.errorData
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 3)
                }
                
                if(status.status == "success"){
                    let userid = NSUserDefaults.standardUserDefaults()
                    userid.setValue(status.data?.id, forKey: "userid")
                    let uid = userid.valueForKey("userid")
                    print(uid)
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                    let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("SetPasswordView") 
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }
            
        }

    }
//    判空
    func PandKong()->Bool{
        let phoneNum:String =  (phoneNumberText.text)!
        if(phoneNumberText.text!.isEmpty){
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.mode = MBProgressHUDMode.Text
            hud.labelText = "请输入手机号"
            hud.margin = 10.0
            hud.removeFromSuperViewOnHide = true
            hud.hide(true, afterDelay: 1)
            return false
        }else if (!isTelNumber(phoneNum)){//判断输入是否是电话号码
            let alert = UIAlertController(title: "手机号输入错误", message: "请重新输入", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        if(codeText.text!.isEmpty){
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.mode = MBProgressHUDMode.Text
            hud.labelText = "请输入验证码"
            hud.margin = 10.0
            hud.removeFromSuperViewOnHide = true
            hud.hide(true, afterDelay: 1)
            return false
        }
        return true
    }
//    考试倒计时
    func timeDow()
    {
        let time1 = NSTimer.scheduledTimerWithTimeInterval(1.0, target:self, selector: #selector(RegisterGetCodeViewController.updateTime), userInfo: nil, repeats: true)
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
            }
            else{
                }
                
            }
    }
//    收键盘
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    //    判断是否为电话号码
    func isTelNumber(num:NSString)->Bool
    {
        let mobile = "^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"
        let  CM = "^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
        let  CU = "^1(3[0-2]|5[256]|8[56])\\d{8}$"
        let  CT = "^1((33|53|8[09])[0-9]|349)\\d{7}$"
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        let regextestcm = NSPredicate(format: "SELF MATCHES %@",CM )
        let regextestcu = NSPredicate(format: "SELF MATCHES %@" ,CU)
        let regextestct = NSPredicate(format: "SELF MATCHES %@" ,CT)
        if ((regextestmobile.evaluateWithObject(num) == true)
            || (regextestcm.evaluateWithObject(num)  == true)
            || (regextestct.evaluateWithObject(num) == true)
            || (regextestcu.evaluateWithObject(num) == true))
        {
            return true
        }
        else
        {
            return false
        }
    }
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if (segue.identifier == "PhoneNumber"){
//        
//        }
//
//    }
    


}
