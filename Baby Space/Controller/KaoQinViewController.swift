//
//  KaoQinViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/5/12.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class KaoQinViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    var table = UITableView()
    let signArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//      签到日历表
        let calendarView = HYCalendarView()
        calendarView.frame = CGRectMake(10, 30, WIDTH-20, 200)
        self.view.addSubview(calendarView)
        //设置已经签到的天数日期
        calendarView.signArray = self.signArray
        
        calendarView.date = NSDate()

         //日期点击事件
        calendarView.calendarBlock = {(day:NSInteger,month:NSInteger,year:NSInteger)in
            print("\(year)-\(month)-\(day)")
            self.createTable()
        }
    }
//    创建表
    func createTable(){
        table = UITableView(frame: CGRectMake(0, 240, WIDTH, HEIGHT-240-64-49))
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .None
        table.rowHeight = 50
        table.backgroundColor = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1)
        self.view.addSubview(table)
        table.registerNib(UINib.init(nibName: "KaoQinTableViewCell", bundle: nil), forCellReuseIdentifier: "KaoQinCell")
    }
//    分区数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
//    行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
//    单元格
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("KaoQinCell") as! KaoQinTableViewCell
        cell.selectionStyle = .None
        return cell
    }
}
