//
//  HomeworkViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/4/27.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import XWSwiftRefresh

class HomeworkViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    let table = UITableView()
    var homeworkSource = HomeworkList()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createTable()
        self.DropDownUpdate()
    }
    //    开始刷新
    func DropDownUpdate(){
        self.table.headerView = XWRefreshNormalHeader(target: self, action: #selector(ParentsExhortViewController.loadData))
        self.table.reloadData()
        self.table.headerView?.beginRefreshing()
    }
//    创建表
    func createTable(){
        table.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .None
        self.view.addSubview(table)
        
        table.registerNib(UINib.init(nibName: "HomeworkTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeworkCellID")
    }
    func loadData(){
//        http://wxt.xiaocool.net/index.php?g=apps&m=teacher&a=gethomeworklist&userid=597&classid=1
       
        //下面两句代码是从缓存中取出userid（入参）值
        let defalutid = NSUserDefaults.standardUserDefaults()
        let uid = defalutid.stringForKey("userid")
        let classid = defalutid.stringForKey("classid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=teacher&a=gethomeworklist"
        let param = [
            "userid":uid!,
            "classid":classid!
        ]
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
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
                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.mode = MBProgressHUDMode.Text
                    hud.labelText = status.errorData
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                if(status.status == "success"){
                    self.homeworkSource = HomeworkList(status.data!)
                    self.table.reloadData()
                    self.table.headerView?.endRefreshing()
                }
            }
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeworkSource.count
    }
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 301
//    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeworkCellID", forIndexPath: indexPath)
            as! HomeworkTableViewCell
        cell.selectionStyle = .None
        let newsInfo = self.homeworkSource.homeworkList[indexPath.row]
        let dateformate = NSDateFormatter()
        dateformate.dateFormat = "yyyy-MM-dd HH:mm"
        
        cell.titleLbl.text = newsInfo.title
        cell.contentLbl.text = newsInfo.content

        let imgUrl = imageUrl + newsInfo.photo!
        let photourl = NSURL(string: imgUrl)
        cell.bigImageView.yy_setImageWithURL(photourl, placeholder: UIImage(named: "园所公告背景.png"))
        cell.senderLbl.text = newsInfo.username
        cell.readLbl.text = "已读\(String(newsInfo.readcount!))"
        cell.unreadLbl.text = "未读\(String(newsInfo.allreader!-newsInfo.readcount!))"
        let date = NSDate(timeIntervalSince1970: NSTimeInterval(newsInfo.create_time!)!)
        let str:String = dateformate.stringFromDate(date)
        cell.timeLbl.text = str
        
//        自适应行高
        let options : NSStringDrawingOptions = NSStringDrawingOptions.UsesLineFragmentOrigin
        let screenBounds:CGRect = UIScreen.mainScreen().bounds
        let boundingRect = String(cell.contentLbl.text).boundingRectWithSize(CGSizeMake(screenBounds.width, 0), options: options, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(17)], context: nil)
        table.rowHeight = boundingRect.size.height + 281
        return cell
    }
}
