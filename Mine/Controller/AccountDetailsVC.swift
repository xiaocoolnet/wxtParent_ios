//
//  AccountDetailsVC.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/12.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class AccountDetailsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var tableView = UITableView()
    var cell = UITableViewCell()

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        createTableView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
//  MARK: - initUI
    func initUI(){
        self.title = "账户明细"
        self.tabBarController?.tabBar.hidden = true
        self.view.backgroundColor = RGBA(239, g: 239, b: 244, a: 1)
    }
    func createTableView(){
        tableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
    }
//  MARK: - UITableViewDelegate,UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            return 3
        }
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 6.0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 60
        }else{
            return 80
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        self.cell = cell
        cell.selectionStyle = .None
        if indexPath.section == 0 {
            //  添加两个 按钮
            dateButton("开始日期", frame: CGRectMake(10, 6, (WIDTH - 30) / 2.0, 48))
            dateButton("结束日期", frame: CGRectMake(WIDTH / 2.0 + 5, 6, WIDTH / 2.0 - 15, 48))
        }else{
            cell.textLabel?.text = "第二学期学费 ¥350.00"
        }
        return cell
    }
    //  添加按钮
    func dateButton(date:String,frame:CGRect){
        let button = UIButton()
        button.frame = frame
        button.backgroundColor = UIColor.lightGrayColor()
        button.setTitle(date, forState: .Normal)
        button.addTarget(self, action: #selector(getDate), forControlEvents: .TouchUpInside)
        cell.contentView.addSubview(button)
    }
    func getDate(){
        print("得到时间")
    }


}
