//
//  GDMyViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/6/6.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import XWSwiftRefresh
import MBProgressHUD

class GDMyViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    var table = UITableView()
    var noticeSource = SelfGrownList()
    var dianzanSource = DianZanList()
    var commentSource = NCommentList()
    let arrayPeople = NSMutableArray()
    let commentTextFiled = UITextField()
    var commentID = NSString()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //   打开手势交互
        self.view.userInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(_:)))
        
        self.view.addGestureRecognizer(tap)
        self.view.addSubview(commentTextFiled)

        //  初始化tableView
        self.createTable()
        //  刷新
        self.DropDownUpdate()
        //  获得数据
        self.loadData()
    }
    func tapAction(tap:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
        //    开始刷新
        func DropDownUpdate(){
            self.table.headerView = XWRefreshNormalHeader(target: self, action: #selector(YuanNoticeTableViewController.loadData))
            self.table.reloadData()
            self.table.headerView?.beginRefreshing()
        } 
        func loadData(){
            //        http://wxt.xiaocool.net/index.php?g=apps&m=index&a=BabyGrow&babyid=599&beginid=0
            
            let defalutid = NSUserDefaults.standardUserDefaults()
            let babyid = defalutid.stringForKey("chid")
            let beginid = "0"
            let param = ["a":"BabyGrow",
                         "babyid":babyid!,
                         "beginid":beginid]
            let url = "http://wxt.xiaocool.net/index.php?g=apps&m=index"
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
                        self.noticeSource = SelfGrownList(status.data!)
                        
                        self.table.reloadData()
                        self.table.headerView?.endRefreshing()
                    }
                }
            }
        }
//    创建表
    func createTable(){
        table = UITableView(frame: CGRectMake(0, 0, WIDTH, HEIGHT-HEIGHT/4-64-40-49))
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .None
        self.view.addSubview(table)
//        注册cell
//        table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "DiaryCell")
        table.registerNib(UINib.init(nibName: "DiaryTableViewCell", bundle: nil), forCellReuseIdentifier: "DiaryCell")
    
    }
//    行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return self.noticeSource.count
    }
//    行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //  自定义 (需要进行计算)
        //  取cell中tableView的高度，进行计算

        return 1000
    }
//    单元格
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DiaryCell", forIndexPath: indexPath) as! DiaryTableViewCell
        cell.selectionStyle = .None
        
        let selfGrownInfo = self.noticeSource.objectList[indexPath.row]
        //  保存得到的日志
        cell.fillCellWithModel(selfGrownInfo)

        
//      点赞
//        cell.dianzanBtn.addTarget(self, action: #selector(NoticeTableViewController.dianZan(_:)), forControlEvents: .TouchUpInside)
//        cell.dianzanBtn.setBackgroundImage(UIImage(named: "已点赞.png"), forState:.Selected)
//        cell.dianzanBtn.tag = indexPath.row
//        
//        
//        
//        cell.pinglunBtn.addTarget(self, action: #selector(NoticeTableViewController.pingLun(_:)), forControlEvents: .TouchUpInside)
//        cell.pinglunBtn.tag = indexPath.row
        
        
        
        
        //        判断是有人点赞
        //        解析的数据里面没有点赞的数据
        self.dianzanSource = DianZanList(selfGrownInfo.like!)
        
        print("self.dianzanSource.count")
        print(self.dianzanSource.count)
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

        return cell
    }
//    点赞
    func dianZan(sender:UIButton){
        let btn:UIButton = sender
                let noticeInfo = self.noticeSource.objectList[btn.tag]
        if btn.selected {
            //  没有被选中状态
            btn.selected = false
            //  到底传哪个id要根据自己的url传参进行决定
                        self.xuXiaoDianZan(noticeInfo.grow_id!)
        }else{
            btn.selected = true
            //  选中状态
                        self.getDianZan(noticeInfo.grow_id!)
        }
        
    }
        //    去点赞
        func getDianZan(grow_id:String){
            print(grow_id)
            //  http://wxt.xiaocool.net/index.php?g=apps&m=school&a=SetLike&userid=599&id=42&type=2
            let url = "http://wxt.xiaocool.net/index.php?g=apps&m=school&a=SetLike"
            let userDefaults = NSUserDefaults.standardUserDefaults()
            let userid = userDefaults.stringForKey("userid")
            let param = [
                "id":grow_id,
                "userid":userid!,
                "type":2
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
        func xuXiaoDianZan(grow_id:String){
            let url = "http://wxt.xiaocool.net/index.php?g=apps&m=school&a=ResetLike"
            let userDefaults = NSUserDefaults.standardUserDefaults()
            let userid = userDefaults.stringForKey("userid")
            print(userid)
            let param = [
                "id":grow_id,
                "userid":userid!,
            
                "type":2
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
        //  获取model，可以得到需要的属性
        let noticeInfo = self.noticeSource.objectList[sender.tag]
        commentID = noticeInfo.grow_id!

        commentTextFiled.delegate = self
        commentTextFiled.becomeFirstResponder()
    
        //  先创建UI    完成cell里面的套结tableView
        //  现在可以得到grow_id了
        //  弹出输入框，进行评论
        //  发送就是把评论的内容发送给网上url
        //  然后就是刷新页面
        
        //  (获取评论列表) userid(发帖人的id) refid(具体某一篇日志)type(?)
        //  http://wxt.xiaocool.net/index.php?g=apps&m=school&a=GetCommentlist&userid=597&refid=1&type=5
        //  这里是用来干嘛的
//                self.commentSource = NCommentList(noticeInfo.comment!)
//        let vc = GDPLViewController()
//                vc.id = String(noticeInfo.grow_id!)
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func textFieldDidEndEditing(textField: UITextField){
        print(textField.text)
        //  添加评论    userid(评论人) id (具体某一篇日志) content(评论的内容) type (?)
        
        //  http://wxt.xiaocool.net/index.php?g=apps&m=school&a=SetComment&userid=605&id=42&content=评论测试2016.07.01&type=4
        //  进行POST请求
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let userid = userDefaults.valueForKey("userid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=school&a=SetComment"
        print("commentID")
          print(commentID)
        let param = ["g":"apps",
                     "m":"school",
                     "a":"SetComment",
                     "userid":userid,"id":commentID,"content":textField.text,"type":"3"]
        Alamofire.request(.POST, url, parameters: param as? [String : AnyObject]).response { request, response, json, error in
            print("添加评论成功")
            
        }
 

    
  

    }
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        commentTextFiled.resignFirstResponder()
        return true
    }
    //  评论的数据请求
    func POSTComment(){
        //  进行POST请求把评论发布到网上
    }
}

