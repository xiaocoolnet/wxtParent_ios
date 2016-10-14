//
//  QCBabySwitchVC.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/14.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire

class QCBabySwitchVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var tableView = UITableView()
    var dataSource = MineChildrenList()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
        createTableView()
        GetDate()
        
    }
    func initUI(){
        self.title = "我的宝宝"
        self.tabBarController?.tabBar.hidden = true
    }
    func createTableView(){
        tableView.frame = self.view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return self.dataSource.objectlist.count
    
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .Default, reuseIdentifier:String(indexPath.row))
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.selectionStyle = .None
        let model = self.dataSource.objectlist[indexPath.row]
        
        let img = UIImageView()
        img.frame = CGRectMake(10, 15, 60, 60)
        let pic = model.studentavatar
        let imgUrl = microblogImageUrl + pic!
        let photourl = NSURL(string: imgUrl)
        img.sd_setImageWithURL(photourl, placeholderImage: UIImage(named: "默认头像"))
        img.layer.cornerRadius = 30
        img.clipsToBounds = true
        cell.contentView.addSubview(img)
        
        let name = UILabel()
        name.frame = CGRectMake(90, 10, 160, 30)
        name.text = model.studentname
        cell.contentView.addSubview(name)
        
        return cell
        
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let model = self.dataSource.objectlist[indexPath.row]
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(model.studentid, forKey: "chid")
        userDefaults.setValue(model.studentname, forKey: "chidname")
        userDefaults.setValue(model.classlist[0].classid, forKey: "classid")
        userDefaults.setValue(model.classlist[0].schoolid, forKey: "schoolid")
        let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("切换宝宝成功", comment: "empty message"), preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //    加载数据
    func GetDate(){
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=index&a=GetUserRelation"
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let userid = userDefaults.stringForKey("userid")
        
        let param = [
            "userid":userid
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
                    hud.mode = MBProgressHUDMode.Text;
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                
                if(status.status == "success"){
                    self.dataSource = MineChildrenList(status.data!)
                    self.tableView.reloadData()
                }
            }
            
        }
    }



}
