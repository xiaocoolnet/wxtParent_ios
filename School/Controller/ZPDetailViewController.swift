//
//  ZPDetailViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/6/2.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class ZPDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let table = UITableView()
    var jobInfo:JobInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "招聘内容"
        self.createTable()
    }
//    创建表
    func createTable(){
        table.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-50)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .None
        table.backgroundColor = RGBA(242.0, g: 242.0, b: 242.0, a: 1)
        self.view.addSubview(table)
        
        table.registerNib(UINib.init(nibName: "ZPDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "ZPCell")
        
//        创建底部
        let btn = UIButton(frame: CGRectMake(0,HEIGHT-50-64,WIDTH,50))
        btn.backgroundColor = UIColor(red: 155.0 / 255.0, green: 229.0 / 255.0, blue: 180.0 / 255.0, alpha: 1.0)
        btn.setTitle("联系我们", forState: .Normal)
        btn.addTarget(self, action: #selector(ZPDetailViewController.contactWe), forControlEvents: .TouchUpInside)
        self.view.addSubview(btn)
    }
//    联系我们
    func contactWe(){
       print("联系我们")
    }
//    分区数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
//    行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  1
    }
//    单元格
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ZPCell", forIndexPath: indexPath) as! ZPDetailTableViewCell
        cell.selectionStyle = .None
        cell.updateCellWithJobInfo(self.jobInfo!)
        cell.detailBtn.addTarget(self, action: #selector(ZPDetailViewController.next), forControlEvents: .TouchUpInside)
        return cell
    }
//    行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //        自适应行高
        let options : NSStringDrawingOptions = NSStringDrawingOptions.UsesLineFragmentOrigin
        let screenBounds:CGRect = UIScreen.mainScreen().bounds
        let boundingRect = String(self.jobInfo?.post_content).boundingRectWithSize(CGSizeMake(screenBounds.width, 0), options: options, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(17)], context: nil)
        let boundingRect1 = String(self.jobInfo?.post_content).boundingRectWithSize(CGSizeMake(screenBounds.width, 0), options: options, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(17)], context: nil)
        return boundingRect.size.height + boundingRect1.size.height + 280
    }
//    学校简介
    func next(){
        let vc = PlaceDetailViewController()
        vc.jobInfo = self.jobInfo!
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
