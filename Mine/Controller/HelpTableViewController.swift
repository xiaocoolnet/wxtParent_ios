//
//  HelpTableViewController.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/2/16.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class HelpTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("HelpTableViewController")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}
