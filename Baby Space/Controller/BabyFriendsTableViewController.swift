//
//  BabyFriendsTableViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/5/27.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import XWSwiftRefresh

class BabyFriendsTableViewController: UITableViewController{

    
    @IBOutlet var tableSource: UITableView!
    
    var teacherSource = BabyFirendList()
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
        self.GetDate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.hidden = true
        
        self.tableSource.backgroundColor = RGBA(242.0, g: 242.0, b: 242.0, a: 1)
        
        GetDate()
        
        self.DropDownUpdate()
        
    }
    //    开始刷新
    func DropDownUpdate(){
        self.tableSource.headerView = XWRefreshNormalHeader(target: self, action: #selector(BabyFriendsTableViewController.GetDate))
        self.tableSource.reloadData()
        self.tableSource.headerView?.beginRefreshing()
    }
//    加载数据
    func GetDate(){

        //  http://wxt.xiaocool.net/index.php?g=apps&m=student&a=getfriendlist&studentid=597
        //下面两句代码是从缓存中取出userid（入参）值
        let defalutid = NSUserDefaults.standardUserDefaults()
        let sid = defalutid.stringForKey("chid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=getfriendlist"
        let param = [
            "studentid":sid!,
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
                    messageHUD(self.view, messageData: status.errorData!)
                }
                if(status.status == "success"){
                    self.teacherSource = BabyFirendList(status.data!)
                    
                    self.tableSource.reloadData()
                    self.tableSource.headerView?.endRefreshing()
                }
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
//    行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            return self.teacherSource.count
            
        }
    }
//    单元格
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = UITableViewCell(style: .Default, reuseIdentifier:String(indexPath.row))
            cell.selectionStyle = .None
            
            let img = UIImageView()
            img.frame = CGRectMake(20, 10, 70, 70)
            img.image = UIImage(named: "add2")
            cell.contentView.addSubview(img)
            
            let tit = UILabel()
            tit.frame = CGRectMake(100, 25, 120, 40)
            tit.text = "添加好友"
            tit.font = UIFont.systemFontOfSize(19)
            cell.contentView.addSubview(tit)
            
            
            return cell
        }else{
            let cell = UITableViewCell(style: .Default, reuseIdentifier:String(indexPath.row))
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.selectionStyle = .None
            let model = self.teacherSource.objectlist[indexPath.row]
            
            let imgBtn = UIButton()
            imgBtn.frame = CGRectMake(10, 15, 60, 60)
            let pic = model.photo
            let imgUrl = microblogImageUrl + pic!
            let photourl = NSURL(string: imgUrl)
            imgBtn.layer.cornerRadius = 30
            imgBtn.clipsToBounds = true
            imgBtn.setBackgroundImageForState(.Normal, withURL: photourl!, placeholderImage: UIImage(named: "默认头像"))
            cell.contentView.addSubview(imgBtn)
            
            let name = UILabel()
            name.frame = CGRectMake(90, 10, 120, 30)
            name.text = model.name
            name.font = biaotifont
            name.textColor = biaotiColor
            cell.contentView.addSubview(name)
            
            let phone = UILabel()
            phone.frame = CGRectMake(90, 50, 25, 30)
            phone.text = "共"
            phone.font = neirongfont
            phone.textColor = neirongColor
            cell.contentView.addSubview(phone)
            
            let phon = UILabel()
            phon.frame = CGRectMake(115, 50, 20, 30)
            phon.text = model.blog_coutn
            phon.font = neirongfont
            phon.textColor = neirongColor
            cell.contentView.addSubview(phon)

            let pho = UILabel()
            pho.frame = CGRectMake(135, 50, WIDTH - 165, 30)
            pho.text = "条成长日记"
            pho.font = neirongfont
            pho.textColor = neirongColor
            cell.contentView.addSubview(pho)

            
            let line = UILabel()
            line.frame = CGRectMake(0, 89.5, WIDTH, 0.5)
            
            
            return cell
        }
        
    }
//    行高
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            let vc = AddFriendViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        if indexPath.section == 1 {
            if self.teacherSource.objectlist[indexPath.row].blog_coutn! == "0" {
                let vc = NoneViewController()
                let model = self.teacherSource.objectlist[indexPath.row]
                vc.title = model.name
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else{
                
                let vc = BabyViewController()
                vc.strId = self.teacherSource.objectlist[indexPath.row].id!
                let model = self.teacherSource.objectlist[indexPath.row]
                vc.title = model.name
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

}
