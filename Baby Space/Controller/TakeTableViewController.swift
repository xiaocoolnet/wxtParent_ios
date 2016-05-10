//
//  TakeTableViewController.swift
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

class TakeTableViewController: UITableViewController {

    @IBOutlet var tableSource: UITableView!
    var takeSource = TakeListModel()
    var id = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.DropDownUpdate()

    }
    //    开始刷新
    func DropDownUpdate(){
        self.tableSource.headerView = XWRefreshNormalHeader(target: self, action: #selector(TakeTableViewController.loadData))
        self.tableSource.reloadData()
        self.tableSource.headerView?.beginRefreshing()
    }
    func loadData(){
        // http://wxt.xiaocool.net/index.php?g=apps&m=student&a=getcollectconfirmation&userid=28
        //下面两句代码是从缓存中取出userid（入参）值
        let defalutid = NSUserDefaults.standardUserDefaults()
        let userid = defalutid.stringForKey("userid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=gettransportconfirmation"
        let param = [
            "userid":userid!
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
                    self.takeSource = TakeListModel(status.data!)
                    self.tableSource.reloadData()
                    self.tableSource.headerView?.endRefreshing()
                }
            }
        }
    }
//    行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.takeSource.count
    }
//    单元格
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TakeCell", forIndexPath: indexPath) as!TakeTableViewCell
        cell.selectionStyle = .None
        let takeInfo = self.takeSource.takeList[indexPath.row]
        let dateformate = NSDateFormatter()
        dateformate.dateFormat = "yyyy-MM-dd HH:mm"
        cell.nameLbl.text = takeInfo.teachername
        let date = NSDate(timeIntervalSince1970: NSTimeInterval(takeInfo.delivery_time!)!)
        let str:String = dateformate.stringFromDate(date)
        cell.timeLbl.text = str
        let imgUrl = imageUrl + takeInfo.photo!
        let photourl = NSURL(string: imgUrl)
        cell.bigImageView.yy_setImageWithURL(photourl, placeholder: UIImage(named: "无网络的背景.png"))
        let imgUrl1 = imageUrl + takeInfo.teacheravatar!
        let headImageurl = NSURL(string: imgUrl1)
        cell.bigImageView.yy_setImageWithURL(headImageurl, placeholder: UIImage(named: "Logo.png"))
        cell.phoneBtn.addTarget(self, action: #selector(TakeTableViewController.callNumber(_:)), forControlEvents: .TouchUpInside)
        cell.phoneBtn.tag = Int(takeInfo.teacherphone!)!
        cell.agreeBtn.addTarget(self, action: #selector(TakeTableViewController.agreePress(_:)), forControlEvents: .TouchUpInside)
        cell.agreeBtn.tag = indexPath.row
        cell.disagreeBtn.addTarget(self, action: #selector(TakeTableViewController.disagreePress(_:)), forControlEvents: .TouchUpInside)
        cell.disagreeBtn.tag = indexPath.row
        tableSource.rowHeight = 351
        return cell
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        return 1.0
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5.0
    }
    //    打电话
    func callNumber(sender:AnyObject){
        let btn:UIButton = sender as! UIButton
        var phone = String()
        phone = "telprompt:\(String(btn.tag))"
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
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=confirmtransport"
        let param = [
            "transportid":takeInfo.id!,
            "parentid":takeInfo.parentid!,
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
                   self.DropDownUpdate()
                }
            }
        }
    }
}
