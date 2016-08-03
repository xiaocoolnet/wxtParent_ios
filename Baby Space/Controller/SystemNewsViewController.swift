//
//  SystemNewsViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/6/3.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit


class SystemNewsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    var table = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "系统消息"
        self.creteaTable()
    }
//    创建表
    func creteaTable(){
       table = UITableView(frame: CGRectMake(0, 0, WIDTH, HEIGHT-64))
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 90
        table.backgroundColor = RGBA(242.0, g: 242.0, b: 242.0, a: 1)
        self.view.addSubview(table)
//        注册cell
        table.registerNib(UINib.init(nibName: "SystemNewsTableViewCell", bundle: nil), forCellReuseIdentifier: "SystemNewsCell")
    }
//    行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
//    单元格
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SystemNewsCell", forIndexPath: indexPath) as! SystemNewsTableViewCell
        return cell
    }

}
