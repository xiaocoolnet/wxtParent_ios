//
//  WriteExhortViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/5/4.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
class WriteExhortViewController: UIViewController {

    var studentid:String?
    var teacherid:String?
    var teacherName:String?
    var studentName:String?
    
    let contentTextView = BRPlaceholderTextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "叮嘱"
        self.view.backgroundColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1)
        let rightItem = UIBarButtonItem(title: "发送", style: .Done, target: self, action: #selector(WriteExhortViewController.sendExhort))
        self.navigationItem.rightBarButtonItem = rightItem
        self.createUI()
    }
//    发送
    func sendExhort(){
        self.writeExhort()
        let vc = ParentsExhortViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
//    创建UI
    func createUI(){
        let v1 = UIView()
        v1.frame = CGRectMake(0, 0, self.view.frame.size.width, 121)
        v1.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(v1)
        
        let lbl1 = UILabel()
        lbl1.frame = CGRectMake(10, 20, 60, 20)
        lbl1.text = "叮嘱人"
        lbl1.font = UIFont.systemFontOfSize(15)
        lbl1.textColor = UIColor(red: 171/255.0, green: 171/255.0, blue: 171/255.0, alpha: 1)
        v1.addSubview(lbl1)
        
        let lbl2 = UILabel()
        lbl2.frame = CGRectMake(80, 20, 100, 20)
        lbl2.text = studentName!
        v1.addSubview(lbl2)
        
        let lineView = UIView()
        lineView.frame = CGRectMake(0, 61, self.view.frame.size.width, 1)
        lineView.backgroundColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1)
        v1.addSubview(lineView)
        
        let lbl3 = UILabel()
        lbl3.frame = CGRectMake(10, 81, 60, 20)
        lbl3.text = "接收人"
        lbl3.font = UIFont.systemFontOfSize(15)
        lbl3.textColor = UIColor(red: 171/255.0, green: 171/255.0, blue: 171/255.0, alpha: 1)
        v1.addSubview(lbl3)
        
        let lbl4 = UILabel()
        lbl4.frame = CGRectMake(80, 81, 100, 20)
        lbl4.text = teacherName!
        v1.addSubview(lbl4)
        
        self.contentTextView.frame = CGRectMake(0, 131, self.view.bounds.width, 200)
        self.contentTextView.font = UIFont.systemFontOfSize(15)
        self.contentTextView.placeholder = "说说您的叮嘱吧"
        self.view.addSubview(self.contentTextView)
    }
    func writeExhort(){
        //http://wxt.xiaocool.net/index.php?g=apps&m=student&a=addentrust&teacherid=597&userid=12&studentid=22&content=孩子有点感冒，让中午吃药
        //下面两句代码是从缓存中取出userid（入参）值
        let defalutid = NSUserDefaults.standardUserDefaults()
        let uid = defalutid.stringForKey("userid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=addentrust"
        let param = [
            "teacherid":teacherid!,
            "studentid":studentid!,
            "userid":uid!,
            "content":self.contentTextView.text
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
                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.mode = MBProgressHUDMode.Text
                    hud.labelText = status.errorData
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                if(status.status == "success"){
                  print("叮嘱发送成功")
                }
            }
        }
    }
    //    收键盘
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

}
