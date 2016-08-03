//
//  QCChoosePersonVC.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/17.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
typealias Black=(content:String)->Void

class QCChoosePersonVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    var tableView = UITableView()
    var cell = UITableViewCell()
    var contentArr : NSArray!
    let textField = UITextField()
    var getRelationship : String!
    var block:Black!

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
        //   添加一个右按钮
        let sureButton = UIButton()
        sureButton.frame = CGRectMake(0,  0,  40, 20)
        sureButton.setTitle("保存", forState: .Normal)
        sureButton.addTarget(self, action: #selector(ChangeValue), forControlEvents: .TouchUpInside)
        let rightButton = UIBarButtonItem(customView: sureButton)
        self.navigationItem.rightBarButtonItem = rightButton
        
        self.title = "关系列表"
        self.view.backgroundColor = RGBA(239, g: 239, b: 244, a: 1)
        self.tabBarController?.tabBar.hidden = true
    }
    func ChangeValue(){
        //   得到选择到的关系
        print("得到的关系")
        if getRelationship == nil {
            getRelationship = textField.text!
        }
        print(getRelationship)
        if block != nil {
            block(content: getRelationship)
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    func createTableView(){
        //
        tableView.rowHeight = 60
        tableView.frame = CGRectMake(0, 0, WIDTH, 420)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.scrollEnabled = false
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.view.addSubview(tableView)
    }
    
//    MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
//        cell.selectionStyle = .Default
        self.cell = cell
        contentArr = ["爷爷","奶奶","叔叔","阿姨","姥姥","姥爷","自定义"]
        for i in 0...contentArr.count{
            if indexPath.row == i {
                addLabel(contentArr[i] as! String)
            }
        }
        if indexPath.row == 6 {
            addfield("请输入与宝宝的关系")
            textField.delegate = self
            //  添加通知中心
        }
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //  需要把这个传过去
        if indexPath.row != 6{
            getRelationship = nil
            getRelationship = contentArr[indexPath.row] as! String
            //  添加一个表示
            
        }else{
        }
        
        
    }
    func addLabel(content:String){
        
        let label = UILabel()
        label.frame = CGRectMake(10, 10, 60, 40)
        label.text = content
        cell.addSubview(label)
        
    }
    func addfield(content:String){
        
        textField.frame = CGRectMake(WIDTH / 2, 5, WIDTH / 2, 50)
        textField.placeholder = content

        cell.addSubview(textField)
    }
    //  键盘的代理方法
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.isFirstResponder() {
            getRelationship = nil
        }
    }

}
