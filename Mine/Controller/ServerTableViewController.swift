//
//  ServerTableViewController.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/2/16.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//


import UIKit

class ServerTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       self.title = "客服"
        
    }

    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let forFooterView = UIView(frame: CGRectMake(0, self.view.frame.size.width-49, self.view.frame.size.height, 49))
        let footerBt = UIButton(frame: CGRectMake(0, 0, self.view.frame.size.width, 49))
        forFooterView.addSubview(footerBt)
        
        footerBt.setTitle("拨打电话", forState: UIControlState.Normal)
        footerBt.backgroundColor = UIColor(red: 155.0/255.0, green: 229.0/255.0, blue: 180.0/255.0, alpha: 1.0)
        footerBt.addTarget(self, action:#selector(ServerTableViewController.call(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        return forFooterView
    }
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 49
    }
    func call(sender:UIButton){
        let url1 = NSURL(string: "tel://4009660095")
        UIApplication.sharedApplication().openURL(url1!)
    }

}
