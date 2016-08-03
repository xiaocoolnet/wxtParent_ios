//
//  GDFriendsViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/6/6.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import XWSwiftRefresh
import MBProgressHUD

class GDFriendsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var tableView = UITableView()
    var noticeSource = QCFirendInfo()
    var dianzanSource = DianZanList()
    var dataSource = QCCommentInfo()
    let arrayPeople = NSMutableArray()
    var cellHight = CGFloat()
    var getHight = CGFloat()
    var id = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createTable()
        self.DropDownUpdate()

        self.loadData()
    }
    
        //    开始刷新
        func DropDownUpdate(){
            self.tableView.headerView = XWRefreshNormalHeader(target: self, action: #selector(YuanNoticeTableViewController.loadData))
            self.tableView.reloadData()
            self.tableView.headerView?.beginRefreshing()
        }
        func loadData(){
            //        http://wxt.xiaocool.net/index.php?g=apps&m=school&a=getnoticelist&userid=597&classid=1&schoolid=1
            //下面两句代码是从缓存中取出userid（入参）值
            let defalutid = NSUserDefaults.standardUserDefaults()
            let sid = defalutid.stringForKey("schoolid")
            let userid = defalutid.stringForKey("userid")
            let classid = defalutid.stringForKey("classid")
            print(sid)
            print(userid)
            print(classid)
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
                        self.noticeSource = QCFirendInfo(status.data!)
                        //  评论列表
                        self.tableView.reloadData()
                        self.tableView.headerView?.endRefreshing()
                    }
                }
            }
        }
    
//    创建表
    func createTable(){
        tableView = UITableView(frame: CGRectMake(0, 0, WIDTH, HEIGHT-HEIGHT/4-64-40-49))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        self.view.addSubview(tableView)
        
        
        tableView.registerClass(QCFirendCell.self, forCellReuseIdentifier: "cell")
        
    }
//    行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.noticeSource.count
    }
////    行高
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        
//        let center = NSNotificationCenter.defaultCenter()
//        center.addObserver(self, selector: #selector(receiveMessage(_:)), name: "得到的高度", object: nil)
//
//        for i in 0...indexPath.row{
//            if self.commentSource.count != 0{
//
//                let height:CGFloat = 80.0 * CGFloat(self.commentSource.count)
//                return self.cellHight + height
//            }else{
//                return self.cellHight
//            }
//        
//
//    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: #selector(receiveMessage(_:)), name: "得到的高度", object: nil)


        return self.cellHight + 3 * 82
    }
    
    func receiveMessage(notifi:NSNotification){
        //  得到消息内容
        self.cellHight = notifi.object as! CGFloat

    }


//    单元格
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! QCFirendCell
        cell.selectionStyle = .None
        cell.backgroundColor = RGBA(239, g: 239, b: 244, a: 1)
        let model = self.noticeSource.objectList[indexPath.row]

        
        cell.fillCellWithModel(model, indexPath: indexPath)
        
//        cell.priseButton.addTarget(self, action: #selector(NoticeTableViewController.dianZan(_:)), forControlEvents: .TouchUpInside)
//        cell.priseButton.setBackgroundImage(UIImage(named: "已点赞.png"), forState:.Selected)
//        cell.priseButton.tag = indexPath.row
//        
//        
//        
//        cell.commentButton.addTarget(self, action: #selector(NoticeTableViewController.pingLun(_:)), forControlEvents: .TouchUpInside)
//        cell.commentButton.tag = indexPath.row
        
        
        //        判断是有人点赞
        self.dianzanSource = DianZanList(model.like!)
        if self.dianzanSource.count == 0 {
            cell.priseLabel.text = "0人点赞"
            cell.priseButton.selected = false
            cell.priseButton.setBackgroundImage(UIImage(named: "点赞"), forState: .Normal)
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
                    cell.priseButton.selected = true
                    cell.priseButton.setBackgroundImage(UIImage(named: "已点赞"), forState:.Normal)
                }else{//如果没点过赞，显示灰色图标
                    cell.priseButton.selected = false
                    cell.priseButton.setBackgroundImage(UIImage(named: "点赞"), forState: .Normal)
                }
            }
            if dianzanSource.count>4{
                for i in 0..<4{
                    let dianzanInfo = self.dianzanSource.dianzanlist[i]
                    arrayPeople.addObject(dianzanInfo.dianZanName!)
                    let peopleArray = arrayPeople.componentsJoinedByString(",")
                    cell.priseLabel.text = "\(peopleArray)等\(dianzanSource.count)人觉得很赞"
                }
            }else{
                for i in 0..<dianzanSource.count{
                    let dianzanInfo = self.dianzanSource.dianzanlist[i]
                    arrayPeople.addObject(dianzanInfo.dianZanName!)
                    let peopleArray = arrayPeople.componentsJoinedByString(",")
                    cell.priseLabel.text = "\(peopleArray)等\(dianzanSource.count)人觉得很赞"
                }
            }
        }
        
        return cell
    }
//    点赞
    func dianZan(sender:UIButton){
        let btn:UIButton = sender
                let noticeInfo = self.noticeSource.objectList[btn.tag]
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
//                let noticeInfo = self.noticeSource.objectlist[sender.tag]
        //        self.commentSource = NCommentList(noticeInfo.comment!)
    }

}
