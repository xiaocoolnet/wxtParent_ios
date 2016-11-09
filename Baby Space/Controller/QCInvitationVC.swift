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
import MBProgressHUD
import MessageUI


class QCInvitationVC: UIViewController,UITableViewDelegate,UITableViewDataSource,ABPeoplePickerNavigationControllerDelegate,UITextFieldDelegate,UIActionSheetDelegate , UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMessageComposeViewControllerDelegate
{
    var tableView = UITableView()
    var cell = QCInvitationCell()
    var phoneTextField = UITextField()
    var nameTextField = UITextField()
    let relationshipLabel = UILabel()
    
    var data = NSData()
    
    
    var changeImage = UIImageView()

    var myActionSheet:UIAlertController?
    
    var img = UIImageView()
    var hud = MBProgressHUD()
    
    var imageName = String()
    let invite = UIView()
    

    override func viewWillAppear(animated: Bool) {
//        self.createTableView()
    }

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
        tableView.frame = CGRectMake(0, 0, WIDTH, 300)
        tableView.scrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(QCInvitationCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        
    }
    //  创建添加按钮
    func createButton(){
        let button = UIButton()
        button.frame = CGRectMake(10, 350, WIDTH - 20, 40)
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
        let studentid = userDefaults.valueForKey("chid")
        print(studentid)
        let parentName = nameTextField.text
        let appellation = relationshipLabel.text
        let phone = phoneTextField.text
        
        
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=AddInviteFamily"
        let pmara = ["studentid":studentid,"parentname":parentName,"appellation":appellation,"phone":phone,"photo":imageName]
        if parentName == "" || appellation == "" || phone == "" {
            messageHUD(self.view, messageData: "请补全信息")
        }else{
            POSTData(url, pmara: (pmara as? [String:NSObject])!)
            
        }
        
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
                    self.nameTextField.resignFirstResponder()
                    self.phoneTextField.resignFirstResponder()
//                    alert("邀请成功", delegate: self)
                    self.createView()

                }

            //
            
        }
    }
}
    
//  MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? QCInvitationCell

        //  选择状态（不显示）
        cell!.selectionStyle = .None
        self.cell = cell!
        
        if indexPath.row == 0 {
            cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            let tit = UILabel()
            tit.frame = CGRectMake(10, 15, 100, 30)
            tit.text = "头像上传"
            cell?.contentView.addSubview(tit)
            
//            img = UIImageView()
            img.frame = CGRectMake(WIDTH - 80, 10, 40, 40)
            cell?.contentView.addSubview(img)
            
            
        }
        if indexPath.row == 1 {
            //  显示右侧的提示
            addLabel("家长姓名")
            
            nameTextField = addField("输入姓名")
            cell!.addSubview(nameTextField)
            return cell!

        }
        if indexPath.row == 2{
            cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

            addLabel("与宝宝的关系")
            relationshipLabel.frame = CGRectMake(120, 10, 60, 40)
            cell?.addSubview(relationshipLabel)
            return cell!

        }
        if indexPath.row == 3{
            addLabel("手机号")
            phoneTextField = addField("输入Ta的手机号")
            //  键盘失去第一响应
            cell!.addSubview(phoneTextField)


            addButton("电话", content_s: "电话", row: indexPath.row)
            return cell!

        }
        if indexPath.row == 4{
            addLabel("是否绑定接送卡")
            addButton("灰", content_s: "绿", row: indexPath.row)
            return cell!

        }
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 2{
            //  push一个界面
            let chooseVC = QCChoosePersonVC()
            chooseVC.block = { (getRelationship) -> Void in
                self.relationshipLabel.text = getRelationship
                print("$$$$$$$")
                print(self.relationshipLabel.text)
               tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
            }
            self.navigationController?.pushViewController(chooseVC, animated: true)
        }else if indexPath.row == 0{
            
            let cancelAction = UIAlertAction(title: "取消",style:UIAlertActionStyle.Cancel){
                (UIAlertAction) -> Void in
            }
            //  1.相册
            let GoImageAl = UIAlertAction(title: "相册",style: UIAlertActionStyle.Default){
                (UIAlertAction) -> Void in
                self.LocalPhoto()
            }
            //  2.相机
            let GoCameraAl = UIAlertAction(title: "相机",style: UIAlertActionStyle.Default){
                (UIAlertAction) -> Void in
                self.takePhoto()
            }
            
            //    把上述的三种情况添加到我的提示框中
            let actionSheet = UIAlertController(title: "选择图片", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
            actionSheet.addAction(cancelAction)
            actionSheet.addAction(GoCameraAl)
            actionSheet.addAction(GoImageAl)
            self.presentViewController(actionSheet, animated: true, completion: nil)
            phoneTextField.resignFirstResponder()
        }
    }
    
    func takePhoto(){
        let sourceType = UIImagePickerControllerSourceType.Camera
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = sourceType
            self.presentViewController(picker, animated: true, completion: nil)
        }else{
            print("无法打开相机")
        }
    }
    
    func LocalPhoto(){
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)
    }
    // MARK: ------imagepickerDelegate-------
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let type = info[UIImagePickerControllerMediaType] as! String
        if type != "public.image" {
            return
        }
        //裁剪后图片
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        let data = UIImageJPEGRepresentation(image, 0.1)!
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let dateStr = dateFormatter.stringFromDate(NSDate())
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let pic = userDefaults.valueForKey("userid")

        self.imageName = dateStr + (pic as! String)
        ConnectModel.uploadWithImageName(imageName, imageData: data, URL: "WriteMicroblog_upload") { [unowned self] (data) in
            dispatch_async(dispatch_get_main_queue(), {
                let result = Http(JSONDecoder(data))
                if result.status != nil {
                    if result.status! == "success"{
                        self.imageName = (result.data?.string!)!
//                        TCUserInfo.currentInfo.avatar = imageName!
                        print("修改成功")
                    }else{
//                        SVProgressHUD.showErrorWithStatus("图片上传失败")
                    }
                }
            })
        }
        self.img.image = image
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        
        picker.dismissViewControllerAnimated(true, completion: nil)
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
        textField.delegate = self
        textField.returnKeyType = .Done
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

    
    func createView(){
        
        invite.frame = CGRectMake(0, 0, WIDTH, HEIGHT)
        invite.backgroundColor = UIColor.init(white: 0, alpha: 0.6)
//        invite.alpha = 0.6
        self.view.window!.addSubview(invite)
        
        let view = UIView()
        view.frame = CGRectMake(60, 150, WIDTH - 120, HEIGHT - 300)
        view.backgroundColor = UIColor.whiteColor()
        invite.addSubview(view)
        let width = view.frame.size.width
//        let height = view.frame.size.height
        
        
        let tit = UILabel()
        tit.frame = CGRectMake(20, 20, width - 40, 40)
        tit.text = "添加成功"
        tit.textColor = UIColor(red: 155/255, green: 229/255, blue: 180/255, alpha: 1)
        tit.textAlignment = NSTextAlignment.Center
        view.addSubview(tit)
        
        let pho = UILabel()
        pho.frame = CGRectMake(30, 80, 120, 30)
        pho.text = "Ta的帐号："
        view.addSubview(pho)
        
        let num = UILabel()
        num.frame = CGRectMake(155, 80, width - 165, 30)
        num.text = phoneTextField.text
        view.addSubview(num)
        
        let mima = UILabel()
        mima.frame = CGRectMake(30, 120, 120, 30)
        mima.text = "Ta的帐号："
        view.addSubview(mima)
        
        let number = UILabel()
        number.frame = CGRectMake(155, 120, width - 165, 30)
        number.text = "123"
        view.addSubview(number)
        
        let weiBtn = UIButton()
        weiBtn.frame = CGRectMake(30, 170, width - 60, 30)
        weiBtn.backgroundColor = UIColor(red: 155/255, green: 229/255, blue: 180/255, alpha: 1)
        weiBtn.setTitle("微信告知", forState: .Normal)
        weiBtn.addTarget(self, action: #selector(self.weiClickBtn), forControlEvents: .TouchUpInside)
        view.addSubview(weiBtn)
        
        let phoneBtn = UIButton()
        phoneBtn.frame = CGRectMake(30, 220, width - 60, 30)
        phoneBtn.backgroundColor =
            UIColor(red: 155/255, green: 229/255, blue: 180/255, alpha: 1)
        phoneBtn.setTitle("短信告知", forState: .Normal)
        phoneBtn.addTarget(self, action: #selector(self.phoneClickBtn), forControlEvents: .TouchUpInside)
        view.addSubview(phoneBtn)
        
        let backBtn = UIButton()
        backBtn.frame = CGRectMake(30, 270, width - 60, 30)
        backBtn.backgroundColor = UIColor(red: 155/255, green: 229/255, blue: 180/255, alpha: 1)
        backBtn.setTitle("取消", forState: .Normal)
        backBtn.addTarget(self, action: #selector(self.backClickBtn), forControlEvents: .TouchUpInside)
        view.addSubview(backBtn)
        
        
    }
    
    func phoneClickBtn() {
        if MFMessageComposeViewController.canSendText(){
            let controller = MFMessageComposeViewController()
            let userDefaults = NSUserDefaults.standardUserDefaults()
            let student = userDefaults.valueForKey("chidname")
            controller.body = "\(student)的\(relationshipLabel.text)，在“智校园”中可以关注\(student)的最新照片！安装应用并使用账号\(self.phoneTextField.text)，密码123进行查看。下载地址http：http://t.cn/RtD7IJB"
            controller.recipients = phoneTextField.text!.componentsSeparatedByString(",")
            controller.messageComposeDelegate = self
            self.presentViewController(controller, animated: true, completion: nil)
        } else {
            let alert = UIAlertView(title: "提示信息", message: "本设备不能发短信", delegate: nil, cancelButtonTitle: "确定")
            alert.show()
        }
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        
        controller.dismissViewControllerAnimated(true, completion: nil)
        
//        switch result.value{
//        case MessageComposeResultSent.value:
//            result.text = "短信已发送"
//        case MessageComposeResultCancelled.value:
//            result.text = "短信已取消"
//        case MessageComposeResultFailed.value:
//            result.text = "短信发送失败"
//        default:
//            break
//        }
    }

    
    func weiClickBtn() {
        let shareParames = NSMutableDictionary()
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let student = userDefaults.valueForKey("chidname")
        shareParames.SSDKSetupShareParamsByText("\(student)的\(relationshipLabel.text)，在“智校园”中可以关注\(student)的最新照片！安装应用并使用账号\(self.phoneTextField.text)，密码123进行查看。下载地址http：http://t.cn/RtD7IJB",
                                                images : nil,
                                                url : nil,
                                                title : "\(student)的\(relationshipLabel.text)，在“智校园”中可以关注\(student)的最新照片！安装应用并使用账号\(self.phoneTextField.text)，密码123进行查看。下载地址http：http://t.cn/RtD7IJB",
                                                type : SSDKContentType.Text)
        

            if WXApi.isWXAppInstalled() {
                //微信好友分享
                ShareSDK.share(SSDKPlatformType.SubTypeWechatSession , parameters: shareParames) { (state : SSDKResponseState, userData : [NSObject : AnyObject]!, contentEntity :SSDKContentEntity!, error : NSError!) -> Void in
                    switch state{
                        
                    case SSDKResponseState.Success:
                        print("分享成功")
                        let alert = UIAlertView(title: "分享成功", message: "分享成功", delegate: self, cancelButtonTitle: "确定")
                        alert.show()
                        
                    case SSDKResponseState.Fail:  print("分享失败,错误描述:\(error)")
                    case SSDKResponseState.Cancel:  print("分享取消")
                        
                    default:
                        break
                    }
                }
            }else{
                let alertView = UIAlertView.init(title:"提示" , message: "没有安装微信", delegate: self, cancelButtonTitle: "确定")
                alertView.show()
                
            }

    }
    
    func backClickBtn() {
        self.invite.removeFromSuperview()
        self.navigationController?.popViewControllerAnimated(true)
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
    
    func textFieldDidEndEditing(textField: UITextField) {
        nameTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }
    
    //    收键盘
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}
