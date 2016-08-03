//
//  WeightViewController.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/2/15.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class WeightViewController: UIViewController, HisPickerViewDelegate {
    
    
    @IBOutlet weak var weightTextFiled: UITextField!
    
    var chartView:HisDatePicer?
    let lable = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.hidden = true
//        完成
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .Plain, target: self, action: #selector(WeightViewController.finished))
        
        lable.frame = CGRectMake(20, 300, 200, 20)
        lable.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(lable)
        
        chartView = HisDatePicer()
        chartView?.frame = CGRectMake(0, 350, WIDTH, HEIGHT/3)
        chartView?.delegate = self
//        self.view.addSubview(chartView!)
    }
    
    func hisPickerView(alertView: HisDatePicer!) {
//        self.lable.text = [NSString stringWithFormat:"%@",alertView.Taketime];
        self.lable.text = String(alertView.Taketime)
    }
    
//    完成
    func finished(){
        self.GetDate()
    }
//    记录体重
    func GetDate(){
        //http://wxt.xiaocool.net/index.php?g=apps&m=index&a=RecordWeight&stuid=599&weight=40
        //下面两句代码是从缓存中取出userid（入参）值
        let defalutid = NSUserDefaults.standardUserDefaults()
        let sid = defalutid.stringForKey("chid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=index&a=RecordWeight"
        let param = [
            "stuid":sid!,
            "weight":self.weightTextFiled.text!
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
                    print("记录体重成功")
                    let vc = WeightNoteViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}
