//
//  NReadOverViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/5/15.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import YYWebImage
import XWSwiftRefresh
import MBProgressHUD

class NReadOverViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    let table = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createTable()
        //        self.DropDownUpdate()
    }
    //    刷新
    func DropDownUpdate(){
        self.table.headerView = XWRefreshNormalHeader(target: self, action: #selector(NReadOverViewController.loadData))
        self.table.reloadData()
        self.table.headerView?.beginRefreshing()
    }
    //    创建表
    func createTable(){
        table.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-40)
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 70
        self.view.addSubview(table)
        
        table.registerNib(UINib.init(nibName: "ReadTableViewCell", bundle: nil), forCellReuseIdentifier: "ReadCell")
    }
    //    加载数据
    func loadData(){
        //        //        http://wxt.xiaocool.net/index.php?g=apps&m=index&a=GetMicroblog&schoolid=1&classid=1&type=3
        //        let url = apiUrl+"GetMicroblog"
        //
        //        let schoolid = NSUserDefaults.standardUserDefaults()
        //        let scid = schoolid.stringForKey("schoolid")
        //
        //        let classid = NSUserDefaults.standardUserDefaults()
        //        let clid = classid.stringForKey("classid")
        //
        //        let param = [
        //            "schoolid":scid!,
        //            "classid":clid!,
        //            "type":3
        //        ]
        //        Alamofire.request(.GET, url, parameters: param as? [String : AnyObject]).response { request, response, json, error in
        //            if(error != nil){
        //            }
        //            else{
        //                print("request是")
        //                print(request!)
        //                print("====================")
        //                let status = Http(JSONDecoder(json!))
        //
        //                print("状态是")
        //                print(status.status)
        //                if(status.status == "error"){
        //                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        //                    hud.mode = MBProgressHUDMode.Text;
        //                    hud.margin = 10.0
        //                    hud.removeFromSuperViewOnHide = true
        //                    hud.hide(true, afterDelay: 1)
        //                }
        //
        //                if(status.status == "success"){
        //                    self.blogSource = BlogList(status.data!)
        //                    self.table.reloadData()
        //                }
        //            }
        //
        //        }
        //        self.table.headerView?.endRefreshing()
    }
//    行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
//    单元格
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ReadCell", forIndexPath: indexPath)
            as! ReadTableViewCell
        cell.selectionStyle = .None
        
        return cell
    }


}
