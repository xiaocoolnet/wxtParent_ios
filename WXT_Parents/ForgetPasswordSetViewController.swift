//
//  ForgetPasswordSetViewController.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/1/16.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
class ForgetPasswordSetViewController: UIViewController {
    
    
    @IBOutlet weak var setPassword: UITextField!
    
    @IBOutlet weak var againSetPassword: UITextField!
    
    @IBOutlet weak var finishButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        finishButton.addTarget(self, action: #selector(ForgetPasswordSetViewController.Finish), forControlEvents: UIControlEvents.TouchUpInside)
        
        // Do any additional setup after loading the view.
    }
    
    func Finish(){
        if Pankong() == true{
            UpdatePassword()
        }
    }
    
    func UpdatePassword(){
        
            let userid = NSUserDefaults.standardUserDefaults()
            let uid = userid.stringForKey("userid")
            
            let url = apiUrl+"forgetPass_Activate"
            let params = [
                "userid":uid!,
                "pass":setPassword.text!
            ]
            Alamofire.request(.GET, url, parameters: params).response { request, response, json, error in
                if(error != nil){
                }
                else{
                    print("request是")
                    print(request!)
                    print("====================")
                    let status = Httpresult(JSONDecoder(json!))
                    print("状态是")
                    print(status.status)
                    if(status.status == "error"){
                        messageHUD(self.view, messageData: status.errorData!)
                    }
                    
                    if(status.status == "success"){
                        messageHUD(self.view, messageData: "修改成功")
                        self.navigationController?.popToRootViewControllerAnimated(true)
                    }
                    
                }
                
            }
    }
    
    func Pankong() -> Bool{
        if(setPassword.text!.isEmpty){
            messageHUD(self.view, messageData: "请输入密码")
            return false
        }
        if(againSetPassword.text!.isEmpty){
            messageHUD(self.view, messageData: "请再次输入密码")
            return false
        }
        if(setPassword.text! != againSetPassword.text! ){
            messageHUD(self.view, messageData: "请输入相同密码")
            return false
        }
        else{
            return true
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
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