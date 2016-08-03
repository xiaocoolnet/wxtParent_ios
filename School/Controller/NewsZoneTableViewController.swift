//
//  NewsZoneTableViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/6/4.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class NewsZoneTableViewController: UITableViewController {
    //  创建数据源
    var newsSource = NewsList()
    @IBOutlet var tableSource: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  得到数据
        self.GETData()
        self.tableSource.rowHeight = 116
        self.tableSource.backgroundColor = RGBA(239, g: 239, b: 244, a: 1)
        
    }
    func GETData() {
        //  请求网址
        //  http://wxt.xiaocool.net/index.php?g=apps&m=school&a=getSchoolNews&schoolid=1
//        http://wxt.xiaocool.net/index.php?g=apps&m=school&a=getschedulelist&userid=597&schoolid=1
        let url = kURL
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let schoolid = userDefaults.stringForKey("schoolid")
        let param = ["m":"school","a":"getSchoolNews","schoolid":schoolid]
        //  进行数据请求
        Alamofire.request(.GET, url, parameters: param as! [String:String]).response { request, response, json, error in
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
                        //  得到数据源
                        self.newsSource = NewsList(status.data!)
                        self.tableSource.reloadData()
                        self.tableSource.headerView?.endRefreshing()
                    }
                }
        }

        
        
        
    }
//行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.newsSource.count)
        return self.newsSource.count
    }
//单元格
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NewsZoneCell", forIndexPath: indexPath) as! NewsZoneTableViewCell
        cell.selectionStyle = .None
        //  得到model
        let newsInfo =  self.newsSource.objectList[indexPath.row]
        cell.fillCellWithData(newsInfo)
//        cell.readbtn.addTarget(self, action: #selector(NewsZoneTableViewController.readAll(_:)), forControlEvents: .TouchUpInside)
        return cell
    }
//    阅读全文
    func readAll(btn:UIButton){
        let vc = ReadAllViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = NewsDetailViewController()
        vc.id = self.newsSource.objectList[indexPath.row].id
        vc.tag = 2
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

}
