//
//  DaKaViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/5/28.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire

class DaKaViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate {

    var table = UITableView()
//    已签到的数组
    let signArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        
        

        self.tabBarController?.tabBar.hidden = true
        self.createTable()
//        签到的日历表
        let calendarView = HYCalendarView()
        calendarView.frame = CGRectMake(10, 30, WIDTH-20, 200)
        self.table.tableHeaderView = calendarView
        //设置已经签到的天数日期
        calendarView.signArray = self.signArray
//        获取当天的日期
        calendarView.date = NSDate()
        let comp:NSDateComponents = NSCalendar.currentCalendar().components(NSCalendarUnit(arrayLiteral: .Year,.Month,.Day), fromDate: NSDate())
        //日期点击事件
        calendarView.calendarBlock = {(day:NSInteger,month:NSInteger,year:NSInteger)in
//            判断是否是今天的日期
            if comp.day == day {
                print("\(year)-\(month)-\(day)")
            }
        }
    }
    func GETDaKaData(){
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        
        
    }
    func initUI(){
//        let alertView = UIAlertView(title: "提示信息", message: "您的宝贝今天还未签到，是否进行补签？", delegate: self, cancelButtonTitle: "确定")
        
        let alertView = UIAlertView()
        alertView.title = "提示信息"
        alertView.message = "您的宝贝今天还未签到，是否进行补签？"
        alertView.addButtonWithTitle("取消")
        alertView.addButtonWithTitle("确定")
        alertView.cancelButtonIndex=0
        alertView.delegate=self;
        alertView.show()
    }
    func alertView(alertView:UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        if(buttonIndex==alertView.cancelButtonIndex){
            print("点击了取消")
        }
        else
        {
            print("点击了确认")
            //   进行补签
            let userDefaults = NSUserDefaults.standardUserDefaults()
            let stuid = userDefaults.valueForKey("chid")
            print(stuid)
            let url = "http://wxt.xiaocool.net/index.php?g=apps&m=index&a=Sign"
            let pmara = ["stuid":stuid]
            //  进行请求
            GETData(url, pmara: (pmara as? [String:AnyObject])!)
            
        }
    }
    func GETData(url:String,pmara:NSDictionary){
        
        
        Alamofire.request(.GET, url, parameters: pmara as? [String : AnyObject]).response { request, response, json, error in
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
                    
                    messageHUD(self.view, messageData: status.errorData!)
                    
                }
                if(status.status == "success"){
                    
                    messageHUD(self.view, messageData: "添加成功")
                    
                }
            }
        }

    }
//    创建表
    func createTable(){
        table = UITableView(frame: CGRectMake(0, 0, WIDTH, HEIGHT-10))
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .None//分割线
        table.rowHeight = 101
        self.view.addSubview(table)
//        注册cell
        table.registerNib(UINib.init(nibName: "DaKaTableViewCell", bundle: nil), forCellReuseIdentifier: "DaKaCell")
    }
//    分区数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
//    分区头的高度
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
//    分区组的标题
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "5月30日"
        }
        if section == 1{
            return "5月29日"
        }
        if section == 2{
            return "5月28日"
        }
        return ""
    }
//    每个分区的cell数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
//    单元格
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DaKaCell") as! DaKaTableViewCell
        cell.selectionStyle = .None
        return cell
    }


}
