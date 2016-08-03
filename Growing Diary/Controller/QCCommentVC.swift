//
//  QCCommentVC.swift
//  WXT_Parents
//
//  Created by JQ on 16/6/29.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
//import

class QCCommentVC: UIViewController {
    //  数据源
    var dataSource = QCCommentInfo()
    //  tableView
    var tableView =  UITableView()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //  初始化 UI 
        createUI()
        //  进行数据请求
        GETComment()
    }
    // MARK: - 初始化UI列表
    func createUI(){
//        self.tableView
        
        
    }
    // MARK: - 得到评论的列表
    func GETComment(){
        
    }
    // MARK: - 得到评论的列表
    func deleteComment(){
        
    }
    
    // MARK: - tableView 的三个代理方法
    
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
