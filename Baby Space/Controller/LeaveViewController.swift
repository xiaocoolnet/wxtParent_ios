//
//  LeaveViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/5/6.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import XWSwiftRefresh
import MBProgressHUD
class LeaveViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    let tableSource = UITableView()
    var leaveSource = LeaveListModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(LeaveViewController.wirteQJ))
        self.createTable()
        self.DropDownUpdate()
    }
    //    写假条
    func wirteQJ(){
        let vc = LeaveChildViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //    开始刷新
    func DropDownUpdate(){
        self.tableSource.headerView = XWRefreshNormalHeader(target: self, action: #selector(LeaveViewController.loadData))
        self.tableSource.reloadData()
        self.tableSource.headerView?.beginRefreshing()
    }
    func loadData(){
        //http://wxt.xiaocool.net/index.php?g=apps&m=student&a=getleavelist&studentid=12
        //下面两句代码是从缓存中取出userid（入参）值
        let defalutid = NSUserDefaults.standardUserDefaults()
        let chid = defalutid.stringForKey("chid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=getleavelist"
        let param = [
            "studentid":chid!
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
                    self.leaveSource = LeaveListModel(status.data!)
                    self.tableSource.reloadData()
                    self.tableSource.headerView?.endRefreshing()
                }
            }
        }
    }
    //    创建表
    func createTable(){
        tableSource.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)
        tableSource.delegate = self
        tableSource.dataSource = self
        tableSource.separatorStyle = .None
        self.view.addSubview(tableSource)
        
        tableSource.registerNib(UINib.init(nibName: "OnlineQJTableViewCell", bundle: nil), forCellReuseIdentifier: "OnlineQJCell")
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.leaveSource.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OnlineQJCell", forIndexPath: indexPath) as! OnlineQJTableViewCell
        cell.selectionStyle = .None
        let leaveInfo = self.leaveSource.leaveList[indexPath.row]
        cell.motherNameLbl.text = leaveInfo.parentname
        cell.teacherNameLbl.text = leaveInfo.parentname
        if leaveInfo.status == "0" {
            cell.statusLbl.text = "未处理"
        }else if leaveInfo.status == "1" {
            cell.statusLbl.text = "已同意"
        }else{
            cell.statusLbl.text = "不同意"
        }
        cell.contentLbl.text = leaveInfo.reason
        let dateformate = NSDateFormatter()
        dateformate.dateFormat = "yyyy-MM-dd"
        let begintime = NSDate(timeIntervalSince1970: NSTimeInterval(leaveInfo.begintime!)!)
        let str:String = dateformate.stringFromDate(begintime)
        let endtime = NSDate(timeIntervalSince1970: NSTimeInterval(leaveInfo.endtime!)!)
        let str1:String = dateformate.stringFromDate(endtime)
        cell.timeLbl.text = "\(str)至\(str1)"
        //        自适应行高
        let options : NSStringDrawingOptions = NSStringDrawingOptions.UsesLineFragmentOrigin
        let screenBounds:CGRect = UIScreen.mainScreen().bounds
        let boundingRect = String(cell.contentLbl.text).boundingRectWithSize(CGSizeMake(screenBounds.width, 0), options: options, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(17)], context: nil)
        tableSource.rowHeight = boundingRect.size.height + 122
        return cell
    }
}
