//
//  PersonTableViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/6/13.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class PersonTableViewController: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    var data = NSData()
    
    var hud = MBProgressHUD()
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
        //  创建UI界面
        //  请求数据
        //  给控件赋值
        //  刷新UI界面
//        保存按钮
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .Plain, target: self, action: #selector(PersonTableViewController.save))
        
        
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
        self.changeHeaderImage(mHeadImageView)

    }
    //  修改妈妈头像
    @IBAction func mHeadBtn(sender: AnyObject) {
        print("mHeadBtn")
        self.changeHeaderImage(mHeadImageView)

    }
    //  修改爸爸头像
    @IBAction func fHeadBtn(sender: AnyObject) {
        print("fHeadBtn")
        self.changeHeaderImage(fHeadImageView)

    }
    
//    保存
    func save(){
        //  上传URL，把更新的数据传到网上数据（POST请求）
        let userDefaults = NSUserDefaults.standardUserDefaults()
//        userDefaults.setObject(<#T##value: AnyObject?##AnyObject?#>, forKey: <#T##String#>)

        //  需要上传的几个参数(当然也包括头像参数)
        
        //  请求数据
        //  控件赋值
        
        //  刷新UI界面
        self.tableSource.reloadData()
        self.navigationController?.popViewControllerAnimated(true)
        print("保存")
        //
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
        print("choose--------->>")
        print(info)
        
        
        
        let img = info[UIImagePickerControllerEditedImage] as! UIImage
        if(img.size.width>200 || img.size.height>200)
        {
            data = UIImageJPEGRepresentation(img, 0.1)!
        }
        else
        {
            data = UIImageJPEGRepresentation(img, 0.3)!
        }
        if (data.length>104850)
        {
            self.hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            self.hud.mode = MBProgressHUDMode.Text
            self.hud.margin = 10
            self.hud.removeFromSuperViewOnHide = true
            self.hud.labelText = "图片大于1M，请重新选择"
            self.hud.hide(true, afterDelay: 1)
            return
            
        }
        //  谁的图片需要修改
        self.changeImage.image = img
        picker.dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    //取消之后
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

}
