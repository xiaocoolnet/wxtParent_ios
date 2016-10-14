//
//  XinxiViewController.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/9/3.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

import MBProgressHUD
import Alamofire

class XinxiViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
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
    
    var dataSource : InviteInfo?
    
    
    
    //  tableview
    var tableView = UITableView()
    //  dataSource(不需要)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //  隐藏芬兰控制器
        self.tabBarController?.tabBar.hidden = true
        //  初始化  UI
        initUI()
        
    }
    func initUI(){
        self.tableView.frame = self.view.bounds
        self.view.addSubview(tableView)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .None
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //  段数据
        return 4
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
        let cell = UITableViewCell(style: .Default, reuseIdentifier:String(indexPath.row))
        cell.selectionStyle = .None

        
        if indexPath.section == 0 {
            
            let imageViewLabel = UILabel()
            imageViewLabel.frame = CGRectMake(10, 35, 100, 30)
            //  添加头像
            imageViewLabel.text = "头像"
            cell.contentView.addSubview(imageViewLabel)
            let pic = self.dataSource?.parent_info[0].photo
            let imgUrl = microblogImageUrl + pic!
            let photourl = NSURL(string: imgUrl)
            headerImageView.frame = CGRectMake(WIDTH - 120, 10, 80, 80)
            headerImageView.sd_setImageWithURL(photourl, placeholderImage: UIImage(named: "默认头像"))
            headerImageView.layer.cornerRadius = 40
            headerImageView.clipsToBounds = true
            cell.contentView.addSubview(headerImageView)
            
        }else if indexPath.section == 1{
            
            let nameLabel = UILabel()
            nameLabel.frame = CGRectMake(10, 10, 100, 30)
            nameLabel.text = "家人姓名"
            cell.contentView.addSubview(nameLabel)
            
            personNameLabel.frame = CGRectMake(WIDTH - 190, 10, 150, 30)
            personNameLabel.textAlignment = NSTextAlignment.Right
            personNameLabel.text = self.dataSource?.parent_info[0].name
        
            cell.contentView.addSubview(personNameLabel)
            
        }else if indexPath.section == 2{
            
            let phoneLabel = UILabel()
            phoneLabel.frame = CGRectMake(10, 10, 130, 30)
            phoneLabel.text = "与宝宝的关系"
            cell.contentView.addSubview(phoneLabel)
            
            personSexLabel.frame = CGRectMake(WIDTH - 190, 10, 150, 30)
            personSexLabel.textAlignment = NSTextAlignment.Right
            personSexLabel.text = self.dataSource?.appellation
            cell.contentView.addSubview(personSexLabel)
            
        }else {
            
            let phoneLabel = UILabel()
            phoneLabel.frame = CGRectMake(10, 10, 100, 30)
            phoneLabel.text = "手机号"
            cell.contentView.addSubview(phoneLabel)
            
            personPhoneLabel.frame = CGRectMake(WIDTH - 190, 10, 150, 30)
            personPhoneLabel.textAlignment = NSTextAlignment.Right
            personPhoneLabel.text = self.dataSource?.parent_info[0].phone
            cell.contentView.addSubview(personPhoneLabel)
            
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
//        let defalutid = NSUserDefaults.standardUserDefaults()
//        let sid = defalutid.stringForKey("userid")
        
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=UpdateUserAvatar"
        let param = [
            "userid":self.dataSource?.userid,
            "avatar":self.imageName
        ]
        
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
    
}
