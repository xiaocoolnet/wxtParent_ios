//
//  QCInviteFamilyVC.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/14.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import ImageSlideshow
import XWSwiftRefresh
import MBProgressHUD

class QCInviteFamilyVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var tableView = UITableView()
    
    var dataSource = InviteList()
    
    override func viewWillAppear(animated: Bool) {
        self.GetDate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        createTableView()
//        self.GetDate()
    }
    
    //    加载数据
    func GetDate(){
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=GetInviteFamily"
        //       http://wxt.xiaocool.net/index.php?g=apps&m=student&a=GetInviteFamily&studentid=597
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let studentid = userDefaults.stringForKey("chid")

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
                    hud.mode = MBProgressHUDMode.Text;
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                
                if(status.status == "success"){
                   self.dataSource = InviteList(status.data!)
                    self.tableView.reloadData()
                }
            }
            
        }
    }
    
    func initUI(){
        self.title = "我的家人"
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
        return 90
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            return self.dataSource.objectlist.count
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            cell.selectionStyle = .None
//            cell.textLabel?.text = "邀请家人"
            
            let img = UIImageView()
            img.frame = CGRectMake(20, 10, 70, 70)
            img.image = UIImage(named: "add2")
            cell.contentView.addSubview(img)
            
            return cell
        }else{
            let cell = UITableViewCell(style: .Default, reuseIdentifier:String(indexPath.row))
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.selectionStyle = .None
            let model = self.dataSource.objectlist
            
            let img = UIImageView()
            img.frame = CGRectMake(10, 15, 60, 60)
            let pic = model[indexPath.row].parent_info[0].photo
            let imgUrl = microblogImageUrl + pic!
            let photourl = NSURL(string: imgUrl)
            img.sd_setImageWithURL(photourl, placeholderImage: UIImage(named: "默认头像"))
            img.layer.cornerRadius = 30
            img.clipsToBounds = true
            cell.contentView.addSubview(img)

            let name = UILabel()
            name.frame = CGRectMake(90, 10, 120, 30)
            name.text = model[indexPath.row].appellation
            cell.contentView.addSubview(name)
            
            let phone = UILabel()
            phone.frame = CGRectMake(90, 50, 120, 30)
            phone.text = model[indexPath.row].parent_info[0].phone
            cell.contentView.addSubview(phone)
            
            if model[indexPath.row].type == "1" {
                let btn = UIButton()
                btn.frame = CGRectMake(WIDTH - 100, 25, 40, 40)
                btn.setBackgroundImage(UIImage(named: "data"), forState: .Normal)
                btn.backgroundColor = UIColor.lightGrayColor()
                btn.layer.cornerRadius = 30
                cell.contentView.addSubview(btn)
                
            }
            
            let line = UILabel()
            line.frame = CGRectMake(0, 89.5, WIDTH, 0.5)
            
            
            return cell
        }
        
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            print("邀请家人")
            if self.dataSource.objectlist.count < 5 {
                let invitationVC = QCInvitationVC()
                self.navigationController?.pushViewController(invitationVC, animated: true)
            }
            
        }
        if indexPath.section == 1 {
            let myFamilyVC = QCMyFamilyVC()
            myFamilyVC.dataSource = self.dataSource.objectlist[indexPath.row]
            myFamilyVC.getTitle = self.dataSource.objectlist[indexPath.row].appellation
            self.navigationController?.pushViewController(myFamilyVC, animated: true)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    



}
