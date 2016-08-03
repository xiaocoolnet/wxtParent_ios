//
//  CourseDetailViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/5/31.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import YYWebImage
import XWSwiftRefresh
import MBProgressHUD

class CourseDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let table = UITableView()
    var homeworkSource = CoursewareDetailsList()
    var dianzanSource = DianZanList()
    var commentSource = HCommentList()
    let arrayPeople = NSMutableArray()
    var id : String!
    
//    override func viewWillAppear(animated: Bool) {
//        self.DropDownUpdate()
//    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        self.createTable()
        self.loadData()
    }
    //    开始刷新
    func DropDownUpdate(){
        self.table.headerView = XWRefreshNormalHeader(target: self, action: #selector(CourseDetailViewController.loadData))
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
        
        table.registerNib(UINib.init(nibName: "CourseDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "CourseDetailCell")
    }
//    加载数据
    func loadData(){
    
    //  http://wxt.xiaocool.net/index.php?g=apps&m=school&a=GetClassCoursewareList&schoolid=1&classid=1&subjectid=1
//
        //下面两句代码是从缓存中取出userid（入参）值
        let defalutid = NSUserDefaults.standardUserDefaults()
        let schoolid = defalutid.stringForKey("schoolid")
        let classid = defalutid.stringForKey("classid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=school&a=GetClassCoursewareList"
        let param = [
            "schoolid":schoolid!,
            "classid":classid!,
            "subjectid":id!
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
                    self.homeworkSource = CoursewareDetailsList(status.data!)
                    self.table.reloadData()
                    self.table.headerView?.endRefreshing()
                }
            }
        }
    }
//    分区数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
//    行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return homeworkSource.count
        return self.homeworkSource.count
    }
//    单元格
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CourseDetailCell", forIndexPath: indexPath)
            as! CourseDetailTableViewCell
        cell.selectionStyle = .None
        let homeworkInfo = self.homeworkSource.objectlist[indexPath.row]
//        let dateformate = NSDateFormatter()
//        dateformate.dateFormat = "yyyy-MM-dd HH:mm"
//        
        cell.titleLbl.text = homeworkInfo.post_title
        cell.contentLbl.text = homeworkInfo.post_content
        cell.timeLbl.text = homeworkInfo.post_date
//
//        let imgUrl = imageUrl + homeworkInfo.photo!
//        let photourl = NSURL(string: imgUrl)
//        cell.bigImageView.yy_setImageWithURL(photourl, placeholder: UIImage(named: "园所公告背景.png"))
//        cell.senderLbl.text = homeworkInfo.username
//        点赞按钮
//        cell.dianzanBtn.addTarget(self, action: #selector(HomeworkViewController.dianZan(_:)), forControlEvents: .TouchUpInside)
//        cell.dianzanBtn.setBackgroundImage(UIImage(named: "已点赞.png"), forState:.Selected)
//        cell.dianzanBtn.tag = indexPath.row
////        评论按钮
//        cell.pinglunBtn.addTarget(self, action: #selector(HomeworkViewController.pingLun(_:)), forControlEvents: .TouchUpInside)
//        cell.pinglunBtn.tag = indexPath.row
//
//        let date = NSDate(timeIntervalSince1970: NSTimeInterval(homeworkInfo.create_time!)!)
//        let str:String = dateformate.stringFromDate(date)
//        cell.timeLbl.text = str
//        
//        //        自适应行高
//        let options : NSStringDrawingOptions = NSStringDrawingOptions.UsesLineFragmentOrigin
//        let screenBounds:CGRect = UIScreen.mainScreen().bounds
//        let boundingRect = String(cell.contentLbl.text).boundingRectWithSize(CGSizeMake(screenBounds.width, 0), options: options, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(17)], context: nil)
//        //        判断是有人点赞
//        self.dianzanSource = DianZanList(homeworkInfo.dianzanlist!)
//        if self.dianzanSource.count == 0 {
//            cell.zanListLbl.text = "0人点赞"
//            table.rowHeight = boundingRect.size.height + 391
//        }else{
//            //                先清空
//            arrayPeople.removeAllObjects()
//            //循环遍历点赞数量，对比是否自己点过赞
//            for i in 0..<dianzanSource.count{
//                let dianzanInfo = self.dianzanSource.dianzanlist[i]
//                //如果点过赞，则显示点赞图标
//                let userid = NSUserDefaults.standardUserDefaults()
//                let uid = userid.stringForKey("userid")
//                if(dianzanInfo.dianZanId == uid){
//                    cell.dianzanBtn.selected = true
//                    cell.dianzanBtn.setBackgroundImage(UIImage(named: "已点赞"), forState:.Normal)
//                }else{//如果没点过赞，显示灰色图标
//                    cell.dianzanBtn.selected = false
//                    cell.dianzanBtn.setBackgroundImage(UIImage(named: "点赞"), forState: .Normal)
//                }
//            }
//            if dianzanSource.count>4{
//                for i in 0..<4{
//                    let dianzanInfo = self.dianzanSource.dianzanlist[i]
//                    arrayPeople.addObject(dianzanInfo.dianZanName!)
//                    let peopleArray = arrayPeople.componentsJoinedByString(",")
//                    cell.zanListLbl.text = "\(peopleArray)等\(dianzanSource.count)人觉得很赞"
//                }
//            }else{
//                for i in 0..<dianzanSource.count{
//                    let dianzanInfo = self.dianzanSource.dianzanlist[i]
//                    arrayPeople.addObject(dianzanInfo.dianZanName!)
//                    let peopleArray = arrayPeople.componentsJoinedByString(",")
//                    cell.zanListLbl.text = "\(peopleArray)等\(dianzanSource.count)人觉得很赞"
//                }
//            }
//            
//            table.rowHeight = boundingRect.size.height + 391
//        }
        
        return cell
    }
//    行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 320
    }
    //    点赞
    func dianZan(sender:UIButton){
        let btn:UIButton = sender
//        let homeworkInfo = self.homeworkSource.homeworkList[btn.tag]
        if btn.selected {
            btn.selected = false
//            self.xuXiaoDianZan(homeworkInfo.id!)
        }else{
            btn.selected = true
//            self.getDianZan(homeworkInfo.id!)
        }
    }
//    //    去点赞
//    func getDianZan(id:String){
//        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=school&a=SetLike"
//        let userid = NSUserDefaults.standardUserDefaults()
//        let uid = userid.stringForKey("userid")
//        let param = [
//            "id":id,
//            "userid":uid!,
//            "type":2
//        ]
//        Alamofire.request(.GET, url, parameters: param as? [String : AnyObject]).response { request, response, json, error in
//            if(error != nil){
//            }
//            else{
//                print("request是")
//                print(request!)
//                print("====================")
//                let status = MineModel(JSONDecoder(json!))
//                print("状态是")
//                print(status.status)
//                if(status.status == "error"){
//                    
//                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//                    hud.mode = MBProgressHUDMode.Text;
//                    hud.labelText = status.errorData
//                    hud.margin = 10.0
//                    hud.removeFromSuperViewOnHide = true
//                    hud.hide(true, afterDelay: 1)
//                }
//                
//                if(status.status == "success"){
//                    //self.dianZanBtn.selected == true
//                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//                    hud.mode = MBProgressHUDMode.Text;
//                    hud.labelText = "点赞成功"
//                    hud.margin = 10.0
//                    hud.removeFromSuperViewOnHide = true
//                    hud.hide(true, afterDelay: 1)
//                    self.loadData()
//                }
//                
//            }
//            
//        }
//        
//    }
//    //    取消点赞
//    func xuXiaoDianZan(id:String){
//        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=school&a=ResetLike"
//        let userid = NSUserDefaults.standardUserDefaults()
//        let uid = userid.stringForKey("userid")
//        let param = [
//            "id":id,
//            "userid":uid!,
//            "type":2
//        ]
//        Alamofire.request(.GET, url, parameters: param as? [String : AnyObject]).response { request, response, json, error in
//            if(error != nil){
//            }
//            else{
//                print("request是")
//                print(request!)
//                print("====================")
//                let status = MineModel(JSONDecoder(json!))
//                print("状态是")
//                print(status.status)
//                if(status.status == "error"){
//                    
//                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//                    hud.mode = MBProgressHUDMode.Text;
//                    hud.labelText = status.errorData
//                    hud.margin = 10.0
//                    hud.removeFromSuperViewOnHide = true
//                    hud.hide(true, afterDelay: 1)
//                }
//                
//                if(status.status == "success"){
//                    //self.dianZanBtn.selected == true
//                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//                    hud.mode = MBProgressHUDMode.Text;
//                    hud.labelText = "取消点赞"
//                    hud.margin = 10.0
//                    hud.removeFromSuperViewOnHide = true
//                    hud.hide(true, afterDelay: 1)
//                    self.loadData()
//                }
//                
//            }
//            
//        }
//    }
    //   评论
    func pingLun(sender:UIButton){
        let btn:UIButton = sender
//        let homeworkInfo = self.homeworkSource.homeworkList[btn.tag]
//        self.commentSource = HCommentList(homeworkInfo.comment!)
        let vc = CDPLViewController()
//        vc.id = homeworkInfo.id
//        vc.commentSource = self.commentSource
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
