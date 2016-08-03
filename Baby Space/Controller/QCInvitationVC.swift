//
//  QCInvitationVC.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/17.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import AddressBook
import AddressBookUI
import Alamofire


class QCInvitationVC: UIViewController,UITableViewDelegate,UITableViewDataSource,ABPeoplePickerNavigationControllerDelegate,UITextFieldDelegate {
    var tableView = UITableView()
    var cell = QCInvitationCell()
    var phoneTextField = UITextField()
    var nameTextField = UITextField()
    let relationshipLabel = UILabel()



    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
        createTableView()
        createButton()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tapAction(){
        //  自己的UI成为第一响应着
        self.view.becomeFirstResponder()
    }
    //  初始化界面
    func initUI(){
        self.title = "邀请家人"
        self.tabBarController?.tabBar.hidden = true
        self.view.backgroundColor = RGBA(239, g: 239, b: 244, a: 1)
    }
    //  创建tableview
    func createTableView(){
        
        tableView.rowHeight = 60
        tableView.frame = CGRectMake(0, 0, WIDTH, 240)
        tableView.scrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(QCInvitationCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        
    }
    //  创建添加按钮
    func createButton(){
        let button = UIButton()
        button.frame = CGRectMake(10, 340, WIDTH - 20, 40)
        button.setTitle("添加", forState: .Normal)
        button.cornerRadius = 5
        button.backgroundColor = RGBA(155, g: 229, b: 180, a: 1)
        button.addTarget(self, action: #selector(addAction), forControlEvents: .TouchUpInside)
        self.view.addSubview(button)
    }
    //  点击按钮处理操作
    func addAction(){
        print("完成添加")
        //  进行post请求
        //  http://wxt.xiaocool.net/index.php?g=apps&m=student&a=AddInviteFamily&studentid=597&parentname=随便&appellationid=5&phone=123123123
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let studentid = userDefaults.valueForKey("userid")
        print(studentid)
        let parentName = nameTextField.text
        let appellationid = relationshipLabel.text
        let phone = phoneTextField.text
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=AddInviteFamily"
        let pmara = ["studentid":studentid,"parentname":parentName,"appellationid":1,"phone":phone]
        POSTData(url, pmara: (pmara as? [String:NSObject])!)
        
    }

    //  上传姓名
    func POSTData(url:String,pmara:NSDictionary){
        
        
        Alamofire.request(.GET, url, parameters: pmara as? [String:AnyObject]).response { request, response, json, error in
            //  成功就提示添加成功
            if(error != nil){
                
            }
            else{
                print("request是")
                print(request!)
                print("====================")
                let status = Http(JSONDecoder(json!))
                print("状态是")
                print(status.status)
//                    alert(status.status!, delegate: self)
                if(status.status == "error"){
                    
//                    messageHUD(self.view, messageData: status.errorData!)
                    alert(status.errorData!, delegate: self)
 
                }
                if(status.status == "success"){
                    alert("邀请成功", delegate: self)
                    
                }

            //
            
        }
    }
}
    
//  MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? QCInvitationCell

        //  选择状态（不显示）
        cell!.selectionStyle = .None
        self.cell = cell!
        if indexPath.row == 0 {
            //  显示右侧的提示
            addLabel("家长姓名")
            
            nameTextField = addField("输入姓名")
            cell!.addSubview(nameTextField)
            return cell!

        }
        if indexPath.row == 1{
            cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

            addLabel("与宝宝的关系")
            relationshipLabel.frame = CGRectMake(120, 10, 60, 40)
            cell?.addSubview(relationshipLabel)
            return cell!

        }
        if indexPath.row == 2{
            addLabel("手机号")
            phoneTextField = addField("输入Ta的手机号")
            //  键盘失去第一响应
            cell!.addSubview(phoneTextField)


            addButton("电话", content_s: "电话", row: indexPath.row)
            return cell!

        }else{
            addLabel("是否绑定接送卡")
            addButton("灰", content_s: "绿", row: indexPath.row)
            return cell!

        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 1{
            //  push一个界面
            let chooseVC = QCChoosePersonVC()
            chooseVC.block = { (getRelationship) -> Void in
                self.relationshipLabel.text = getRelationship
            }
            self.navigationController?.pushViewController(chooseVC, animated: true)
        }else{
            //  啥都不干
        }
    }
//    MARK: - 添加cell上面的空间
    func addLabel(content:String){
        
        let label = UILabel()
        label.frame = CGRectMake(10, 10, 120, 40)
        label.text = content
        cell.addSubview(label)
    }
    func addField(content:String)->UITextField{
        
        let textField = UITextField()
        textField.frame = CGRectMake(120, 5, WIDTH - 180, 50)
        textField.placeholder = content
        
        //   打开手势交互
        textField.userInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(_:)))
        textField.addGestureRecognizer(tap)
        return textField
        
    }
    func addButton(content:String,content_s:String,row:Int){
        
        let button = UIButton()
        button.frame = CGRectMake(WIDTH - 45, 10, 40, 40)
        button.setImage(UIImage.init(named: content), forState: .Normal)
        button.selected = false
        button.setImage(UIImage.init(named: content_s), forState: .Selected)
        button.tag = row
        button.addTarget(self, action: #selector(buttonAction(_:)), forControlEvents: .TouchUpInside)
        cell.addSubview(button)
        
    }
    func buttonAction(sender:UIButton){
        if sender.tag == 2 {
            print(sender.tag)
            //  进行操作
            //  进入通讯录，选择号码
            let picker = ABPeoplePickerNavigationController()
            picker.peoplePickerDelegate = self
            self.presentViewController(picker, animated: true) { () -> Void in
                
            }

        }else{
            print(sender.tag)
            if sender.selected == false {
                sender.selected = true
            }else{
                sender.selected = false
            }
            //  进行操作
        }
    }

    
    //======================
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController,
                                          didSelectPerson person: ABRecord) {
//        //获取姓
//        let lastName = ABRecordCopyValue(person, kABPersonLastNameProperty).takeRetainedValue()
//            as! String
//        print("选中人的姓：\(lastName)")
//        
//        //获取名
//        let firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty).takeRetainedValue()
//            as! String
//        print("选中人的名：\(firstName)")
        
        //获取电话
        let phoneValues:ABMutableMultiValueRef? =
            ABRecordCopyValue(person, kABPersonPhoneProperty).takeRetainedValue()
        if phoneValues != nil {
            print("选中人电话：")
            for i in 0 ..< ABMultiValueGetCount(phoneValues){
                
                // 获得标签名
                let phoneLabel = ABMultiValueCopyLabelAtIndex(phoneValues, i).takeRetainedValue()
                    as CFStringRef;
                // 转为本地标签名（能看得懂的标签名，比如work、home）
                let localizedPhoneLabel = ABAddressBookCopyLocalizedLabel(phoneLabel)
                    .takeRetainedValue() as String
                
                let value = ABMultiValueCopyValueAtIndex(phoneValues, i)
                var phone = value.takeRetainedValue() as! String
                print("\(localizedPhoneLabel):\(phone)")
                if phone.characters.count != 11{
                    let ns1 = (phone as NSString).substringWithRange(NSMakeRange(0, 3))
                    let ns2 = (phone as NSString).substringWithRange(NSMakeRange(4, 4))
                    let ns3 = (phone as NSString).substringWithRange(NSMakeRange(9, 4))
                    phone = ns1 + ns2 + ns3
                }
                phoneTextField.text = phone
                
            }
            
        }
    }
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController,
                                          didSelectPerson person: ABRecord, property: ABPropertyID,
                                                          identifier: ABMultiValueIdentifier) {
        
    }
    
    //取消按钮点击
    func peoplePickerNavigationControllerDidCancel(peoplePicker: ABPeoplePickerNavigationController) {
        //去除地址选择界面
        peoplePicker.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController,
                                          shouldContinueAfterSelectingPerson person: ABRecord) -> Bool {
        return true
    }
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController,
                                          shouldContinueAfterSelectingPerson person: ABRecord, property: ABPropertyID,
                                                                             identifier: ABMultiValueIdentifier) -> Bool {
        return true
    }
    
    //  失去第一响应
    func tapAction(tap:UITapGestureRecognizer){
        self.view.endEditing(true)
    }

    
}
