//
//  QCMyFamilyVC.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/14.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import ImageSlideshow
import XWSwiftRefresh
import MBProgressHUD

class QCMyFamilyVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var getTitle: String!
    
    var dataSource : InviteInfo?
    
    var myTableView = UITableView()
    
    let titLabArr:[String] = ["绑定接送卡","设置主号","删除"]
    let imgArr:[String] = ["","",""]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    

        initUI()
        
        initTableView()
    }
    func initUI(){
        if getTitle != nil {
            self.title = getTitle
        }
        self.tabBarController?.tabBar.hidden = true
        self.view.backgroundColor = RGBA(239, g: 239, b: 244, a: 1)
    }
    func initTableView(){
        
        myTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT)
        myTableView.delegate = self
        myTableView.dataSource = self
        
        self.view.addSubview(myTableView)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dataSource?.type == "0" {
            return 3
        }else{
            return 1
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier:String(indexPath.row))
        cell.selectionStyle = .None
        
        if self.dataSource?.type == "0" {
            let titleLab = UILabel()
            titleLab.frame = CGRectMake(50, 15, 150, 30)
            titleLab.text = titLabArr[indexPath.row]
            cell.contentView.addSubview(titleLab)
        }else{
            let titleLab = UILabel()
            titleLab.frame = CGRectMake(50, 15, 150, 30)
            titleLab.text = "绑定接送卡"
            cell.contentView.addSubview(titleLab)
        }
        
        let line = UIView()
        line.frame = CGRectMake(0, 59.5, WIDTH, 0.5)
        line.backgroundColor = UIColor.lightGrayColor()
        cell.contentView.addSubview(line)
        
        return cell

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.dataSource?.type == "0" {
            if indexPath.row == 2 {
                self.GetDate()
            }
            if indexPath.row == 1 {
                self.createDate()
            }
        }else{
//            self.createDate()
        }
    }
    
    
    func createDate(){
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=SetMainParent"
        //      http://wxt.xiaocool.net/index.php?g=apps&m=student&a=SetMainParent&studentid=597&userid=605
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let studentid = userDefaults.stringForKey("chid")
        
        
        let param = [
            "studentid":studentid,
            "userid":self.dataSource?.userid
        ]
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
                    hud.mode = MBProgressHUDMode.Text;
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                
                if(status.status == "success"){
                    
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
            
        }

    }
    
    //    加载数据
    func GetDate(){
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=DeleteFamily"
        //      http://wxt.xiaocool.net/index.php?g=apps&m=student&a=DeleteFamily&studentid=597&userid=605
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let studentid = userDefaults.stringForKey("chid")
        
        
        let param = [
            "studentid":studentid,
            "userid":self.dataSource?.userid
        ]
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
                    hud.mode = MBProgressHUDMode.Text;
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                
                if(status.status == "success"){
                
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
            
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
