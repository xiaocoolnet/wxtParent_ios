//
//  TableViewController.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/25.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import YYWebImage
import XWSwiftRefresh
import MBProgressHUD

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let tableView = UITableView()
    var homeworkSource = HomeworkList()
    var dianzanSource = DianZanList()
    var commentSource = HCommentList()
    var homeWorkArr = QCHomeWorkList()
    var photoArr = QCPictureList()
    let arrayPeople = NSMutableArray()
    
    
    var dataSouce = NewsLi()
    var likeSource = LikeList()
    
    var picSource = PiList()
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        //        self.createTable()
        //        self.loadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.hidden = true
        self.DropDownUpdate()
        //        self.createTable()
        self.loadData()
        self.title = "作业"
        
    }
    //    开始刷新
    func DropDownUpdate(){
        self.tableView.headerView = XWRefreshNormalHeader(target: self, action: #selector(HomeworkViewController.loadData))
        self.tableView.reloadData()
        self.tableView.headerView?.beginRefreshing()
    }
    //    创建表
    func createTable(){
        tableView.frame = self.view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        //  隐藏线
        tableView.separatorStyle = .None
        self.view.addSubview(tableView)
        //        注册cell
        //        table.registerNib(UINib.init(nibName: "HomeworkTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeworkCellID")
        tableView.registerClass(HomeworkTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    //    获取作业列表
    func loadData(){
        //  需要进行接口的修改
        
        //       http://wxt.xiaocool.net/index.php?g=apps&m=student&a=gethomeworkmessage&receiverid=599
        //下面两句代码是从缓存中取出userid（入参）值
        let defalutid = NSUserDefaults.standardUserDefaults()
        let receiverid = defalutid.stringForKey("chid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=gethomeworkmessage"
        let param = [
            //            "classid":classid!,
            "receiverid":receiverid!
            //  这里为空了
            
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
                    
                    
                    //                    self.tableView.reloadData()
                    
                    
                    self.dataSouce = NewsLi(status.data!)
                    self.likeSource = LikeList(status.data!)
                    self.picSource = PiList(status.data!)
                    
                    self.createTable()
                    self.tableView.headerView?.endRefreshing()
                }
            }
        }
    }
    
    //    行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(homeworkSource.count)
        
        //        return homeworkSource.count
        return dataSouce.objectlist.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 430
    }
    //    单元格
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //  先走了两次改方法
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            as! HomeworkTableViewCell
        cell.selectionStyle = .None
        //
        //        cell.collectionView?.reloadData()
        
        
//        let homeworkInfo = self.homeworkSource.homeworkList[indexPath.row]
//        
//        //
//        self.homeWorkArr = QCHomeWorkList(homeworkInfo.homework_info!)
//        //  获取第一条作业的信息
//        let homeWorkData = self.homeWorkArr.homeworkList[0]
        
        
        
        let mode = self.dataSouce.objectlist[indexPath.row]
        let model = mode.homework_inf.first
//        cell.setShow(mode)
        
        //  标题
//        cell.titleLbl.text = model!.title
        //  内容
        cell.contentLbl.text = model!.content
        
        //  得到homework  数据
        print(self.homeWorkArr)
        print(self.homeWorkArr.count)
        
        
//        let pic = mode.pictur
        
//        cell.send(self.navigationController!)
        
        //  老师
        cell.senderLbl.text = model!.name
        
        //  时间
        let dateformate = NSDateFormatter()
        dateformate.dateFormat = "yyyy-MM-dd HH:mm"
        let date = NSDate(timeIntervalSince1970: NSTimeInterval(model!.create_time!)!)
        let str:String = dateformate.stringFromDate(date)
        cell.timeLbl.text = str
        
        
        return cell
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
