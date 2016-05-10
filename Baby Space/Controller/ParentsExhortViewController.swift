//
//  ParentsExhortViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/4/29.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import XWSwiftRefresh
import MBProgressHUD
class ParentsExhortViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    let table = UITableView()
    var parentsExhortSource = ParentsExhortList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(ParentsExhortViewController.wirteExhort))
        self.createTable()
        self.DropDownUpdate()
        
    }
    //    开始刷新
    func DropDownUpdate(){
        self.table.headerView = XWRefreshNormalHeader(target: self, action: #selector(ParentsExhortViewController.loadData))
        self.table.reloadData()
        self.table.headerView?.beginRefreshing()
    }
//    写叮嘱
    func wirteExhort(){
       let vc = StuRelationViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
//    创建表
    func createTable(){
        table.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .None
        self.view.addSubview(table)
        
        table.registerNib(UINib.init(nibName: "ParentsExhortTableViewCell", bundle: nil), forCellReuseIdentifier: "ParentsExhortID")
    }
//    获取数据
    func loadData(){
        //        http://wxt.xiaocool.net/index.php?g=apps&m=student&a=getentrustlist&userid=12
        
        //下面两句代码是从缓存中取出userid（入参）值
        let defalutid = NSUserDefaults.standardUserDefaults()
        let uid = defalutid.stringForKey("userid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=getentrustlist"
        let param = [
            "userid":uid!
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
                    self.parentsExhortSource = ParentsExhortList(status.data!)
                    self.table.reloadData()
                    self.table.headerView?.endRefreshing()
                }
            }
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parentsExhortSource.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ParentsExhortID", forIndexPath: indexPath)
            as! ParentsExhortTableViewCell
        cell.selectionStyle = .None
        let exhortInfo = self.parentsExhortSource.parentsExhortList[indexPath.row]
        let dateformate = NSDateFormatter()
        dateformate.dateFormat = "yyyy-MM-dd HH:mm"
        
        cell.nameLbl.text = exhortInfo.username
        cell.contentLbl.text = exhortInfo.content
        let date = NSDate(timeIntervalSince1970: NSTimeInterval(exhortInfo.create_time!)!)
        let str:String = dateformate.stringFromDate(date)
        cell.timeLbl.text = str
        cell.teacherNameLbl.text = exhortInfo.teachername
//        自适应行高
        let options : NSStringDrawingOptions = NSStringDrawingOptions.UsesLineFragmentOrigin
        let screenBounds:CGRect = UIScreen.mainScreen().bounds
        let boundingRect = String(cell.contentLbl.text).boundingRectWithSize(CGSizeMake(screenBounds.width, 0), options: options, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(17)], context: nil)
        table.rowHeight = boundingRect.size.height + 100
        return cell
    }
}
