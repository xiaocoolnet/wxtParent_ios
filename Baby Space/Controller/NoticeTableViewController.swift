//
//  NoticeTableViewController.swift
//  WXT_Parents
//
//  Created by 牛尧 on 16/2/24.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import YYWebImage
import XWSwiftRefresh
import MBProgressHUD

class NoticeTableViewController: UITableViewController {
    
    @IBOutlet var tableSource: UITableView!
    var noticeSource = NoticeList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.DropDownUpdate()

    }
    //    开始刷新
    func DropDownUpdate(){
        self.tableSource.headerView = XWRefreshNormalHeader(target: self, action: #selector(NoticeTableViewController.loadData))
        self.tableSource.reloadData()
        self.tableSource.headerView?.beginRefreshing()
    }
    func loadData(){
//        http://wxt.xiaocool.net/index.php?g=apps&m=school&a=getnoticelist&userid=597&classid=1&schoolid=1
        //下面两句代码是从缓存中取出userid（入参）值
        let defalutid = NSUserDefaults.standardUserDefaults()
        let sid = defalutid.stringForKey("schoolid")
        let userid = defalutid.stringForKey("userid")
        let classid = defalutid.stringForKey("classid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=school&a=getnoticelist"
        let param = [
            "userid":userid!,
            "classid":classid!,
            "schoolid":sid!
            
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
                    self.noticeSource = NoticeList(status.data!)
                    self.tableSource.reloadData()
                    self.tableSource.headerView?.endRefreshing()
                }
            }
        }
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return noticeSource.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NoticeCell", forIndexPath: indexPath) as!NoticeTableViewCell
        cell.selectionStyle = .None
        let noticeInfo = self.noticeSource.objectlist[indexPath.row]
        let dateformate = NSDateFormatter()
        dateformate.dateFormat = "yyyy-MM-dd HH:mm"
        
        cell.titleLbl.text = noticeInfo.title
        cell.contentLbl.text = noticeInfo.content
        let imgUrl = imageUrl + noticeInfo.photo!
        let photourl = NSURL(string: imgUrl)
        cell.bigImageView.yy_setImageWithURL(photourl, placeholder: UIImage(named: "园所公告背景.png"))
        cell.senderLbl.text = noticeInfo.username
        cell.readLbl.text = "已读\(String(noticeInfo.readcount!))"
        cell.unreadLbl.text = "未读\(String(noticeInfo.allreader!-noticeInfo.readcount!))"
        let date = NSDate(timeIntervalSince1970: NSTimeInterval(noticeInfo.create_time!)!)
        let str:String = dateformate.stringFromDate(date)
        cell.timeLbl.text = str
//        自适应行高
        let options : NSStringDrawingOptions = NSStringDrawingOptions.UsesLineFragmentOrigin
        let screenBounds:CGRect = UIScreen.mainScreen().bounds
        let boundingRect = String(cell.contentLbl.text).boundingRectWithSize(CGSizeMake(screenBounds.width, 0), options: options, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(17)], context: nil)
        tableSource.rowHeight = boundingRect.size.height + 261
        return cell
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 0.01
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5.0
    }

}
