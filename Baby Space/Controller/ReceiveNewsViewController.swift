//
//  ReceiveNewsViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/4/27.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire

class ReceiveNewsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    let table = UITableView()
    var newsSource = NewsList()
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createTable()
        self.getDate()
    }
    func createTable(){
        table.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .None
        self.view.addSubview(table)
        
        table.registerNib(UINib.init(nibName: "ReceiveNewsTableViewCell", bundle: nil), forCellReuseIdentifier: "ReceiveCellID")
    }
    func getDate(){
        //下面两句代码是从缓存中取出userid（入参）值
        let defalutid = NSUserDefaults.standardUserDefaults()
        let uid = defalutid.stringForKey("userid")
        let url = apiUrl + "ReceiveidMessage"
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
                    self.newsSource = NewsList(status.data!)
                    self.table.reloadData()
                }
            }
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsSource.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ReceiveCellID", forIndexPath: indexPath)
            as! ReceiveNewsTableViewCell
        cell.selectionStyle = .None
        let newsInfo = self.newsSource.objectlist[indexPath.row]
        cell.nameLbl.text = newsInfo.receive_user_name!
        cell.contentLbl.text = newsInfo.message_content!
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let newsInfo = self.newsSource.objectlist[indexPath.row]
//        newsInfo.send_user_id
        let chatView = ChatViewController(conversationChatter: "597", conversationType: EMConversationType.eConversationTypeChat)
        chatView.title = newsInfo.receive_user_name!
        self.navigationController?.pushViewController(chatView, animated: true)
    }
}
