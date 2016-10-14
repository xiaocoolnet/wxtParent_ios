
//
//  QCNotTokenCompleteVC.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/21.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import UIKit
import Alamofire
import YYWebImage
import XWSwiftRefresh
import MBProgressHUD

class QCNotTokenCompleteVC: UITableViewController {
    
    
    
    var takeSource = TakeListModel()
    var id = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        self.tableView.registerClass(QCTakeBabyCell.self, forCellReuseIdentifier: "TakeCell")
        //        let cellNib = UINib(nibName: "TakeTableViewCell", bundle: nil)
        //        tableView.registerNib(cellNib, forCellReuseIdentifier: "TakeCell")
//        self.DropDownUpdate()
        
    }
    func initUI(){
        self.tabBarController?.tabBar.hidden = true
    }
    //    开始刷新
    func DropDownUpdate(){
        self.tableView.headerView = XWRefreshNormalHeader(target: self, action: #selector(TakeTableViewController.loadData))
        self.tableView.reloadData()
        self.tableView.headerView?.beginRefreshing()
        let view = UIView()
        tableView.tableFooterView = view
    }
    //    加载数据
    func loadData(){
        
        //  http://wxt.xiaocool.net/index.php?g=apps&m=student&a=gettransportconfirmation&studentid=597
        //下面两句代码是从缓存中取出userid（入参）值
        let defalutid = NSUserDefaults.standardUserDefaults()
        let studentid = defalutid.stringForKey("chid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=gettransportconfirmation"
        let param = [
            "studentid":studentid
        ]
        Alamofire.request(.GET, url, parameters: param as? [String:String]).response { request, response, json, error in
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
                    self.takeSource = TakeListModel(status.data!)
                    self.tableView.reloadData()
                    self.tableView.headerView?.endRefreshing()
                }
            }
        }
    }
    //    行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.takeSource.count
    }
    //    单元格
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCellWithIdentifier("TakeCell", forIndexPath: indexPath) as!TakeTableViewCell
        let cell = tableView.dequeueReusableCellWithIdentifier("TakeCell", forIndexPath: indexPath) as? QCTakeBabyCell
        //        cell.textLabel?.text = "1"
        cell!.selectionStyle = .None
        
        //        赋值
        let takeInfo = self.takeSource.takeList[indexPath.row]
        //        时间戳转换
        let dateformate = NSDateFormatter()
        dateformate.dateFormat = "yyyy-MM-dd HH:mm"
        let date = NSDate(timeIntervalSince1970: NSTimeInterval(takeInfo.delivery_time!)!)
        let str:String = dateformate.stringFromDate(date)
        cell?.timeLabel.text = str
        
        cell?.nameLabel.text = takeInfo.teachername
        
        //        图片
        let imgUrl = microblogImageUrl + takeInfo.photo!
        let photourl = NSURL(string: imgUrl)
        cell!.bigImageView.yy_setImageWithURL(photourl, placeholder: UIImage(named: "无网络的背景.png"))
        //        头像
        let imgUrl1 = microblogImageUrl + takeInfo.teacheravatar!
        let headImageurl = NSURL(string: imgUrl1)
        cell!.headImageView.yy_setImageWithURL(headImageurl, placeholder: UIImage(named: "默认头像"))
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let someOne = userDefaults.valueForKey("name")
        cell!.somebodyLabel.text = (someOne as? String)! + "家长，这个人可以接走孩子么？"
        //        同意按钮
        cell!.agreeBtn.addTarget(self, action: #selector(TakeTableViewController.agreePress(_:)), forControlEvents: .TouchUpInside)
        cell!.agreeBtn.tag = indexPath.row
        //        不同意按钮
        cell!.disagreeBtn.addTarget(self, action: #selector(TakeTableViewController.disagreePress(_:)), forControlEvents: .TouchUpInside)
        cell!.disagreeBtn.tag = indexPath.row
        //  cell 的高度
        tableView.rowHeight = 450
        return cell!
    }
    ////    分区组的头
    //    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
    //        return 1.0
    //    }
    ////    分区组的底
    //    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    //        return 5.0
    //    }
    //    打电话
    func callNumber(sender:AnyObject){
        let takeInfo = self.takeSource.takeList[sender.tag]
        var phone = String()
        phone = "telprompt:\(takeInfo.teacherphone!)"
        print(phone)
        UIApplication.sharedApplication().openURL(NSURL.init(string: phone)!)
    }
    //    同意
    func agreePress(sender:AnyObject){
        let btn:UIButton = sender as! UIButton
        self.confirmTransport(btn.tag,status: 1)
    }
    //    不同意
    func disagreePress(sender:AnyObject){
        let btn:UIButton = sender as! UIButton
        self.confirmTransport(btn.tag,status: 2)
    }
    //    同意是否接送
    func confirmTransport(row:Int,status:Int){
        //        http://wxt.xiaocool.net/index.php?g=apps&m=student&a=confirmtransport&transportid=1&parentid=122&status=1
        let takeInfo = self.takeSource.takeList[row]
        //下面两句代码是从缓存中取出userid（入参）值
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let parentid = userDefaults.valueForKey("userid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=confirmtransport"
        let param = [
            "transportid":takeInfo.id!,
            //            "parentid":takeInfo.parentid!,
            "parentid":parentid,
            "status":status
        ]
        Alamofire.request(.GET, url, parameters: param as? [String : AnyObject]).response { request, response, json, error in
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
                    let alert = UIAlertController(title: "提示", message: "已发送", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    self.DropDownUpdate()
                    
                }
            }
        }
    }
}