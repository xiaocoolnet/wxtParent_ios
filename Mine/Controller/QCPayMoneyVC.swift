//
//  QCPayMoneyVC.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/12.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class QCPayMoneyVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var tableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        createTableView()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func initUI(){
        self.title = "支付费用"
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
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.selectionStyle = .None

            cell.textLabel?.text = "第二学期学费 ¥350.00"

        return cell
    }

    


}
