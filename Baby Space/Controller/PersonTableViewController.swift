//
//  PersonTableViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/6/13.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import XWSwiftRefresh

class PersonTableViewController: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate {

    var data = NSData()
    
    var hud = MBProgressHUD()
    
    var dataSource = personList()
    
    
    var changeImage = UIImageView()
    
    @IBOutlet var tableSource: UITableView!
//    宝宝头像
    @IBOutlet weak var headImgaeView: UIImageView!
//   宝宝头像按钮
    @IBOutlet weak var headBtn: UIButton!
//    姓名
    @IBOutlet weak var nameTextField: UITextField!
//    性别
    @IBOutlet weak var sexTextField: UITextField!
//    班级
    @IBOutlet weak var classTextField: UITextField!
//    生日
    @IBOutlet weak var birthdayTextField: UITextField!
//    爱好
    @IBOutlet weak var aiHaoTextField: UITextField!
//    家庭住址
    @IBOutlet weak var addressTextField: UITextField!
//    上学接送
    @IBOutlet weak var jieTextField: UITextField!
//    全家福添加按钮
    @IBOutlet weak var familyBtn: UIButton!
//    全家福
    @IBOutlet weak var famImageView: UIImageView!
//    妈妈头像
    @IBOutlet weak var mHeadImageView: UIImageView!
//    妈妈头像按钮
    @IBOutlet weak var MHeadBtn: UIButton!
//    妈妈姓名
    @IBOutlet weak var mNameTextField: UITextField!
//    妈妈职业
    @IBOutlet weak var workTextField: UITextField!
//    妈妈联系电话
    @IBOutlet weak var mPhoneTextField: UITextField!
//    最喜欢和妈妈一起做什么
    @IBOutlet weak var motherTextField: UITextField!
//    爸爸头像
    @IBOutlet weak var fHeadImageView: UIImageView!
//    爸爸头像按钮
    @IBOutlet weak var fHeadBtn: UIButton!
//    爸爸姓名
    @IBOutlet weak var fNameTextField: UITextField!
//    爸爸职业
    @IBOutlet weak var fWorkTextField: UITextField!
//    爸爸的联系电话
    @IBOutlet weak var fPhoneTextField: UITextField!
//    最喜欢和爸爸一起做什么
    @IBOutlet weak var fatherTextField: UITextField!
    
    var imageName = String()
    
    override func viewWillAppear(animated: Bool) {
        self.getData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //  创建UI界面
        //  请求数据
        self.getData()

        //  给控件赋值
        
        //  刷新UI界面
        birthdayTextField.delegate = self
        birthdayTextField.tag = 1
        aiHaoTextField.delegate = self
        aiHaoTextField.tag = 2
        jieTextField.delegate = self
        jieTextField.tag = 3
        addressTextField.delegate = self
        addressTextField.tag = 4
        workTextField.delegate = self
        workTextField.tag = 5
        motherTextField.delegate = self
        motherTextField.tag = 6
        fWorkTextField.delegate = self
        fatherTextField.delegate = self
        fWorkTextField.tag = 7
        fatherTextField.tag = 8
    }
    //  修改自己头像
    @IBAction func headBtn(sender: AnyObject) {
        print("headBtn")
        //  更改图片
        self.changeHeaderImage(headImgaeView)
    }

    //  修改家庭头像
    @IBAction func familyBtn(sender: AnyObject) {
        print("familyBtn")
        print(sender)
        self.changeHeaderImage(famImageView)

    }
    //  修改妈妈头像
    @IBAction func mHeadBtn(sender: AnyObject) {
        print("mHeadBtn")
        print(sender)
        self.changeHeaderImage(mHeadImageView)

    }
    //  修改爸爸头像
    @IBAction func fHeadBtn(sender: AnyObject) {
        print("fHeadBtn")
        self.changeHeaderImage(fHeadImageView)

    }
    
    func getBirthDate() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var date = NSDate()
        print("@#$%$#@#$")
        print(birthdayTextField.text)
        date = dateFormatter.dateFromString(birthdayTextField.text!)!
        //  获取当前时间戳
        let timeInterval:NSTimeInterval = date.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        print("当前时间的时间戳：\(timeStamp)")

//        http://wxt.xiaocool.net/index.php?g=apps&m=student&a=UpdateHobby&studentid=661&birthday=1462712324
        let defalutid = NSUserDefaults.standardUserDefaults()
        let sid = defalutid.stringForKey("chid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=UpdateBirth"
        let param = [
            "studentid":sid!,
            "birthday":timeStamp
            ]
        Alamofire.request(.GET, url, parameters: param as? [String : AnyObject]).response { request, response, json, error in
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

                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.mode = MBProgressHUDMode.Text;
                    hud.labelText = "修改成功"
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                    self.tableSource.reloadData()
                    self.getData()
                }
            }
        }

        
        
    }
    
//    分区数 (段数据)
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
//    每个分区的cell数 (行数据)
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
//    分区头的高度
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
//    分区的视图
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let lbl = UILabel(frame: CGRectMake(10,11,WIDTH-20,20))
            lbl.text = "   宝宝信息"
            lbl.textColor = RGBA(96.0, g: 96.0, b: 96.0, a: 1)
            return lbl
        }
        if section == 1 {
            let lbl = UILabel(frame: CGRectMake(10,11,WIDTH-20,20))
            lbl.text = "  家长信息"
            lbl.textColor = RGBA(96.0, g: 96.0, b: 96.0, a: 1)
            return lbl
        }
        return nil
    }
    
    
    func textFieldDidEndEditing(textField: UITextField){
        if textField.tag == 1 {
            self.getBirthDate()
        }
        if textField.tag == 2 {
            self.aihaoDate()
        }
        if textField.tag == 3 {
            self.jieDate()
        }
        if textField.tag == 4 {
            self.addressDate()
        }
        if textField.tag == 5 {
            self.workDate()
        }
        if textField.tag == 6 {
            self.motherDate()
        }
        if textField.tag == 7 {
            self.fworkDate()
        }
        if textField.tag == 8 {
            self.fatherDate()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.tag == 1 {
            self.getBirthDate()
            return true
        }
        if textField.tag == 2 {
            self.aihaoDate()
            return true
        }
        if textField.tag == 3 {
            self.jieDate()
            return true
        }
        if textField.tag == 4 {
            self.addressDate()
            return true
        }
        if textField.tag == 5 {
            self.workDate()
            return true
        }
        if textField.tag == 6 {
            self.motherDate()
            return true
        }
        if textField.tag == 7 {
            self.fworkDate()
            return true
        }
        if textField.tag == 8 {
            self.fatherDate()
            return true
        }
        textField.resignFirstResponder()
        return true
    }
    //  更改图片
    func changeHeaderImage(image:UIImageView){
        let cancelAction = UIAlertAction(title: "取消",style:UIAlertActionStyle.Cancel){
            (UIAlertAction) -> Void in
            self.dismissViewControllerAnimated(true,completion: nil)
        }
        
        //  1.相册
        let GoImageAl = UIAlertAction(title: "照片",style: UIAlertActionStyle.Default){
            (UIAlertAction) -> Void in
            self.GoImage(image)
        }
        //  2.相机
        let GoCameraAl = UIAlertAction(title: "相机",style: UIAlertActionStyle.Default){
            (UIAlertAction) -> Void in
            self.GoCamera(image)
        }
        
        //    把上述的三种情况添加到我的提示框中
        let actionSheet = UIAlertController(title: "选择图片", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(GoCameraAl)
        actionSheet.addAction(GoImageAl)
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    
    func GoImage(image:UIImageView){
        let pickerImage = UIImagePickerController()
        //  得到视图
        
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            pickerImage.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            pickerImage.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(pickerImage.sourceType)!
        }
        pickerImage.delegate = self
        pickerImage.allowsEditing = true
//        self.presentViewController(pickerImage, animated: true, completion: nil)
        self.presentViewController(pickerImage, animated: true) { 
            self.changeImage = image
        }
        
    }
    func GoCamera(image:UIImageView){
        var sourceType = UIImagePickerControllerSourceType.Camera
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        let picker = UIImagePickerController()
        //picker.delegate = self
        
        picker.delegate = self
        picker.allowsEditing = true//设置可编辑
        picker.sourceType = sourceType
//        self.presentViewController(picker, animated: true, completion: nil)//进入照相界面
        self.presentViewController(picker, animated: true) { 
            self.changeImage = image
        }
    }
    //
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        //裁剪后图片
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        let data = UIImageJPEGRepresentation(image, 0.1)!
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let dateStr = dateFormatter.stringFromDate(NSDate())
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let pic = userDefaults.valueForKey("chid")
        
        self.imageName = dateStr + (pic as! String)
//        http://wxt.xiaocool.net/index.php?g=apps&m=index&a=
        ConnectModel.uploadWithImageName(imageName, imageData: data, URL: "WriteMicroblog_upload") { [unowned self] (data) in
            dispatch_async(dispatch_get_main_queue(), {
                let result = Http(JSONDecoder(data))
                if result.status != nil {
                    if result.status! == "success"{
                        self.imageName = (result.data?.string!)!
                        print(self.imageName)
                        //                        TCUserInfo.currentInfo.avatar = imageName!
                        print("修改成功")
                        
                        self.picDate()
                        
                    }else{
                        //                        SVProgressHUD.showErrorWithStatus("图片上传失败")
                        print("修改失败")
                    }
                }
            })
        }
        //  谁的图片需要修改
        self.changeImage.image = image
        
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    //取消之后
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    //  爱好
    func aihaoDate(){
        let defalutid = NSUserDefaults.standardUserDefaults()
        let sid = defalutid.stringForKey("chid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=UpdateHobby"
        let param = [
            "studentid":sid!,
            "hobby":self.aiHaoTextField.text
        ]
        Alamofire.request(.GET, url, parameters: param as? [String : String]).response { request, response, json, error in
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
                    
                    self.aiHaoTextField.resignFirstResponder()
                }
            }
        }

    }
    // 接送人
    func jieDate(){
        let defalutid = NSUserDefaults.standardUserDefaults()
        let sid = defalutid.stringForKey("chid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=UpdateDelivery"
        let param = [
            "studentid":sid!,
            "delivery":self.jieTextField.text
        ]
        Alamofire.request(.GET, url, parameters: param as? [String : String]).response { request, response, json, error in
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
                    
                    self.jieTextField.resignFirstResponder()
                }
            }
        }

    }
    
    //
    func addressDate(){
        let defalutid = NSUserDefaults.standardUserDefaults()
        let sid = defalutid.stringForKey("chid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=UpdateDelivery"
        let param = [
            "studentid":sid!,
            "delivery":self.addressTextField.text
        ]
        Alamofire.request(.GET, url, parameters: param as? [String : String]).response { request, response, json, error in
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
                    
                   self.addressTextField.resignFirstResponder()
                }
            }
        }
        
    }
    // 妈妈职业
    func workDate(){
        let defalutid = NSUserDefaults.standardUserDefaults()
        let sid = defalutid.stringForKey("chid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=UpdateMoProfession"
        
        let param = [
            "studentid":sid!,
            "motherpro":self.workTextField.text
        ]
        GetName(url, param: (param as? [String:String])!)
        self.workTextField.resignFirstResponder()
    }
    // 喜欢和妈妈做的事
    func motherDate(){
        let defalutid = NSUserDefaults.standardUserDefaults()
        let sid = defalutid.stringForKey("chid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=UpdateWithMother"
        let param = [
            "studentid":sid!,
            "withmother":self.motherTextField.text
        ]
        GetName(url, param: (param as? [String:String])!)
        self.motherTextField.resignFirstResponder()
    }
    // 爸爸职业
    func fworkDate(){
        let defalutid = NSUserDefaults.standardUserDefaults()
        let sid = defalutid.stringForKey("chid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=UpdateFaProfession"
        let param = [
            "studentid":sid!,
            "fatherpro":self.fWorkTextField.text
        ]
        GetName(url, param: (param as? [String:String])!)
        self.fWorkTextField.resignFirstResponder()
    }
    
    // 喜欢和父亲做的事
    func fatherDate(){
        let defalutid = NSUserDefaults.standardUserDefaults()
        let sid = defalutid.stringForKey("chid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=UpdateWithFather"
        let param = [
            "studentid":sid!,
            "withfather":self.fatherTextField.text
        ]
        GetName(url, param: (param as? [String:String])!)
        self.fatherTextField.resignFirstResponder()
    }
    
    //
    func picDate(){
        let defalutid = NSUserDefaults.standardUserDefaults()
        let sid = defalutid.stringForKey("chid")
        var param = NSMutableDictionary()
        var url = String()
        
        let model = self.dataSource.objectlist[0]
        var idStr = String()
        var idStr1 = String()
        if model.parentinfo.count == 1 {
            if model.parentinfo[0].parent_sex == "1" {
                idStr = model.parentinfo[0].parentid
            }else{
                idStr1 = model.parentinfo[0].parentid
            }
        }else if model.parentinfo.count >= 2{
            var mother = Array<parentinfoInfo>()
            var fatherArr = Array<parentinfoInfo>()
            for i in 0...model.parentinfo.count - 1 {
                let sex = model.parentinfo[i].parent_sex
                if sex == "1" {
                    fatherArr.append(model.parentinfo[i])
                }else{
                    mother.append(model.parentinfo[i])
                }
            }
            if mother.count != 0 {
                
                idStr1 = mother[0].parentid
            }
            if fatherArr.count != 0 {
                
                idStr = fatherArr[0].parentid
            }
            print("!@#$%^&*()(*&^%$#@#$%^&")
            print(idStr)
            print(idStr1)
        }
        
        if self.changeImage == famImageView{
            url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=UpdatePhoto"
            param = [
                "studentid":sid!,
                "photo":self.imageName
            ]
            
        }else if self.changeImage == headImgaeView{
            url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=UpdateUserAvatar"
            param = [
                "userid":sid!,
                "avatar":self.imageName
            ]
        }else if self.changeImage == fHeadImageView{
            url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=UpdateUserAvatar"
            param = [
                "userid":idStr,
                "avatar":self.imageName
            ]
        }else if self.changeImage == mHeadImageView{
            url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=UpdateUserAvatar"
            param = [
                "userid":idStr1,
                "avatar":self.imageName
            ]
        }
        
        GetName(url, param: (param))
        self.getData()
//        self.tableSource.reloadData()
    }


    //  上传
    func GetName(url:String,param:NSDictionary){
        
        
        Alamofire.request(.GET, url, parameters: param as? [String:String]).response { request, response, json, error in
            
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
                    
                    //                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
        }

    }
    
    func getData(){
        //  http://wxt.xiaocool.net/index.php?g=apps&m=student&a=GetBabyInfo&studentid=661
        //下面两句代码是从缓存中取出userid（入参）值
        let defalutid = NSUserDefaults.standardUserDefaults()
        let sid = defalutid.stringForKey("chid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=GetBabyInfo"
        let param = [
            "studentid":sid!,
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
                    messageHUD(self.view, messageData: status.errorData!)
                }
                if(status.status == "success"){
                    self.dataSource = personList(status.data!)
                    self.tableSource.reloadData()
                    self.tableSource.headerView?.endRefreshing()
                    self.create()
                }
            }
        }

    }
    
    func create(){
        let model = self.dataSource.objectlist[0]
        let pic = model.avatar
        let imgUrl = microblogImageUrl + pic!
        let photourl = NSURL(string: imgUrl)
        headImgaeView.sd_setImageWithURL(photourl, placeholderImage: UIImage(named: "Logo"))
        
        nameTextField.text = model.name
        aiHaoTextField.text = model.hobby
        if model.sex! == "1" {
            sexTextField.text = "男"
        }else{
            sexTextField.text = "女"
        }
        
        addressTextField.text = model.address
        jieTextField.text = model.delivery
        let familfPic = model.photo
        let familyUrl = microblogImageUrl + familfPic!
        let imUrl = NSURL(string: familyUrl)
        famImageView.sd_setImageWithURL(imUrl, placeholderImage: UIImage(named: "Logo"))
        
        let dateformate = NSDateFormatter()
        dateformate.dateFormat = "yyyy-MM-dd"
        let date = NSDate(timeIntervalSince1970: NSTimeInterval(model.birthday!)!)
        let str:String = dateformate.stringFromDate(date)
        birthdayTextField.text = str
        
        if model.parentinfo.count == 1 {
            if model.parentinfo[0].parent_sex == "1" {
                fNameTextField.text = model.parentinfo[0].parent_name
                fWorkTextField.text = model.fatherpro
                fPhoneTextField.text = model.parentinfo[0].parent_phone
                fatherTextField.text = model.withfather
                let pic = model.parentinfo[0].parent_photo
                let imgUrl = microblogImageUrl + pic
                let photourl = NSURL(string: imgUrl)
                fHeadImageView.sd_setImageWithURL(photourl, placeholderImage: UIImage(named: "Logo"))
                mNameTextField.text = "无"
                workTextField.text = "无"
                motherTextField.text = "无"
                mHeadImageView.image = UIImage(named: "Logo")
                mPhoneTextField.text = "无"
                let view = UIView()
                view.backgroundColor = UIColor.clearColor()
                view.frame = CGRectMake(0, 667, WIDTH, 300)
                self.tableSource.addSubview(view)
                
            }else{
                mNameTextField.text = model.parentinfo[0].parent_name
                workTextField.text = model.motherpro
                mPhoneTextField.text = model.parentinfo[0].parent_phone
                motherTextField.text = model.withmother
                let pic = model.parentinfo[0].parent_photo
                let imgUrl = microblogImageUrl + pic
                let photourl = NSURL(string: imgUrl)
                mHeadImageView.sd_setImageWithURL(photourl, placeholderImage: UIImage(named: "Logo"))
                fNameTextField.text = "无"
                fWorkTextField.text = "无"
                fatherTextField.text = "无"
                fHeadImageView.image = UIImage(named: "Logo")
                fPhoneTextField.text = "无"
                let view = UIView()
                view.backgroundColor = UIColor.clearColor()
                view.frame = CGRectMake(0, 970, WIDTH, 310)
                self.tableSource.addSubview(view)
            }
            
        }else if model.parentinfo.count == 0{
            mNameTextField.text = "无"
            workTextField.text = "无"
            motherTextField.text = "无"
            mHeadImageView.image = UIImage(named: "Logo")
            mPhoneTextField.text = "无"
            fNameTextField.text = "无"
            fWorkTextField.text = "无"
            fatherTextField.text = "无"
            fHeadImageView.image = UIImage(named: "Logo")
            fPhoneTextField.text = "无"
            let view = UIView()
            view.backgroundColor = UIColor.clearColor()
            view.frame = CGRectMake(0, 667, WIDTH, 610)
            self.tableSource.addSubview(view)

        }else{
            var mother = Array<parentinfoInfo>()
            var fatherArr = Array<parentinfoInfo>()
            for i in 0...model.parentinfo.count - 1 {
                let sex = model.parentinfo[i].parent_sex
                if sex == "0" {
                    mother.append(model.parentinfo[i])
                }else{
                    fatherArr.append(model.parentinfo[i])
                }
                
            }
            if mother.count != 0 {
                
                mPhoneTextField.text = mother[0].parent_phone
                mNameTextField.text = mother[0].parent_name
                workTextField.text = model.motherpro
                motherTextField.text = model.withmother
                let pic = mother[0].parent_photo
                let imgUrl = microblogImageUrl + pic
                let photourl = NSURL(string: imgUrl)
                mHeadImageView.sd_setImageWithURL(photourl, placeholderImage: UIImage(named: "Logo"))
            }else{
                mNameTextField.text = "无"
                workTextField.text = "无"
                motherTextField.text = "无"
                mHeadImageView.image = UIImage(named: "Logo")
                mPhoneTextField.text = "无"
                let view = UIView()
                view.backgroundColor = UIColor.clearColor()
                view.frame = CGRectMake(0, 667, WIDTH, 300)
                self.tableSource.addSubview(view)
            }
            if fatherArr.count != 0 {
                
                fNameTextField.text = fatherArr[0].parent_name
                fWorkTextField.text = model.fatherpro
                fPhoneTextField.text = fatherArr[0].parent_phone
                fatherTextField.text = model.withfather
                let pic1 = fatherArr[0].parent_photo
                let imgUrl1 = microblogImageUrl + pic1
                let photourl1 = NSURL(string: imgUrl1)
                fHeadImageView.sd_setImageWithURL(photourl1, placeholderImage: UIImage(named: "Logo"))
            }else{
                fNameTextField.text = "无"
                fWorkTextField.text = "无"
                fatherTextField.text = "无"
                fHeadImageView.image = UIImage(named: "Logo")
                fPhoneTextField.text = "无"
                let view = UIView()
                view.backgroundColor = UIColor.clearColor()
                view.frame = CGRectMake(0, 970, WIDTH, 310)
                self.tableSource.addSubview(view)
            }
        }
        
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        mPhoneTextField.resignFirstResponder()
        mNameTextField.resignFirstResponder()
        workTextField.resignFirstResponder()
        motherTextField.resignFirstResponder()
        fNameTextField.resignFirstResponder()
        fWorkTextField.resignFirstResponder()
        fPhoneTextField.resignFirstResponder()
        fatherTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
        aiHaoTextField.resignFirstResponder()
        sexTextField.resignFirstResponder()
        addressTextField.resignFirstResponder()
        jieTextField.resignFirstResponder()
    }
    

}
