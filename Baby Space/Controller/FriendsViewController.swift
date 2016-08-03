//
//  FriendsViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/5/12.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class FriendsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{

    let table = UITableView()
    var addSource = AddList()
    var teacherSource =  TeaList()
    var dic = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTable()
        GetDate()
        
    }
//    创建表
    func createTable(){
        table.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-40)
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 70
        table.separatorStyle = .None
        self.view.addSubview(table)
//        创建cell
        table.registerClass(QCFriendsCell.self, forCellReuseIdentifier: "cell")
    }
//    获取好友的通讯录（这里先用老师的通讯录进行测试）
    func GetDate(){
        //        http://wxt.xiaocool.net/index.php?g=apps&m=index&a=MessageAddress&userid=597
        
        //  http://wxt.xiaocool.net/index.php?g=apps&m=student&a=getfriendlist&studentid=661
        let defalutid = NSUserDefaults.standardUserDefaults()
        let uid = defalutid.stringForKey("userid")
        let url = apiUrl+"MessageAddress"
        let param = [
            "userid":uid!
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
                    self.addSource = AddList(status.data!)
                    //                    将分区组的标题和每个分区的cell的数目作为字典存起来
                    if self.addSource.count != 0{
                        for i in 0..<self.addSource.count {
                            let addInfo = self.addSource.objectlist[i]
                            //                            let teacherList = self.addSource.objectlist[i]
                            self.teacherSource = TeaList(addInfo.teacherinfo!)
                            self.dic.setValue(self.teacherSource.count, forKey:addInfo.classname! )
                        }
                    }
                    self.table.reloadData()
                }
            }
        }
        
    }
    //    分区数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.addSource.count
    }
    //    分区标题
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        let addInfo = self.addSource.objectlist[section]
        return addInfo.classname!
    }
    //    每个分区的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let addInfo = self.addSource.objectlist[section]
        let str: String = addInfo.classname!
        let num = dic[str] as! Int
        return num
    }
    //    单元格
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! QCFriendsCell
        cell.selectionStyle = .None
        
        let teacherList = self.addSource.objectlist[indexPath.section]
        self.teacherSource = TeaList(teacherList.teacherinfo!)
        let teacherInfo = self.teacherSource.objectlist[indexPath.row]
        cell.fillCellWithModel(teacherInfo)
        
        return cell
    }
//    分区头的高度
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 30.0
    }

}
