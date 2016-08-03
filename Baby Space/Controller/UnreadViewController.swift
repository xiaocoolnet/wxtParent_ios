//
//  UnreadViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/5/13.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import YYWebImage
import XWSwiftRefresh
import MBProgressHUD

class UnreadViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    let table = UITableView()
    let remindBtn = UIButton(type: .Custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = RGBA(242.0, g: 242.0, b: 242.0, a: 1)
        
        self.createTable()
        self.createAllChooseView()
        //        self.DropDownUpdate()
    }
    //    刷新
    func DropDownUpdate(){
        self.table.headerView = XWRefreshNormalHeader(target: self, action: #selector(UnreadViewController.loadData))
        self.table.reloadData()
        self.table.headerView?.beginRefreshing()
    }
    //    创建表
    func createTable(){
        table.frame = CGRectMake(0, 10, self.view.frame.size.width, self.view.frame.size.height-64-49-50)
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 70
        self.view.addSubview(table)
        
        table.registerNib(UINib.init(nibName: "UnreadTableViewCell", bundle: nil), forCellReuseIdentifier: "UnreadCell")
    }
//    创建全选的试图
    func createAllChooseView(){
        let v = UIView(frame: CGRectMake(0,HEIGHT-154,WIDTH,50))
        v.backgroundColor = RGBA(242.0, g: 242.0, b: 242.0, a: 1)
        self.view.addSubview(v)
        
        let allBtn = UIButton(type:.Custom)
        allBtn.frame = CGRectMake(10, 15, 20, 20)
        allBtn.addTarget(self, action: #selector(UnreadViewController.allChoose(_:)), forControlEvents: .TouchUpInside)
        allBtn.setImage(UIImage(named: "ic_fasong.png"), forState: .Normal)
        allBtn.setImage(UIImage(named: "Logo.png"), forState: .Selected)
        v.addSubview(allBtn)
        
        let lbl = UILabel(frame:CGRectMake(40, 10, 50, 30))
        lbl.text = "全选"
        v.addSubview(lbl)
        
        
        remindBtn.frame = CGRectMake(WIDTH-90, 10, 80, 30)
        remindBtn.setTitle("提醒", forState:.Normal)
        remindBtn.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        remindBtn.titleLabel?.font = UIFont.systemFontOfSize(15)
        remindBtn.layer.masksToBounds = true
        remindBtn.layer.cornerRadius = 10.0
        remindBtn.layer.borderWidth = 1.0
        remindBtn.layer.borderColor = RGBA(138.0, g: 227.0, b: 163.0, a: 1).CGColor
        remindBtn.addTarget(self, action: #selector(UnreadViewController.remindPress), forControlEvents: .TouchUpInside)
        v.addSubview(remindBtn)
    }
//    全选
    func allChoose(sender:UIButton){
        let allBtn:UIButton = sender
        if allBtn.selected {
            allBtn.selected = false
            remindBtn.enabled = false
            remindBtn.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        }else{
            allBtn.selected = true
            remindBtn.enabled = true
            remindBtn.setTitleColor(RGBA(138.0, g: 227.0, b: 163.0, a: 1), forState: .Normal)
        }
    }
//    提醒
    func remindPress(){
        
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
        return 10
    }
//    单元格
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UnreadCell", forIndexPath: indexPath)
            as! UnreadTableViewCell
        cell.selectionStyle = .None
        
        return cell
    }

}
