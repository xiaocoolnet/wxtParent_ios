//
//  StuRelationViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/4/29.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire

class StuRelationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    let table = UITableView()
    var childrenSource = ChildrenList()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "孩子列表"
        self.view.backgroundColor = UIColor.whiteColor()
        self.createTable()
        self.getDate()
    }
    func createTable(){
        table.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .None
        self.view.addSubview(table)
        
        table.registerNib(UINib.init(nibName: "ChildrenTableViewCell", bundle: nil), forCellReuseIdentifier: "ChildrenCellID")
    }
    func getDate(){
//        http://wxt.xiaocool.net/index.php?g=apps&m=index&a=GetUserRelation&userid=597
        
        //下面两句代码是从缓存中取出userid（入参）值
        let defalutid = NSUserDefaults.standardUserDefaults()
        let uid = defalutid.stringForKey("userid")
        let url = apiUrl + "GetUserRelation"
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
                    self.childrenSource = ChildrenList(status.data!)
                    self.table.reloadData()
                }
            }
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return childrenSource.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChildrenCellID", forIndexPath: indexPath)
            as! ChildrenTableViewCell
        cell.selectionStyle = .None
        let childrenInfo = self.childrenSource.objectlist[indexPath.row]
        let dateformate = NSDateFormatter()
        dateformate.dateFormat = "yyyy-MM-dd HH:mm"
        let imgUrl = imageUrl + childrenInfo.studentavatar!
        let photourl = NSURL(string: imgUrl)
        cell.headImageView.yy_setImageWithURL(photourl, placeholder: UIImage(named: "Logo.png"))
        cell.nameLbl.text = childrenInfo.studentname
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let childrenInfo = self.childrenSource.objectlist[indexPath.row]
        let vc = TeacherListViewController()
        vc.studentid = childrenInfo.studentid
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
