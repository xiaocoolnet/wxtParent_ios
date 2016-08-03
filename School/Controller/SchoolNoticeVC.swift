//
//  SchoolNoticeVC.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/6.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
//  刷新
import XWSwiftRefresh

//  加载数据
import Alamofire


class SchoolNoticeVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var tableView = UITableView()
    
    var dataSource = YuanHomeList()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SchoolNotice")
        self.view.backgroundColor = UIColor.whiteColor()
        //  创建UI界面
        createUI()
        //  刷新
        freshData()
        //  进行数据请求
        getData()
    }
    //  MAKR: - 创建UI界面
    func createUI() {
        //  给tableview
        tableView.frame = self.view.bounds
        self.view.addSubview(tableView)
        //  注册cell
        tableView.registerClass(SchoolNoticeCell.self, forCellReuseIdentifier: "cell")
        //  遵守协议
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 116
        self.tableView.backgroundColor = RGBA(239, g: 239, b: 244, a: 1)
    }
    //  MARK: - 刷新界面
    func freshData(){
        //  表头进行数据的加载
        tableView.headerView = XWRefreshNormalHeader(target: self,action: #selector(getData))
    }
    //  MAKR: - 进行数据请求
    func getData()  {
//        接口地址：a=SchoolNotice
        let url = kURL
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let schoolid = userDefaults.valueForKey("schoolid")
        let param = ["m":"school","a":"getSchoolNotices","schoolid":schoolid]
//        入参：schoolid
//        http://wxt.xiaocool.net/index.php?g=apps&m=index&a=SchoolNotice&schoolid=1
//        http://wxt.xiaocool.net/index.php?g=apps&m=school&a=getSchoolNotices&schoolid=1
        Alamofire.request(.GET, url, parameters: param as? [String:AnyObject]).response{request, response, json, error in
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
                    self.dataSource = YuanHomeList(status.data!)
                    self.tableView.reloadData()
                    //  停止刷新
                    self.tableView.headerView?.endRefreshing()
                }
            }

        }
    }
    //  MAKR: - tableViewDataSource
    //  多少行
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.objectlist.count
    }
    //  tableView的高度设置
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 110
    }
    //  MAKR: - tableViewDelegate
    //  单元格的填充
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? SchoolNoticeCell
        let model = self.dataSource.objectlist[indexPath.row]
        
        
        cell?.selectionStyle = .None
        tableView.separatorStyle = .None
        /*
         titleLabel.text = model.notice_title
         
         //  转时间戳
         let mondayInterval:NSTimeInterval = NSTimeInterval(model.notice_time!)!
         let mondayDate = NSDate(timeIntervalSince1970: mondayInterval)
         
         //格式话输出
         let dformatter = NSDateFormatter()
         dformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
         timeLable.text = dformatter.stringFromDate(mondayDate)
         
         contentLabel.numberOfLines = 0
         contentLabel.frame.size.height = model.hight!
         contentLabel.text = model.notice_content
         let imageURL = microblogImageUrl + model.photo!
         headerImageView.sd_setImageWithURL(NSURL.init(string: imageURL), placeholderImage: UIImage(named: "1.png"))
         */
        cell?.fillCellWithModel(model)
        return cell!
    }


    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = NewsDetailViewController()
        // 解析出来的参数里没有ID
        vc.id = self.dataSource.objectlist[indexPath.row].id
        vc.tag = 3
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //  内存警告的方法
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
