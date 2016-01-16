//
//  ForgetPasswordViewController.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/1/16.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire

class ForgetPasswordViewController: UIViewController {

    @IBOutlet weak var phoneNumberText: UITextField!
    @IBOutlet weak var codeText: UITextField!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var getCodeButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
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

        self.navigationController?.navigationBar.hidden = false
        getCodeButton.addTarget(self, action: Selector("GetCode"), forControlEvents: UIControlEvents.TouchUpInside)
        nextButton.addTarget(self, action: Selector("Next"), forControlEvents: UIControlEvents.TouchUpInside)
        codeLabel.hidden = true
        // Do any additional setup after loading the view.
    }
    
    func GetCode(){
        if (phoneNumberText.text!.isEmpty||phoneNumberText.text?.characters.count != 11)
        {
            var alerView:UIAlertView = UIAlertView()
            alerView.title = "手机号输入错误"
            alerView.message = "请重新输入"
            alerView.addButtonWithTitle("确定")
            alerView.cancelButtonIndex = 0
            alerView.delegate = self
            alerView.tag = 1
            alerView.show()
        }
        else
        {
            
            var alerView:UIAlertView = UIAlertView()
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
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ForgetPasswordView") as! UIViewController
            //self.presentViewController(vc, animated: true, completion: nil)
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
    func PandKong()->Bool{
        if(phoneNumberText.text!.isEmpty){
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.mode = MBProgressHUDMode.Text
            hud.labelText = "请输入手机号"
            hud.margin = 10.0
            hud.removeFromSuperViewOnHide = true
            hud.hide(true, afterDelay: 1)
            return false
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
    
    func timeDow()
    {
        var time1 = NSTimer.scheduledTimerWithTimeInterval(1.0, target:self, selector: "updateTime", userInfo: nil, repeats: true)
        timeNow = time1
    }
    
    func showRepeatButton()
    {
        codeLabel.hidden=true
        getCodeButton.hidden = false
        getCodeButton.enabled = true
    }
    
    func updateTime()
    {
        count--
        if (count <= 0)
        {
            count = 60
            self.showRepeatButton()
            timeNow.invalidate()
        }
        codeLabel.text = "\(count)S"
        
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if alertView.tag == 0
        {
            if buttonIndex == 1
            {
                self.senderMessage()
                getCodeButton.hidden = true
                codeLabel.hidden = false
                self.timeDow()
            }
        }
        if alertView.tag == 1
        {}
        if alertView.tag == 2
        {}
    }
    
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
