//
//  HeightViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/6/1.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD


class HeightViewController: UIViewController {

    
    @IBOutlet weak var heightTextFiled: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.hidden = true
//        完成
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .Plain, target: self, action: #selector(HeightViewController.finished))
    }
//    完成
    func finished(){
        self.GetDate()
    }
//    记录身高
    func GetDate(){
        //http://wxt.xiaocool.net/index.php?g=apps&m=index&a=RecordHeight&stuid=599&stature=134
        //下面两句代码是从缓存中取出userid（入参）值
        let defalutid = NSUserDefaults.standardUserDefaults()
        let sid = defalutid.stringForKey("chid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=index&a=RecordHeight"
        let param = [
            "stuid":sid!,
            "stature":self.heightTextFiled.text!
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
                    hud.labelText = "今天已经记录"
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                if(status.status == "success"){
                    print("记录身高成功")
                    let vc = HeightNoteViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}
