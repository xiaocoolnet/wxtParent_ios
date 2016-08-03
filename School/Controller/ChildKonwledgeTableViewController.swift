//
//  ChildKonwledgeTableViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/6/4.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import XWSwiftRefresh

//  需要进行数据加载

class ChildKonwledgeTableViewController: UITableViewController {
    @IBOutlet var table: UITableView!
    
    var dataSource = YuErList()

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
//        DropDownUpdate()
        GETData()

    
    }
    
    func initUI(){
        self.title = "育儿知识"
        self.tabBarController?.tabBar.hidden = true
        self.table.rowHeight = 110
        self.table.backgroundColor = RGBA(239, g: 239, b: 244, a: 1)
    }
    func DropDownUpdate(){
        self.table.headerView = XWRefreshNormalHeader(target: self, action: #selector(TakeTableViewController.loadData))
        self.table.reloadData()
        self.table.headerView?.beginRefreshing()
    }
    
    func GETData(){
//        蒋庆超
//        http://wxt.xiaocool.net/index.php?g=apps&m=index&a=ParentingKnowledge&schoolid=1
//        我
//        http://wxt.xiaocool.net/index.php?g=apps&m=school&a=getParentsThings&schoolid=1
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let schoolid = userDefaults.valueForKey("schoolid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=index&a=ParentingKnowledge"
        let param = ["schoolid":schoolid!]
        Alamofire.request(.GET, url, parameters: param ).response{request, response, json, error in
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
                    //  得到数据源
                    self.dataSource = YuErList(status.data!)
                    self.table.reloadData()
                    //  停止刷新
                    self.table.headerView?.endRefreshing()
                }
            }
            
        }
    
        
    }

//    行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
//    单元格
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChildKonwledgeCell", forIndexPath: indexPath) as! ChildKonwledgeTableViewCell
        cell.selectionStyle = .None
        let model = self.dataSource.objectList[indexPath.row]
        cell.contentLbl.text = model.happy_content!
//        cell.timeLbl.text = model.happy_time!
        
        //  转时间戳
        let mondayInterval:NSTimeInterval = NSTimeInterval(model.happy_time!)!
        let mondayDate = NSDate(timeIntervalSince1970: mondayInterval)
        
        //格式话输出
        let dformatter = NSDateFormatter()
        //        dformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dformatter.dateFormat = "MM-dd HH:mm"
        
        cell.timeLbl.text = dformatter.stringFromDate(mondayDate)
        
        
        cell.titleLbl.text = model.happy_title!
        cell.bigImageView.sd_setImageWithURL(NSURL.init(string: (imageUrl+model.happy_pic!)), placeholderImage: UIImage.init(named: "1"))

        return cell
    }
//    阅读全文
    func readAll(btn:UIButton){
        let vc = CKReadAllViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}
