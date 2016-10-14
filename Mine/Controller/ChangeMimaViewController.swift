//
//  ChangeMimaViewController.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/8/10.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

import Alamofire
import MBProgressHUD

//  闭包传值
typealias giveDate = (String) -> Void


class ChangeMimaViewController: UIViewController {

    
    var phoneNumber:String!
    var passWord:String!
    
    let changePhoneField = UITextField()
    
    var changeNumber:giveData!
    var changeImage:giveData!
    var changePassWord:giveData!
    
    var indexPath:NSIndexPath!
    
    
    //  时间倒计时
    var timeNamal:NSTimer!
    var timeNow:NSTimer!
    var count:Int = 60
    
    var codeButton = UIButton()
    var codeLabel = UILabel()
    let codeField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let sureButton = UIButton()
        sureButton.frame = CGRectMake(0,  0,  80, 20)
        sureButton.setTitle("下一步", forState: .Normal)
        sureButton.addTarget(self, action: #selector(ChangeValue), forControlEvents: .TouchUpInside)
        let rightButton = UIBarButtonItem(customView: sureButton)
        self.navigationItem.rightBarButtonItem = rightButton
        
        let phoneLable = UILabel()
        phoneLable.frame = CGRectMake(10, 10, 80, 50)
        phoneLable.textColor = RGBA(155, g: 229, b: 180, a: 1)
        phoneLable.text = "中国＋86"
        self.view.addSubview(phoneLable)
        changePhoneField.frame = CGRectMake(100, 5, WIDTH - 100, 50)
        changePhoneField.placeholder = "请输入手机号码"
        self.view.addSubview(changePhoneField)
        
        let line = UILabel()
        line.frame = CGRectMake(10, 60, WIDTH - 10, 0.5)
        line.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(line)
    
        let phoneLabl = UILabel()
        phoneLabl.frame = CGRectMake(10, 70, 80, 50)
        phoneLabl.textColor = RGBA(155, g: 229, b: 180, a: 1)
        phoneLabl.text = "验证码"
        self.view.addSubview(phoneLable)
    
        codeField.frame = CGRectMake(100, 65, 120, 50)
        codeField.placeholder = "请输入验证码"
        self.view.addSubview(codeField)
        
        codeButton.frame = CGRectMake(WIDTH - 110, 75, 100, 30)
        codeButton.setTitleColor(RGBA(155, g: 229, b: 180, a: 1), forState: .Normal)
        //                //  获取验证码
        codeButton.setTitle("获取验证码", forState: .Normal)
        codeButton.addTarget(self, action: #selector(GetCode), forControlEvents: .TouchUpInside)
        self.view.addSubview(codeButton)
        
        
        
        //  隐藏label
        codeLabel.hidden = true
        codeLabel.frame = CGRectMake(WIDTH - 110, 75, 100, 30)
        //                codeLabel.text = "获取验证码"
        codeLabel.textColor = RGBA(155, g: 229, b: 180, a: 1)
        self.view.addSubview(codeLabel)

    }
    
    func GetCode(){
        //  获得验证码
        //        http://wxt.xiaocool.net/index.php?g=apps&m=index&a=SendMobileCode&phone=18653503680
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=index&a=SendMobileCode"
        let pmara = ["phone":changePhoneField.text]
        //  隐藏按钮
        codeButton.hidden = true
        //  显示label
        codeLabel.hidden = false
        timeDow()
        GetName(url, pmara: (pmara as? [String:String])!)
        
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
        codeLabel.hidden=true
        codeButton.hidden = false
        codeButton.enabled = true
    }
    //    更新时间
    func updateTime()
    {
        count -= 1
        if (count <= 0)
        {
            count = 60
            //  倒计时
            self.showRepeatButton()
            timeNow.invalidate()
        }
        codeLabel.text = "\(count)S"
        
    }

    
    func ChangeValue(){
//        http://wxt.xiaocool.net/index.php?g=apps&m=index&a=forgetPass_Verify&phone=18865511109&code=111111
        

//        self.changeNumber(changePhoneField.text!)
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=index&a=forgetPass_Verify"
        let code = codeField.text
        let phone = changePhoneField.text
        let param = ["code":code,"phone":phone]
        
        Alamofire.request(.GET, url, parameters: param as? [String:String]).response { request, response, json, error in
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
                    hud.mode = MBProgressHUDMode.Text
                    hud.labelText = status.errorData
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                if(status.status == "success"){
                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.mode = MBProgressHUDMode.Text;
                    hud.labelText = "修改成功"
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                    let vc = NewMimaViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        
    }
    
    //  上传姓名
    func GetName(url:String,pmara:NSDictionary){
        
        
        Alamofire.request(.GET, url, parameters: pmara as? [String:AnyObject]).response { request, response, json, error in
            
            
        }
        
        
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
