//
//  SchoolInfoViewController.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/1/31.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD


class SchoolInfoViewController: UIViewController {

    @IBOutlet weak var bigImageView: UIImageView!
    
    @IBOutlet weak var introduceLbl: UILabel!
    
    @IBOutlet weak var contactWeBtn: UIButton!
    
    var schoolSource = SchoolList()
    var schoolInfo = SchoolInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.hidden = true
        self.GetDate()
        self.contactWeBtn.addTarget(self, action: #selector(SchoolInfoViewController.contactWe), forControlEvents: .TouchUpInside)
    }
//    加载数据
    func GetDate(){
        //        http://wxt.xiaocool.net/index.php?g=apps&m=school&a=getschoolinfo&schoolid=1
        let defalutid = NSUserDefaults.standardUserDefaults()
        let sid = defalutid.stringForKey("schoolid")
        
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=school&a=getschoolinfo"
        let param = [
            "schoolid":sid!
        ]
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
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
                self.schoolSource = SchoolList(JSONDecoder(json!))
                print("状态是")
                print(self.schoolSource.status)
                print(self.schoolInfo)
                if self.schoolSource.status == "error" {
                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.mode = MBProgressHUDMode.Text;
                    hud.labelText = self.schoolSource.errorData
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                if self.schoolSource.status == "success" {
                    self.schoolInfo = self.schoolSource.data!
                    self.introduceLbl.text = self.schoolInfo.detail
                    let imgUrl = imageUrl + self.schoolInfo.photo!
                    let avatarUrl = NSURL(string: imgUrl)
                    self.bigImageView.yy_setImageWithURL(avatarUrl, placeholder: UIImage(named: "幼儿园简介图片.png"))
                }
            }
        }
    }
//    联系我们
    func contactWe(){
        var phone = String()
        phone = "telprompt:\(String(self.schoolInfo.phone!))"
        UIApplication.sharedApplication().openURL(NSURL.init(string: phone)!)
    }
}
