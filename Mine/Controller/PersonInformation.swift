//
//  PersonInformation.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/11.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire

class PersonInformation: UIViewController,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var headerImageView = UIImageView()
    var personNameLabel = UILabel()
    let personSexLabel = UILabel()
    let personPhoneLabel = UILabel()
    var imageStr = String()
//
    var data = NSData()
    
    var hud = MBProgressHUD()
    
    var changeImage = UIImageView()
    var imageName = String()
    
    var myActionSheet:UIAlertController?
    
    var img = UIImageView()

    var imgUrl:String?
    var imageCache = Dictionary<String,UIImage>()
    var userAvatar = UIImageView()
    var name = String()
    var sex = String()
    var phone = String()
    
    
    

    //  tableview
    var tableView = UITableView()
    //  dataSource(不需要)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //  隐藏芬兰控制器
        self.tabBarController?.tabBar.hidden = true
        //  初始化  UI
        initUI()
        self.GetUserInfo()

    }
    func initUI(){
        self.tableView.frame = self.view.bounds
        self.view.addSubview(tableView)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //  段数据
        return 5
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //  行数据
        return 1
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //  行高
        if indexPath.section == 0{
            return 100
        }else{
            //  返回行高
        return 50
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //  返回cell
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.selectionStyle = .None

        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        if indexPath.section == 0 {
            
            let imageViewLabel = UILabel()
            imageViewLabel.frame = CGRectMake(10, 35, 100, 30)
            //  添加头像
            imageViewLabel.text = "头像"
            cell.contentView.addSubview(imageViewLabel)
            
            headerImageView.frame = CGRectMake(WIDTH - 120, 10, 80, 80)
            headerImageView = self.userAvatar
            headerImageView.layer.cornerRadius = 40
            headerImageView.clipsToBounds = true
            cell.contentView.addSubview(headerImageView)

        }else if indexPath.section == 1{
            
            let nameLabel = UILabel()
            nameLabel.frame = CGRectMake(10, 10, 100, 30)
            nameLabel.text = "姓名"
            cell.contentView.addSubview(nameLabel)
            
            personNameLabel.frame = CGRectMake(WIDTH - 190, 10, 150, 30)
            personNameLabel.textAlignment = NSTextAlignment.Right
            personNameLabel.text = name
//            //  得到沙盒
//            let userDefaults = NSUserDefaults.standardUserDefaults()
//            personNameLabel.text = userDefaults.valueForKey("name") as? String
            cell.contentView.addSubview(personNameLabel)
            
        }else if indexPath.section == 2{
            
            let sexLabel = UILabel()
            sexLabel.frame = CGRectMake(10, 10, 100, 30)
            sexLabel.text = "性别"
            cell.contentView.addSubview(sexLabel)
            
            personSexLabel.frame = CGRectMake(WIDTH - 190, 10, 150, 30)
            personSexLabel.textAlignment = NSTextAlignment.Right
//            let userDefaults = NSUserDefaults.standardUserDefaults()
//            personSexLabel.text = userDefaults.valueForKey("sex") as? String
            if self.sex == "1" {
                personSexLabel.text = "男"
            }else{
                personSexLabel.text = "女"

            }
            
            if self.sex == ""{
                //  默认为男
                personSexLabel.text = "男"
            }
            cell.contentView.addSubview(personSexLabel)
            
        }else if indexPath.section == 3{
            
            let phoneLabel = UILabel()
            phoneLabel.frame = CGRectMake(10, 10, 100, 30)
            phoneLabel.text = "手机号码"
            cell.contentView.addSubview(phoneLabel)
            
            personPhoneLabel.frame = CGRectMake(WIDTH - 190, 10, 150, 30)
            personPhoneLabel.textAlignment = NSTextAlignment.Right
            personPhoneLabel.text = self.phone
//            let userDefaults = NSUserDefaults.standardUserDefaults()
//            personPhoneLabel.text = userDefaults.valueForKey("phone") as? String
            cell.contentView.addSubview(personPhoneLabel)
            
        }else{
            
            let changePassWordLabel = UILabel()
            changePassWordLabel.frame = CGRectMake(10, 10, 100, 30)
            changePassWordLabel.text = "修改密码"
            cell.contentView.addSubview(changePassWordLabel)
            
        }
        

        return cell
        
        
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5.0
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //  单元格的点击事件
        if indexPath.section == 0 {
            print("修改头像")
            //  直接弹出一个对话框，选取照片的模式
            self.changeHeaderImage()
            
            
        }else if indexPath.section == 1{
            print("修改姓名")
            let changePageVC = ChangeInformationPageVC()
            changePageVC.section = indexPath.section
            changePageVC.name = personNameLabel.text
            //  通过闭包进行接收值
            changePageVC.changeName = {(getName) ->Void in
                self.personNameLabel.text = getName
                let userDefaults = NSUserDefaults.standardUserDefaults()
                userDefaults.setValue(getName, forKey: "name")

            }
            self.navigationController?.pushViewController(changePageVC, animated: true)

        }else if indexPath.section == 2{
            print("修改性别")
            let changePageVC = ChangeInformationPageVC()
            changePageVC.section = indexPath.section
            changePageVC.sex = personSexLabel.text
            changePageVC.changeSex = {(getSex) -> Void in
                self.personSexLabel.text = getSex
                let userDefaults = NSUserDefaults.standardUserDefaults()
                userDefaults.setValue(getSex, forKey: "sex")
            }
            self.navigationController?.pushViewController(changePageVC, animated: true)

        }else if indexPath.section == 3{
            print("修改手机号码")
            let changePageVC = ChangeInformationPageVC()
            changePageVC.section = indexPath.section
            changePageVC.changeNumber = {(phoneNumber) -> Void in
                self.personPhoneLabel.text = phoneNumber
                let userDefaults = NSUserDefaults.standardUserDefaults()
                userDefaults.setValue(phoneNumber, forKey: "phone")
            }
            self.navigationController?.pushViewController(changePageVC, animated: true)

        }else{
            print("修改密码")
            let changePageVC = ChangeInformationPageVC()
            changePageVC.section = indexPath.section
            changePageVC.passWord = "111"
            changePageVC.changePassWord = {(getSex) -> Void in
                let userDefaults = NSUserDefaults.standardUserDefaults()
                userDefaults.setValue(getSex, forKey: "mima")
            }

            //let changePageVC = ChangeMimaViewController()
//            changePageVC.section = indexPath.section
//            changePageVC.changeNumber = {(phoneNumber) -> Void in
//                self.personPhoneLabel.text = phoneNumber
//                let userDefaults = NSUserDefaults.standardUserDefaults()
//                userDefaults.setValue(phoneNumber, forKey: "phone")
//            }

            
            self.navigationController?.pushViewController(changePageVC, animated: true)
        
        }
    }
    func changeHeaderImage(){
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
                        
                        self.picDate()
                        
                    }else{
                    }
                }
            })
        }
        self.headerImageView.image = image
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func picDate(){
        let defalutid = NSUserDefaults.standardUserDefaults()
        let sid = defalutid.stringForKey("userid")
        
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=UpdateUserAvatar"
        let param = [
            "userid":sid!,
            "avatar":self.imageName
        ]
        
        GetName(url, param: (param))
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
    
    func GetUserInfo(){
        //  得到沙盒
        let userid = NSUserDefaults.standardUserDefaults()
        //  把userid存入沙盒
        let uid = userid.stringForKey("userid")
        let url = apiUrl+"GetUsers"
        let param = [
            "userid":uid!
        ]
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            if(error != nil){
            }
            else{
                print("request是")
                print(request!)
                print("====================")
                //  进行数据解析
                let status = MineModel(JSONDecoder(json!))
                print("状态是")
                print(status.status)
                if(status.status == "error"){
                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.mode = MBProgressHUDMode.Text;
                    hud.labelText = status.errorData
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                
                if(status.status == "success"){
                    print("Success")
                    self.name = (status.data?.name)!
                    self.sex = (status.data?.sex)!
                    self.phone = (status.data?.phoneNumber)!
                    if(status.data?.avatar != nil){
                        self.imgUrl = microblogImageUrl+(status.data?.avatar)!
                        let avatarUrl = NSURL(string: self.imgUrl!)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        //异步获取
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                let imgTmp = UIImage(data: data!)
                                self.imageCache[self.imgUrl!] = imgTmp
                                self.userAvatar.image = imgTmp
                                if self.userAvatar.image==nil{
                                    self.userAvatar.image=UIImage(named: "Logo")
                                }
                                self.userAvatar.alpha = 1.0
                                self.headerImageView = self.userAvatar
                            }
                            
                        })
                        self.tableView.reloadData()
                    }
                }
                
            }
            
        }
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    



}
