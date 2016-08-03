//
//  CDPLViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/5/31.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class CDPLViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var id:String?
    var commentSource :HCommentList?
    
    let table = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "评论列表"
        self.view.backgroundColor = UIColor.whiteColor()
//        发表评论
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(CDPLViewController.writeComment))
        self.createTable()
    }
    //    写评论
    func writeComment(){
        let vc = CDWirteCommentViewController()
//        vc.id = self.id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //    创建表
    func createTable(){
        table.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)
        table.delegate = self
        table.dataSource = self
        self.view.addSubview(table)
//        注册cell
        table.registerNib(UINib.init(nibName: "HCommentTableViewCell", bundle: nil), forCellReuseIdentifier: "HCommentCell")
    }
    //    有几行
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return (self.commentSource?.count)!
        return 3
    }
    //    单元格
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HCommentCell", forIndexPath: indexPath) as! HCommentTableViewCell
        cell.selectionStyle = .None
//        let hCommentInfo = self.commentSource?.commentlist[indexPath.row]
//        cell.updateCellWithHCommentInfo(hCommentInfo!)
        
        return cell
    }
    //    单元格高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        let hCommentInfo = self.commentSource?.commentlist[indexPath.row]
//        //        自适应行高
//        let options : NSStringDrawingOptions = NSStringDrawingOptions.UsesLineFragmentOrigin
//        let screenBounds:CGRect = UIScreen.mainScreen().bounds
//        let boundingRect = String(hCommentInfo?.content).boundingRectWithSize(CGSizeMake(screenBounds.width, 0), options: options, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(17)], context: nil)
//        return boundingRect.size.height + 210
        return 230
    }

}
