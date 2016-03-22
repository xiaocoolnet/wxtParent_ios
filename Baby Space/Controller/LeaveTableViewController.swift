//
//  LeaveTableViewController.swift
//  WXT_Parents
//
//  Created by 牛尧 on 16/2/24.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class LeaveTableViewController: UITableViewController,UISearchBarDelegate{

    override func viewDidLoad() {
        
        super.viewDidLoad()
       }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         //return 4
        if(section == 0){
            return 3
        }
        if(section == 1){
            return 1
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String{
        
        if (section == 0)
        {
            return "周一"
        }
        else if (section == 1)
        {
            return  "评论区"
        }
        return "WQE"
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("LeaveCell", forIndexPath: indexPath) as! LeaveTableViewCell
        cell.LeaveLabel.text = "接收人"
        return cell
    }

}
