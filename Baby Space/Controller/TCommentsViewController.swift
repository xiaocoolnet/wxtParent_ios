//
//  TCommentsViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/5/26.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class TCommentsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    var teacherid:String?
    let table = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.createTable()
        
    }
    //    创建表
    func createTable(){
        table.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64)
        table.delegate = self
        table.dataSource = self
        self.view.addSubview(table)
        
        table.registerNib(UINib.init(nibName: "TCommentsTableViewCell", bundle: nil), forCellReuseIdentifier: "TCommentsCell")
    }
//    加载数据
//    func GetDate(){
//        //        http://wxt.xiaocool.net/index.php?g=apps&m=student&a=getclassteacherlist&studentid=597&classid=1
//        //下面两句代码是从缓存中取出userid（入参）值
//        let defalutid = NSUserDefaults.standardUserDefaults()
//        let sid = defalutid.stringForKey("chid")
//        let classid = defalutid.stringForKey("classid")
//        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=getclassteacherlist"
//        let param = [
//            "studentid":sid!,
//            "classid":classid!
//        ]
//        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
//            if(error != nil){
//            }
//            else{
//                print("request是")
//                print(request!)
//                print("====================")
//                let status = Http(JSONDecoder(json!))
//                print("状态是")
//                print(status.status)
//                if(status.status == "error"){
//                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//                    hud.mode = MBProgressHUDMode.Text
//                    hud.labelText = status.errorData
//                    hud.margin = 10.0
//                    hud.removeFromSuperViewOnHide = true
//                    hud.hide(true, afterDelay: 1)
//                }
//                if(status.status == "success"){
//                    self.teacherSource = TeacherList(status.data!)
//                    self.table.reloadData()
//                }
//            }
//        }
//    }
//    行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
//    单元格
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TCommentsCell", forIndexPath: indexPath) 
        cell.selectionStyle = .None
//        let leaveInfo = self.leaveSource.leaveList[indexPath.row]
//        cell.motherNameLbl.text = leaveInfo.parentname
//        cell.teacherNameLbl.text = leaveInfo.parentname
//        if leaveInfo.status == "0" {
//            cell.statusLbl.text = "未处理"
//        }else if leaveInfo.status == "1" {
//            cell.statusLbl.text = "已同意"
//        }else{
//            cell.statusLbl.text = "不同意"
//        }
//        cell.contentLbl.text = leaveInfo.reason
//        let dateformate = NSDateFormatter()
//        dateformate.dateFormat = "yyyy-MM-dd"
//        let begintime = NSDate(timeIntervalSince1970: NSTimeInterval(leaveInfo.begintime!)!)
//        let str:String = dateformate.stringFromDate(begintime)
//        let endtime = NSDate(timeIntervalSince1970: NSTimeInterval(leaveInfo.endtime!)!)
//        let str1:String = dateformate.stringFromDate(endtime)
//        cell.timeLbl.text = "\(str)至\(str1)"
//
        return cell
    }
//    行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //        自适应行高
//        let options : NSStringDrawingOptions = NSStringDrawingOptions.UsesLineFragmentOrigin
//        let screenBounds:CGRect = UIScreen.mainScreen().bounds
//        let boundingRect = String(cell.contentLbl.text).boundingRectWithSize(CGSizeMake(screenBounds.width, 0), options: options, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(17)], context: nil)
//        tableSource.rowHeight = boundingRect.size.height + 122
        return 111
    }
}
