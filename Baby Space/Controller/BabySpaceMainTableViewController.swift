//
//  BabySpaceMainTableViewController.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/1/18.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import XWSwiftRefresh
import Alamofire

class BabySpaceMainTableViewController: UITableViewController {

    
    
    @IBOutlet weak var childrenAvator: UIImageView!
    @IBOutlet weak var childrenClass: UILabel!
    @IBOutlet weak var childrenName: UILabel!
    @IBOutlet weak var childrenSex: UIImageView!
    @IBOutlet weak var childrenAge: UILabel!
    @IBOutlet weak var childrenSchoole: UILabel!
    @IBOutlet weak var arriveTimeLabel: UILabel!
    @IBOutlet weak var leaveTimeLabel: UILabel!
    @IBOutlet weak var arriveTemperatureLabel: UILabel!
    @IBOutlet weak var leavearriveTemperatureLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    var blog=BlogMainTableTableViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.tabBarItem.badgeValue = "3"
        childrenClass.layer.cornerRadius = 8
        childrenClass.layer.masksToBounds = true
        DropDownUpdate()
    }
    func GetDate(){
        self.tableView.reloadData()
        self.tableView.headerView?.endRefreshing()
        self.GetBabyTodayInfo()
        self.GetChange_sta_wei()
        print("test")
    }
//    刷新
    func DropDownUpdate(){
        self.tableView.headerView = XWRefreshNormalHeader(target: self, action: #selector(BabySpaceMainTableViewController.GetDate))
        self.tableView.headerView?.beginRefreshing()
    }
    
    override func viewWillAppear(animated: Bool) {
        //DropDownUpdate()
        GetDate()
        self.tabBarController?.tabBar.hidden = false
    }
    
    //获取宝宝今日记录
    func GetBabyTodayInfo(){
        let chid = NSUserDefaults.standardUserDefaults()
        let stuid = chid.stringForKey("chid")
        let url = apiUrl+"GetStudentLog"
        let param = [
            "stuid":stuid!
        ]
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            if(error != nil){
            }
            else{
                print("request是")
                print(request!)
                print("====================")
                let result = BabyTodayInfoModel(JSONDecoder(json!))
                print("状态是")
                print(result.status)
                if(result.status == "error"){
                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.mode = MBProgressHUDMode.Text;
                    hud.labelText = result.errorData
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                
                if(result.status == "success"){
                    print("Success")
                    self.arriveTimeLabel.text = result.data?.arrivetime
                    self.leaveTimeLabel.text = result.data?.leavetime
                    self.arriveTemperatureLabel.text = result.data?.arrivetemperature
                    self.leavearriveTemperatureLabel.text = result.data?.learntemperature
                }
                
            }
            
        }

    }
    
    //获取身高、体重信息
    func GetChange_sta_wei(){
        let chid = NSUserDefaults.standardUserDefaults()
        let stuid = chid.stringForKey("chid")
        let url = apiUrl+"GetChange_sta_wei"
        let param = [
            "stuid":stuid!
        ]
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            if(error != nil){
            }
            else{
                print("request是")
                print(request!)
                print("====================")
                let result = GetChange_sta_weiModel(JSONDecoder(json!))
                print("状态是")
                print(result.status)
                if(result.status == "error"){
                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.mode = MBProgressHUDMode.Text;
                    hud.labelText = result.errorData
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                
                if(result.status == "success"){
                    print("Success")
                    self.weightLabel.text = result.data?.new_weight!
                    self.heightLabel.text = result.data?.new_stature!
                }
                
            }
            
        }

    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        return 0.01
        
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5.0
    }
}
