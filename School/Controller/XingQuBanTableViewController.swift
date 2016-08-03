//
//  XingQuBanTableViewController.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/1/31.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import XWSwiftRefresh
import YYWebImage

class XingQuBanTableViewController: UITableViewController {

    @IBOutlet var tableSource: UITableView!
    var banSource = XingQuBanList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableSource.registerClass(SchoolNoticeCell.self, forCellReuseIdentifier: "cell")
        self.tableSource.backgroundColor = RGBA(239, g: 239, b: 244, a: 1)
        self.tabBarController?.tabBar.hidden = true
        self.DropDownUpdate()
    }
    //    开始刷新
    func DropDownUpdate(){
        self.tableSource.headerView = XWRefreshNormalHeader(target: self, action: #selector(XingQuBanTableViewController.GetDate))
        self.tableSource.reloadData()
        self.tableSource.headerView?.beginRefreshing()
    }
//    加载数据
    func GetDate(){
   
        //  http://wxt.xiaocool.net/index.php?g=apps&m=school&a=getInterestclass&schoolid=1
        let defalutid = NSUserDefaults.standardUserDefaults()
        let sid = defalutid.stringForKey("schoolid")
        
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=school&a=getInterestclass"
        //   学校信息为空
        let param = [
            "schoolid":sid!
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
                    self.banSource = XingQuBanList(status.data!)
                    self.tableSource.reloadData()
                    self.tableSource.headerView?.endRefreshing()
                }
            }
        }
    }
//    行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return banSource.count
    }
//    行高
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 116
    }
//    单元格
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SchoolNoticeCell
        cell.selectionStyle = .None
//        cell.accessoryType = .DisclosureIndicator
        let imageView = UIImageView()
        imageView.frame = CGRectMake(WIDTH - 40, 48, 10, 20)
        cell.addSubview(imageView)
        imageView.image = UIImage.init(named: "右边剪头")
        let model = self.banSource.xiangquBanlist[indexPath.row]
        //  进行cell的填充
        cell.titleLabel.text = model.post_title
        cell.contentLabel.text = model.post_excerpt
        let imageURL = microblogImageUrl + model.thumb!
        cell.headerImageView.sd_setImageWithURL(NSURL.init(string: imageURL), placeholderImage: UIImage(named: "1.png"))
        
        return cell
    }
//    单元格点击事件
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = InterestShareVC()
        let banInfo = self.banSource.xiangquBanlist[indexPath.row]
        // 直接传的数据源
        vc.id = banInfo.id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
