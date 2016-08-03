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
import MBProgressHUD

class BabySpaceMainTableViewController: UITableViewController {

    
    @IBOutlet var tableSource: UITableView!
    @IBOutlet weak var childrenAvator: UIImageView!
    @IBOutlet weak var childrenClass: UILabel!
    @IBOutlet weak var childrenName: UILabel!
    @IBOutlet weak var childrenSex: UIImageView!
    @IBOutlet weak var childrenAge: UILabel!
    @IBOutlet weak var childrenSchoole: UILabel!
    //  时间  温度
    @IBOutlet weak var arriveTimeLabel: UILabel!
    @IBOutlet weak var leaveTimeLabel: UILabel!
    @IBOutlet weak var arriveTemperatureLabel: UILabel!
    @IBOutlet weak var leavearriveTemperatureLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    
    
    var blog=BlogMainTableTableViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
//      self.navigationController?.tabBarItem.badgeValue = "3"
        childrenClass.layer.cornerRadius = 8
        childrenClass.layer.masksToBounds = true

        
        DropDownUpdate()
    }
    
    //  MARK: - 邀请家人
    @IBAction func visitFamily(sender: AnyObject) {
        print("邀请家人")
        let invitationVC = QCInvitationVC()
        self.navigationController?.pushViewController(invitationVC, animated: true)
        
    }
    
    //  MARK: - 代接确认
    @IBAction func toTakeAction(sender: AnyObject) {
        let vc = QCKindTakeVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func GetDate(){
        tableSource.reloadData()
        tableSource.headerView?.endRefreshing()
        self.GetBabyTodayInfo()
        self.GetChange_sta_wei()
        
    }
//    刷新
    func DropDownUpdate(){
        tableSource.headerView = XWRefreshNormalHeader(target: self, action: #selector(BabySpaceMainTableViewController.GetDate))
        tableSource.headerView?.beginRefreshing()
    }
    
    override func viewWillAppear(animated: Bool) {
        DropDownUpdate()
        GetDate()
        self.tabBarController?.tabBar.hidden = false
        //        设置宝宝名字
        let chid = NSUserDefaults.standardUserDefaults()
        let chidname = chid.stringForKey("chidname")
        self.childrenName.text = chidname
    }
    
    //获取宝宝今日记录
    func GetBabyTodayInfo(){
        let chid = NSUserDefaults.standardUserDefaults()
        let stuid = chid.stringForKey("chid")
        print(stuid)
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
                    //  得到温度和时间
                    
                    //  进行时间戳的转换
                    let dateformate = NSDateFormatter()
                    dateformate.dateFormat = "yyyy-MM-dd HH:mm"//获得日期
                    if result.data?.arrivetime != nil{
                    let date = NSDate(timeIntervalSince1970: NSTimeInterval((result.data?.arrivetime)!)!)
                    let str:String = dateformate.stringFromDate(date)
                        print(str)
                    let timeStr = (str as NSString).substringFromIndex(11)
                        self.arriveTimeLabel.text = timeStr
                        
                    }
                    if result.data?.leavetime != nil{
                        let date = NSDate(timeIntervalSince1970: NSTimeInterval((result.data?.leavetime)!)!)
                        let str:String = dateformate.stringFromDate(date)
                        let timeStr = (str as NSString).substringFromIndex(11)

                        self.leaveTimeLabel.text = timeStr
                        
                    }
                    
//                    self.leaveTimeLabel.text = str2
                    self.arriveTemperatureLabel.text = result.data?.arrivetemperature
                    self.leavearriveTemperatureLabel.text = result.data?.learntemperature
                }
                
            }
            
        }

    }
    
    //获取身高、体重信息
    func GetChange_sta_wei(){
//        http://wxt.xiaocool.net/index.php?g=apps&m=index&a=GetChange_sta_wei&stuid=599
//        http://wxt.xiaocool.net/index.php?g=apps&m=index&a=RecordWeight&stuid=599&weight=40
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

    
}
