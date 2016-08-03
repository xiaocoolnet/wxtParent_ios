//
//  QCInviteFamilyVC.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/14.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class QCInviteFamilyVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        createTableView()
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
        return HEIGHT / 8.0
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            return 3
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            cell.selectionStyle = .None
            cell.textLabel?.text = "邀请家人"
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.selectionStyle = .None
            cell.textLabel?.text = "爷爷"
            return cell
        }
        
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            print("邀请家人")
            let invitationVC = QCInvitationVC()
            self.navigationController?.pushViewController(invitationVC, animated: true)
            
        }
        if indexPath.section == 1 {
            let myFamilyVC = QCMyFamilyVC()
            myFamilyVC.getTitle = "给我名字"
            self.navigationController?.pushViewController(myFamilyVC, animated: true)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    



}
