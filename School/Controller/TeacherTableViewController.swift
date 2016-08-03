//
//  TeacherTableViewController.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/1/31.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
//  教师风采页面
class TeacherTableViewController: UITableViewController {
    //  定义数据源
    var dataSourse = teacherList()
    @IBOutlet var tableSource: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.hidden = true
        //  注册cell
        self.tableView.registerClass(SchoolNoticeCell.self, forCellReuseIdentifier: "cell")
        //  创建ui
        self.createUI()
        
        //  进行网络请求
        self.GET()

    }
    func createUI(){
       tableSource.backgroundColor = RGBA(239, g: 239, b: 244, a: 1)
    }
    func GET(){
        //  http://wxt.xiaocool.net/index.php?g=apps&m=school&a=getteacherinfos&schoolid=1
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let schoolid = userDefaults.valueForKey("schoolid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps"
        let param = ["m":"school","a":"getteacherinfos","schoolid":schoolid!]
        //  进行数据请求
        Alamofire.request(.GET, url, parameters: param).response{ request, response, json, error in
            if error != nil{
                print(error)
            }else{
                //  得到请求状态
            
                let status = TeacherModel(JSONDecoder(json!))
                if status.status == "success"{
                    //  请求成功 
                    print("请求成功")
                    //  填充数据源
                    self.dataSourse =  teacherList(status.data!)
                    //  刷新 UI
                    self.tableView.reloadData()
                }
                if status.status == "error"{
                    //  进行延迟加载信息
                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.mode = MBProgressHUDMode.Text
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
            }
        }
        
        }
    // MARK: - Table view data source
//分区数
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
//行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.dataSourse.count
    }
//    单元格
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //  认证cell
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SchoolNoticeCell
        cell.selectionStyle = .None
        
        //  进行cell的填充操作！！！
        let model = self.dataSourse.objectList[indexPath.row]
        cell.titleLabel.text = model.post_title
        
//        //  转时间戳
//        let mondayInterval:NSTimeInterval = NSTimeInterval(model.notice_time!)!
//        let mondayDate = NSDate(timeIntervalSince1970: mondayInterval)
//        
//        //格式话输出
//        let dformatter = NSDateFormatter()
//        //        dformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        dformatter.dateFormat = "MM-dd HH:mm"
//        
//        timeLable.text = dformatter.stringFromDate(mondayDate)
        let time = (model.post_dateL! as NSString).substringFromIndex(5)
        cell.timeLable.text = time
        cell.contentLabel.numberOfLines = 0
        cell.contentLabel.text = model.post_excerpt
        let imageURL = microblogImageUrl + model.thumb!
        cell.headerImageView.sd_setImageWithURL(NSURL.init(string: imageURL), placeholderImage: UIImage(named: "1.png"))
//        cell.headerImageView.sd_setImageWithURL(NSURL.init(string: imageURL))


        return cell
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //  设置行高

        
        return 116
    }
//    单元格点击事件
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let teacherInfo = self.dataSourse.objectList[indexPath.row]
        let id = teacherInfo.id
        let vc = TeacherInfoViewController()
        vc.id = id
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
