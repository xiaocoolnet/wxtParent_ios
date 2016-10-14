//
//  ClassScheduleTableViewController.swift
//  WXT_Parents
//
//  Created by 牛尧 on 16/2/24.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import XWSwiftRefresh
import MBProgressHUD

//  班级课程的界面

//  需要进行网络数据请求得到对应的课程

class ClassScheduleTableViewController: UITableViewController {
   
   
    @IBOutlet var tableSource: UITableView!
    
    var dataSource = Array<Array<MonInfo>>()
//    var baby = BabyClassList()
    var oneArr = [[String:JSONDecoder]]()
    var twoArr = [[String:JSONDecoder]]()
    var threeArr = [[String:JSONDecoder]]()
    var fourArr = [[String:JSONDecoder]]()
    var fiveArr = [[String:JSONDecoder]]()
    var sixArr = [[String:JSONDecoder]]()
    var sevenArr = [[String:JSONDecoder]]()

    var arr = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GETData()
        //  刷新
//        tableView.registerClass(ClassScheduleTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func GETData(){
        //        http://wxt.xiaocool.net/index.php?g=apps&m=index&a=GetChange_sta_wei&stuid=599
        //        http://wxt.xiaocool.net/index.php?g=apps&m=index&a=RecordWeight&stuid=599&weight=40
        let defalutid = NSUserDefaults.standardUserDefaults()
        let uid = defalutid.stringForKey("classid")
        let schoolid = defalutid.stringForKey("schoolid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=school&a=ClassSyllabus"
        let param = [
                "schoolid":schoolid,
                "classid":uid
            ]

        Alamofire.request(.GET, url, parameters: param as? [String:String]).response { request, response, json, error in
            if(error != nil){
            }
            else{
                print("request是")
                print(request!)
                print("====================")
                //  进行数据解析
                let status = BabyClassModel(JSONDecoder(json!))
                print("状态是")
                print(status.status)
                if(status.status == "error"){
                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.mode = MBProgressHUDMode.Text;
                    hud.labelText = status.errorData
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                
                if(status.status == "success"){
                    print("Success")

                    self.oneArr = (status.data?.mon)!
                    self.twoArr = (status.data?.tu)!
                    self.threeArr = (status.data?.we)!
                    self.fourArr = (status.data?.th)!
                    self.fiveArr = (status.data?.fri)!
                    self.sixArr = (status.data?.sat)!
                    self.sevenArr = (status.data?.sun)!
                    self.tableSource.reloadData()
                    
                }
                
            }
            
        }
        
    }

//    分区数
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 7
        
    }
//    每个分区的cell数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.oneArr.count
        }else if section == 1{
            return self.twoArr.count
        }else if section == 2{
            return self.threeArr.count
        }else if section == 3{
            return self.fourArr.count
        }else if section == 4{
            return self.fiveArr.count
        }else if section == 5{
            return self.sixArr.count
        }else {
            return self.sevenArr.count
        }
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
//    单元格
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier:String(indexPath.row))
        cell.selectionStyle = .None
        tableView.separatorStyle = .None
        
        let oneLable = UILabel()
        oneLable.frame = CGRectMake(10, 10, WIDTH - 20, 40)
        cell.contentView.addSubview(oneLable)
        if indexPath.section == 0 {
            
            if self.oneArr.count > 0 {
                oneLable.text = self.oneArr[indexPath.row][String(indexPath.row+1)]!.string ?? ""
                print("oneLabel.text == \(oneLable.text)")
            }
        }else if indexPath.section == 1{
            if self.twoArr.count > 0 {
                oneLable.text = self.twoArr[indexPath.row][String(indexPath.row+1)]!.string ?? ""
                print("oneLabel.text == \(oneLable.text)")
            }
        }else if indexPath.section == 2{
            if self.threeArr.count > 0 {
                oneLable.text = self.threeArr[indexPath.row][String(indexPath.row+1)]!.string ?? ""
                print("oneLabel.text == \(oneLable.text)")
            }
        }else if indexPath.section == 3{
            if self.fourArr.count > 0 {
                oneLable.text = self.fourArr[indexPath.row][String(indexPath.row+1)]!.string ?? ""
                print("oneLabel.text == \(oneLable.text)")
            }
        }else if indexPath.section == 4{
            if self.fiveArr.count > 0 {
                oneLable.text = self.fiveArr[indexPath.row][String(indexPath.row+1)]!.string ?? ""
                print("oneLabel.text == \(oneLable.text)")
            }
        }else if indexPath.section == 5{
            if self.sixArr.count > 0 {
                oneLable.text = self.sixArr[indexPath.row][String(indexPath.row+1)]!.string ?? ""
                print("oneLabel.text == \(oneLable.text)")
            }
        }else{
            if self.sevenArr.count > 0 {
                oneLable.text = self.sevenArr[indexPath.row][String(indexPath.row+1)]!.string ?? ""
                print("oneLabel.text == \(oneLable.text)")
            }
        }
        
        let line = UILabel()
        line.frame = CGRectMake(0, 59.5, WIDTH, 0.5)
        line.backgroundColor = UIColor.lightGrayColor()
        cell.contentView.addSubview(line)
        
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UILabel()
        view.backgroundColor = UIColor(red: 155/255, green: 229/255, blue: 180/255, alpha: 1)
        view.frame = CGRectMake(0, 10, WIDTH, 40)
        let array:Array<String> = ["星期一","星期二","星期三","星期四","星期五","星期六","星期日"]
        view.text = array[section]
        return view
    }
    
    

}
