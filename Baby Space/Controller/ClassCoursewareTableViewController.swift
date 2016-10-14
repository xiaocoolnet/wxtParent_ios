//
//  ClassCoursewareTableViewController.swift
//  WXT_Parents
//
//  Created by 牛尧 on 16/2/21.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import ImageSlideshow
import XWSwiftRefresh
import MBProgressHUD
//宝宝课件
class ClassCoursewareTableViewController: UITableViewController {
    
    @IBOutlet var tableSource: UITableView!
    var dataSource = CoursewareList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//     隐藏标签栏
        self.tabBarController?.tabBar.hidden = true
        
        GETData()
    }
//    行数
    
    func GETData(){
    //  http://wxt.xiaocool.net/index.php?g=apps&m=index&a=SchoolCourseware&schoolid=1&classid=1

        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=index&a=SchoolCourseware"
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let schoolid = userDefaults.valueForKey("schoolid")
        let classid = userDefaults.valueForKey("classid")
        
        let param = ["schoolid":schoolid,"classid":classid]
        
        Alamofire.request(.GET, url, parameters: param as? [String:AnyObject]).response { request, response, json, error in
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
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                if(status.status == "success"){
                    
                    self.dataSource = CoursewareList(status.data!)
                    print(self.dataSource.count)
                    self.tableSource.reloadData()
                
                }
            }
        }

    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
//    单元格
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier:String(indexPath.row))
        cell.selectionStyle = .None
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        tableSource.separatorStyle = .None
        let model = self.dataSource.objectlist[indexPath.row]
        let typeLbl = UILabel()
        typeLbl.frame = CGRectMake(10, 10, 200, 40)
        typeLbl.text = (model.subject)
        typeLbl.font = UIFont.systemFontOfSize(19)
        cell.contentView.addSubview(typeLbl)
        let str = model.courseware_info
        let countLabel = UILabel()
        countLabel.frame = CGRectMake(210, 10, WIDTH - 260, 40)
        countLabel.text = String(str.count)
        countLabel.font = UIFont.systemFontOfSize(19)
        countLabel.textAlignment = NSTextAlignment.Right
        countLabel.textColor = UIColor.lightGrayColor()
        cell.contentView.addSubview(countLabel)
        
        let line = UILabel()
        line.frame = CGRectMake(2, 59.5, WIDTH - 2, 0.5)
        line.backgroundColor = UIColor.lightGrayColor()
        cell.contentView.addSubview(line)
        
        

        return cell
    }
//    单元格点击事件
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = self.dataSource.objectlist[indexPath.row]
        let vc = CourseDetailViewController()
        vc.title = model.subject! + "课件"
        vc.id = model.id
        vc.dataSource = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}