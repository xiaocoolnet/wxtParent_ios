//
//  YuanNoticeTableViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/6/4.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import YYWebImage
import XWSwiftRefresh
import MBProgressHUD

class YuanNoticeTableViewController: UITableViewController {

    
    @IBOutlet var tableSource: UITableView!
    var noticeSource = NoticeList()
    var dianzanSource = DianZanList()
    var commentSource = NCommentList()
    let arrayPeople = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.DropDownUpdate()
    }

    //    开始刷新
    func DropDownUpdate(){
        self.tableSource.headerView = XWRefreshNormalHeader(target: self, action: #selector(YuanNoticeTableViewController.loadData))
        self.tableSource.reloadData()
        self.tableSource.headerView?.beginRefreshing()
    }
//    加载数据
    func loadData(){
        //        http://wxt.xiaocool.net/index.php?g=apps&m=school&a=getnoticelist&userid=597&classid=1&schoolid=1
        //下面两句代码是从缓存中取出userid（入参）值
        let defalutid = NSUserDefaults.standardUserDefaults()
        let sid = defalutid.stringForKey("schoolid")
        let userid = defalutid.stringForKey("userid")
       
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=school&a=getnoticelist"
        let param = [
            "userid":userid!,
            "classid":"1",
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
//    行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.noticeSource.count
    }
//    单元格
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("YuanNoticeCell", forIndexPath: indexPath) as! YuanNoticeTableViewCell
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

        cell.dianzanBtn.addTarget(self, action: #selector(YuanNoticeTableViewController.dianZan(_:)), forControlEvents: .TouchUpInside)
        cell.dianzanBtn.setBackgroundImage(UIImage(named: "已点赞"), forState: .Selected)
        cell.dianzanBtn.tag = indexPath.row
        cell.pinglunBtn.addTarget(self, action: #selector(YuanNoticeTableViewController.pingLun(_:)), forControlEvents: .TouchUpInside)
        cell.pinglunBtn.tag = indexPath.row

        let date = NSDate(timeIntervalSince1970: NSTimeInterval(noticeInfo.create_time!)!)
        let str:String = dateformate.stringFromDate(date)
        cell.timeLbl.text = str
        
        //        判断是有人点赞
        self.dianzanSource = DianZanList(noticeInfo.dianzanlist!)
        if self.dianzanSource.count == 0 {
            cell.zanListLbl.text = "0人点赞"
            cell.dianzanBtn.selected = false
            cell.dianzanBtn.setBackgroundImage(UIImage(named: "点赞"), forState: .Normal)
        }else{
            //                先清空
            arrayPeople.removeAllObjects()
            //循环遍历点赞数量，对比是否自己点过赞
            for i in 0..<dianzanSource.count{
                let dianzanInfo = self.dianzanSource.dianzanlist[i]
                //如果点过赞，则显示点赞图标
                let userid = NSUserDefaults.standardUserDefaults()
                let uid = userid.stringForKey("userid")
                if(dianzanInfo.dianZanId == uid){
                    cell.dianzanBtn.selected = true
                    cell.dianzanBtn.setBackgroundImage(UIImage(named: "已点赞"), forState:.Normal)
                }else{//如果没点过赞，显示灰色图标
                    cell.dianzanBtn.selected = false
                    cell.dianzanBtn.setBackgroundImage(UIImage(named: "点赞"), forState: .Normal)
                }
            }
            if dianzanSource.count>4{
                for i in 0..<4{
                    let dianzanInfo = self.dianzanSource.dianzanlist[i]
                    arrayPeople.addObject(dianzanInfo.dianZanName!)
                    let peopleArray = arrayPeople.componentsJoinedByString(",")
                    cell.zanListLbl.text = "\(peopleArray)等\(dianzanSource.count)人觉得很赞"
                }
            }else{
                for i in 0..<dianzanSource.count{
                    let dianzanInfo = self.dianzanSource.dianzanlist[i]
                    arrayPeople.addObject(dianzanInfo.dianZanName!)
                    let peopleArray = arrayPeople.componentsJoinedByString(",")
                    cell.zanListLbl.text = "\(peopleArray)等\(dianzanSource.count)人觉得很赞"
                }
            }
        }
        
        //        自适应行高
        let options : NSStringDrawingOptions = NSStringDrawingOptions.UsesLineFragmentOrigin
        let screenBounds:CGRect = UIScreen.mainScreen().bounds
        let boundingRect = String(cell.contentLbl.text).boundingRectWithSize(CGSizeMake(screenBounds.width, 0), options: options, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(17)], context: nil)
        tableSource.rowHeight = boundingRect.size.height + 351
        return cell
    }
//    点赞
    func dianZan(sender:UIButton){
        let btn:UIButton = sender
        let noticeInfo = self.noticeSource.objectlist[btn.tag]
        if btn.selected {
            btn.selected = false
            self.xuXiaoDianZan(noticeInfo.id!)
        }else{
            btn.selected = true
            self.getDianZan(noticeInfo.id!)
        }
        
    }
    //    去点赞
    func getDianZan(id:String){
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=school&a=SetLike"
        let userid = NSUserDefaults.standardUserDefaults()
        let uid = userid.stringForKey("userid")
        let param = [
            "id":id,
            "userid":uid!,
            "type":3
        ]
        Alamofire.request(.GET, url, parameters: param as? [String : AnyObject]).response { request, response, json, error in
            if(error != nil){
            }
            else{
                print("request是")
                print(request!)
                print("====================")
                let status = MineModel(JSONDecoder(json!))
                print("状态是")
                print(status.status)
                if(status.status == "error"){
                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.mode = MBProgressHUDMode.Text;
                    hud.labelText = status.errorData
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                
                if(status.status == "success"){
                    //self.dianZanBtn.selected == true
                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.mode = MBProgressHUDMode.Text;
                    hud.labelText = "点赞成功"
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                    self.loadData()
                }
                
            }
            
        }
        
    }
    //    取消点赞
    func xuXiaoDianZan(id:String){
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=school&a=ResetLike"
        let userid = NSUserDefaults.standardUserDefaults()
        let uid = userid.stringForKey("userid")
        let param = [
            "id":id,
            "userid":uid!,
            "type":3
        ]
        Alamofire.request(.GET, url, parameters: param as? [String : AnyObject]).response { request, response, json, error in
            if(error != nil){
            }
            else{
                print("request是")
                print(request!)
                print("====================")
                let status = MineModel(JSONDecoder(json!))
                print("状态是")
                print(status.status)
                if(status.status == "error"){
                    
                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.mode = MBProgressHUDMode.Text;
                    hud.labelText = status.errorData
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                
                if(status.status == "success"){
                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.mode = MBProgressHUDMode.Text;
                    hud.labelText = "取消点赞"
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                    self.loadData()
                }
                
            }
            
        }
    }
//    评论
    func pingLun(sender:UIButton){
        let btn:UIButton = sender
        let noticeInfo = self.noticeSource.objectlist[btn.tag]
        self.commentSource = NCommentList(noticeInfo.comment!)
        let vc = YNPLViewController()
        vc.id = String(noticeInfo.id!)
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
