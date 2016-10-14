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
    var dataSource = AllFamilyList()
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
//        http://wxt.xiaocool.net/index.php?g=apps&m=student&a=GetParentList&studentid=661
        let defalutid = NSUserDefaults.standardUserDefaults()
        let uid = defalutid.stringForKey("chid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=GetParentList"
        let param = [
            "studentid":uid!
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
                    self.dataSource = AllFamilyList(status.data!)
                    self.table.reloadData()
                }
            }
        }
        
    }
    //MARK: delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.dataSource.objectlist[0].stu_par_list[section].isOpen) {
//            print(self.dataSource.objectlist[section].isOpen)
            return self.dataSource.objectlist[0].stu_par_list[section].parent_info.count
        }else{
            return 0;
        }
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.dataSource.objectlist.count != 0 {
            
            return self.dataSource.objectlist[0].stu_par_list.count
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let headerView = UIView()
        headerView.frame = CGRectMake(0, 0, WIDTH, 40)
        headerView.backgroundColor = UIColor.whiteColor()
        
        //展开折叠按钮
        let big_select_btn = UIButton()
        big_select_btn.frame = CGRectMake(0, 0, WIDTH, 40)
        big_select_btn.tag = section
        big_select_btn.selected = self.dataSource.objectlist[0].stu_par_list[section].isOpen
        big_select_btn.addTarget(self, action: #selector(self.outspread(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        headerView.addSubview(big_select_btn)
        
        //组头展开折叠按钮
        let point_btn = UIButton()
        point_btn.frame = CGRectMake(WIDTH - 30, 10, 15, 15)
        point_btn.setBackgroundImage(UIImage(named: "right"), forState: UIControlState.Normal)
        point_btn.setBackgroundImage(UIImage(named: "down"), forState: UIControlState.Selected)
        point_btn.tag = section
        point_btn.selected = self.dataSource.objectlist[0].stu_par_list[section].isOpen
        headerView.addSubview(point_btn)
        
        let img = UIImageView()
        img.frame = CGRectMake(10, 5, 30, 30)
        let pi = self.dataSource.objectlist[0].stu_par_list[section].photo
        let imgUrl = microblogImageUrl + pi!
        let photourl = NSURL(string: imgUrl)
        img.layer.cornerRadius = 15
        img.clipsToBounds = true
        img.sd_setImageWithURL(photourl, placeholderImage: UIImage(named: "默认头像"))
        headerView.addSubview(img)
        //组名
        let titlelabel = UILabel()
        titlelabel.frame = CGRectMake(50, 0, 150, 40)
        titlelabel.text = self.dataSource.objectlist[0].stu_par_list[section].name
        titlelabel.textColor = UIColor.blackColor()
        headerView.addSubview(titlelabel)
        
        //分割线
        let lineView = UIView()
        lineView.frame = CGRectMake(0, 39.5, WIDTH, 0.5)
        lineView.backgroundColor = tableView.separatorColor
        headerView.addSubview(lineView)
        
        return headerView
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .Default, reuseIdentifier: String(indexPath.row))
        cell.selectionStyle = .None
        tableView.separatorStyle = .None
        cell.backgroundColor = RGBA(242.0, g: 242.0, b: 242.0, a: 1)
        
        let model = self.dataSource.objectlist[0].stu_par_list[indexPath.section].parent_info[indexPath.row]
        
        let img = UIImageView()
        img.frame = CGRectMake(30, 10, 50, 50)
        let pi = model.photo
        let imgUrl = microblogImageUrl + pi
        let photourl = NSURL(string: imgUrl)
        img.layer.cornerRadius = 25
        img.clipsToBounds = true
        img.sd_setImageWithURL(photourl, placeholderImage: UIImage(named: "默认头像"))
        cell.contentView.addSubview(img)
        
        let name = UILabel()
        name.frame = CGRectMake(90, 10, WIDTH - 100, 50)
        name.text = (model.name) + "(" + model.appellation + ")"
        name.textColor = UIColor.blackColor()
        cell.contentView.addSubview(name)
        
        return cell
    }
    

    //MARK: click
    //折叠展开点击事件
    func outspread(sender:UIButton) -> Void {
        if sender.selected {
            sender.selected = false
        }else{
            sender.selected = true
        }
        
        self.dataSource.objectlist[0].stu_par_list[sender.tag].isOpen = sender.selected
        
        table.reloadData()
    }

}
