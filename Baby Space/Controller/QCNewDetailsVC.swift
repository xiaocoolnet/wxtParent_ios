//
//  QCNewDetailsVC.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/20.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class QCNewDetailsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var tableView = UITableView()
    var model : NoticeInfo?


    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        createTableView()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initUI(){
        self.tabBarController?.tabBar.hidden = true
        self.view.backgroundColor = RGBA(239, g: 239, b: 244, a: 1)
        self.title = "通知详情"
    }
    func createTableView(){
        tableView.frame = self.view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(QCNewDetailsCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
    }
    func GETData(){
        //
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 500
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? QCNewDetailsCell
        cell?.selectionStyle = .None
        //  内容
        cell?.contentLabel.text = model?.content
        //  老师
        cell?.teacherNameLabel.text = model?.username
        //  图片
        let imgUrl = microblogImageUrl + (model?.photo)!
        let photourl = NSURL(string: imgUrl)
        cell?.contentImageView.yy_setImageWithURL(photourl, placeholder: UIImage(named: "园所公告背景.png"))
        //  时间
        let date = NSDate(timeIntervalSince1970: NSTimeInterval((model?.create_time!)!)!)
        let dateformate = NSDateFormatter()
        dateformate.dateFormat = "yyyy-MM-dd HH:mm"
        let str:String = dateformate.stringFromDate(date)
        cell?.timeLabel.text = str
        //  头像
        let headerUrl = imageUrl + (model?.avatar)!
        let headerImage = NSURL(string: headerUrl)
        cell?.headerImageView.yy_setImageWithURL(headerImage, placeholder: UIImage(named: "园所公告背景.png"))
        print(model!.readcount)
        cell?.teacherTitleLabel.text = nil
        
        
        cell?.readLabel.text = "已阅读\(String(model!.readcount))"

        return cell!
    }
}
