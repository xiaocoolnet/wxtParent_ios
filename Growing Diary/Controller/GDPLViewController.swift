//
//  GDPLViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/6/6.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import XWSwiftRefresh
import MBProgressHUD

class GDPLViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    var id:String?
    var commentSource = NCommentList()
    
    let table = UITableView()
    
    override func viewWillAppear(animated: Bool) {
        //        self.DropDownUpdate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "评论列表"
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(GDPLViewController.writeComment))
        self.createTable()
    }
    //    写评论
    func writeComment(){
        let vc = GDWriteCommentViewController()
        //        vc.id = self.id!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //    //    开始刷新
    //    func DropDownUpdate(){
    //        self.table.headerView = XWRefreshNormalHeader(target: self, action: #selector(YNPLViewController.GetDate))
    //        self.table.reloadData()
    //        self.table.headerView?.beginRefreshing()
    //    }
    //    func GetDate(){
    //        //http://wxt.xiaocool.net/index.php?g=apps&m=school&a=GetCommentlist&userid=597&refid=1&type=5
    //        //下面两句代码是从缓存中取出userid（入参）值
    //        let defalutid = NSUserDefaults.standardUserDefaults()
    //        let userid = defalutid.stringForKey("userid")
    //
    //        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=school&a=GetCommentlist"
    //        let param = [
    //            "userid":userid!,
    //            "refid":self.id!,
    //            "type":3
    //        ]
    //        Alamofire.request(.GET, url, parameters: param as? [String : AnyObject]).response { request, response, json, error in
    //            if(error != nil){
    //            }
    //            else{
    //                print("request是")
    //                print(request!)
    //                print("====================")
    //                let status = Http(JSONDecoder(json!))
    //                print("状态是")
    //                print(status.status)
    //                if(status.status == "error"){
    //                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    //                    hud.mode = MBProgressHUDMode.Text
    //                    hud.labelText = status.errorData
    //                    hud.margin = 10.0
    //                    hud.removeFromSuperViewOnHide = true
    //                    hud.hide(true, afterDelay: 1)
    //                }
    //                if(status.status == "success"){
    //                    self.commentSource = NCommentList(status.data!)
    //                    self.table.reloadData()
    //                    self.table.headerView?.endRefreshing()
    //                }
    //            }
    //        }
    //
    //    }
    //    创建表
    func createTable(){
        table.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)
        table.delegate = self
        table.dataSource = self
        self.view.addSubview(table)
        
        table.registerNib(UINib.init(nibName: "GDCommentTableViewCell", bundle: nil), forCellReuseIdentifier: "GDCommentCell")
    }
    //    有几行
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    //    单元格
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GDCommentCell", forIndexPath: indexPath) as! GDCommentTableViewCell
        cell.selectionStyle = .None
        //        let nCommentInfo = self.commentSource.commentlist[indexPath.row]
        //        cell.updateCellWithNCommentInfo(nCommentInfo)
        
        return cell
    }
    //    单元格高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //        let nCommentInfo = self.commentSource.commentlist[indexPath.row]
        //        //        自适应行高
        //        let options : NSStringDrawingOptions = NSStringDrawingOptions.UsesLineFragmentOrigin
        //        let screenBounds:CGRect = UIScreen.mainScreen().bounds
        //        let boundingRect = String(nCommentInfo.content).boundingRectWithSize(CGSizeMake(screenBounds.width, 0), options: options, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(17)], context: nil)
        //        return boundingRect.size.height + 210
        return 240
    }
    
}