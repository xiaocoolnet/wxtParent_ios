




//
//  QCDirectorBoxVC.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/21.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD


class QCDirectorBoxVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initUI(){
        self.title = "园长信箱"
        self.tabBarController?.tabBar.hidden = true
        self.view.backgroundColor = RGBA(239, g: 239, b: 244, a: 1)
        
        let textView = UITextView()
        textView.frame = CGRectMake(0, 0, WIDTH, WIDTH * 0.618)
        textView.userInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        textView.addGestureRecognizer(tap)
        self.view.addSubview(textView)
        
        let button = UIButton()
        button.frame = CGRectMake(10, WIDTH * 0.9, WIDTH - 20, 40)
        button.setTitle("提交", forState: .Normal)
        button.cornerRadius = 4
        button.backgroundColor = RGBA(155, g: 229, b: 180, a: 1)
        button.addTarget(self, action: #selector(sureAction), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(button)
        
        
    }
    func tapAction(){
        //  自己的视图结束第一响应
        self.view.endEditing(true)
    }

    func sureAction(){
        print("园长信箱提交")
        self.PutBlog()
    }
    func PutBlog(){
        //        http://wxt.xiaocool.net/index.php?g=apps&m=school&a=SetComment
//        http://wxt.xiaocool.net/index.php?g=apps&m=school&a=addMailBox&schoolid=2
        let chid = NSUserDefaults.standardUserDefaults()
        let schoolid = chid.stringForKey("schoolid")
        
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=school&a=addMailBox"
        
        let param = [
            "schoolid":schoolid!,
        ]
        
        Alamofire.request(.GET, url, parameters: param as? [String:String] ).response { request, response, json, error in
            if(error != nil){
            }
            else{
                print("request是")
                print(request!)
                print("====================")
                let result = Httpresult(JSONDecoder(json!))
                print("状态是")
                print(result.status)
                if(result.status == "error"){
                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.mode = MBProgressHUDMode.Text
                    hud.labelText = result.errorData
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                if(result.status == "success"){
                    print("Success")
                    self.navigationController?.popViewControllerAnimated(true)
                }
                
            }
            
        }
    }
}
