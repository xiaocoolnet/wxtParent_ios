//
//  NewMimaViewController.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/8/10.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire

class NewMimaViewController: UIViewController {

    let newPassWordField = UITextField()
    let againPassWordField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()

        // Do any additional setup after loading the view.
        
        let sureButton = UIButton()
        sureButton.frame = CGRectMake(0,  0,  40, 20)
        sureButton.setTitle("保存", forState: .Normal)
        sureButton.addTarget(self, action: #selector(ChangeValue), forControlEvents: .TouchUpInside)
        let rightButton = UIBarButtonItem(customView: sureButton)
        self.navigationItem.rightBarButtonItem = rightButton
        
        let newPassWordLabel = UILabel()
        newPassWordLabel.frame = CGRectMake(10, 15, 80, 30)
        newPassWordLabel.text = "输入密码"
        self.view.addSubview(newPassWordLabel)
        
        newPassWordField.frame = CGRectMake(90, 5, WIDTH - 120, 50)
        newPassWordField.secureTextEntry = true
        self.view.addSubview(newPassWordField)
   
        let againPassWordLabel = UILabel()
        againPassWordLabel.frame = CGRectMake(10, 75, 80, 30)
        againPassWordLabel.text = "确认密码"
        self.view.addSubview(againPassWordLabel)
    
        againPassWordField.frame = CGRectMake(90, 70, WIDTH - 120, 50)
        againPassWordField.secureTextEntry = true
        self.view.addSubview(againPassWordField)
    
    
    }
    
    //  修改密码
    func ChangeValue(){
            if newPassWordField.text!.isEmpty {
                packUpfield()
                messageHUD(self.view, messageData: "请输入新密码")
                return
                //  请输入新密码
            }
            if againPassWordField.text!.isEmpty{
                packUpfield()
                messageHUD(self.view, messageData: "请重新输入密码")
                return
                //  请重新输入原始密码
            }
            if newPassWordField.text != againPassWordField.text{
                packUpfield()
                messageHUD(self.view, messageData: "两次密码输入不一致")
                return
                //  两次密码输入不一致
            }
        if newPassWordField.text == againPassWordField.text {
            packUpfield()
                //  进行传值 保存新密码的操作
                //            http://wxt.xiaocool.net/index.php?g=apps&m=index&a=forgetPass_Activate&userid=28&pass=123
                let defalutid = NSUserDefaults.standardUserDefaults()
                let studentid = defalutid.stringForKey("userid")
                let param = ["studentid":studentid,
                             "pass":self.newPassWordField.text!
                ]
                let url = "http://wxt.xiaocool.net/index.php?g=apps&m=index&a=forgetPass_Activate"
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
                            self.push()
                        }
                    }
                }
            
            }
    }
    // 跳转指定VC
    func push(){
        let vc = PersonInformation()
        var target:UIViewController?
        
        for controller in (self.navigationController?.viewControllers)! {
            if controller.isKindOfClass(vc .classForCoder) {
                target = controller
            }
        }
        if (target != nil) {
            self.navigationController?.popToViewController(target!, animated: true)
        }

    }
    
    //    MARK: - packUpTextField
    
    func packUpfield(){
        self.view.endEditing(true)
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
