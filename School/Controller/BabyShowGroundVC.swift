//
//  BabyShowGroundVC.swift
//  WXT_Parents
//
//  Created by JQ on 16/6/24.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class BabyShowGroundVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    let tableView = UITableView()
    var dataSourse = teacherList()

    override func viewDidLoad() {
        super.viewDidLoad()
        //  创建UI
        self.createUI()
        //  进行数据请求
        self.GETData()
    }
    func createUI() {
        self.tableView.frame = self.view.bounds
        self.view.addSubview(self.tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = RGBA(239, g: 239, b: 244, a: 1)
        //  注册cell
        self.tableView.registerClass(SchoolNoticeCell.self, forCellReuseIdentifier: "cell")

    }
    func GETData() {
        //  URL
        let url = kURL
        //  得到请求体需要的参数(通过沙盒取得学校id)
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let schoolId = userDefaults.stringForKey("schoolid")
        print(schoolId)
        //  请求体(字典)
        let param = ["m":"school","a":"getbabyinfos","schoolid":schoolId]

        //  进行请求
//        Alamofire.request(.GET, url, parameters: param as! [String:String]).response{
        Alamofire.request(.GET, url, parameters: param as![String:String]).response{ request, response, json, error in
            if error != nil{
                print(error)
            }else{
                //  得到请求状态
                
                let status = TeacherModel(JSONDecoder(json!))
                //  打印请求状态
                if status.status == "success"{
                    //  请求成功
                    print("请求成功")
                    //  填充数据源
                    self.dataSourse =  teacherList(status.data!)
                    //  刷新 UI
                    self.tableView.reloadData()
                }
                if status.status == "error"{
//                      进行延迟加载信息
                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.mode = MBProgressHUDMode.Text
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
            }
        }

       
            
            
        
        
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSourse.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SchoolNoticeCell
        cell.selectionStyle = .None
        //  进行cell的填充操作！！！
        let model = self.dataSourse.objectList[indexPath.row]
        
        
        
        cell.titleLabel.text = model.post_title

        let time = (model.post_dateL! as NSString).substringFromIndex(5)
            
        cell.timeLable.text = time
//        
        cell.contentLabel.numberOfLines = 0
        cell.contentLabel.text = model.post_excerpt
        
        let imageURL = microblogImageUrl + model.thumb!
        cell.headerImageView.sd_setImageWithURL(NSURL.init(string: imageURL), placeholderImage: UIImage(named: "1.png"))

        return cell
    }
     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        
        return 116
    }
    //    单元格点击事件
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let teacherInfo = self.dataSourse.objectList[indexPath.row]
        let id = teacherInfo.id
        let vc = TeacherInfoViewController()
        vc.id = id
        
        self.navigationController?.pushViewController(vc, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
