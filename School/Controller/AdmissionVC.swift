//
//  AdmissionVC.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/5.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire

class AdmissionVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var data = NSData()
    var hud = MBProgressHUD()
    var changeImage = UIImageView()

    
    var scrollView = UIScrollView()
//      姓名
    var nameTextFiled = UITextField()
//      男
    var boyButton = UIButton()
//      女
    var girlButton = UIButton()
//      性别判断
    var isSexLabel = UILabel()
//      出生日期
    var ageTextFiled = UITextField()
//      现住址
    var addressTextFiled = UITextField()
//      班级
    var classTextFiled = UITextField()
//      手机号
    var phoeNumTextFiled = UITextField()
//      QQ
    var QQTextFiled = UITextField()
//      微信
    var WXTextFiled = UITextField()
//      备注
    var noteTextView = UITextView()
//      资料照片
    var photoButton = UIButton()
    
    
//    


    override func viewDidLoad() {
        super.viewDidLoad()
        createScrollView()
        initUI()
        addTag()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
//  MARK: - 初始化类
    
    func addTag() {
        self.view.userInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(_:)))
        
        self.view.addGestureRecognizer(tap)
    }
    func createScrollView() {
        
        self.title = "入学报名"
        self.tabBarController?.tabBar.hidden = true
        self.view.backgroundColor = UIColor.whiteColor()
        
        scrollView.frame = self.view.bounds
        //  设置滚动范围
        scrollView.contentSize = CGSizeMake(WIDTH, 900)
        self.view.addSubview(scrollView)
    }
    
    func initUI() {
        
        //  初始化UI
        let introduceLabel = UILabel()
        introduceLabel.frame = CGRectMake(10, 10, 200, 30)
        introduceLabel.text = "招生介绍"
        scrollView.addSubview(introduceLabel)
        
        let contentLabel = UILabel()
        contentLabel.frame = CGRectMake(10, 40, WIDTH - 20, 200)
        contentLabel.text = "     招生介绍招生介绍招生介绍招生介绍招生介绍招生介绍招生介绍招生介绍招生介绍招生介绍招生介绍招生介绍招生介绍招生介绍招生介绍招生介绍招生介绍招生介绍"
        contentLabel.numberOfLines = 0
        contentLabel.textColor = UIColor.grayColor()
        scrollView.addSubview(contentLabel)
        
        let view = UIView()
        view.frame = CGRectMake(0, 240, WIDTH, 1)
        view.backgroundColor = UIColor.lightGrayColor()
        scrollView.addSubview(view)
        
        let nameLabel = addLabel("姓名:", size: CGRectMake(10, 250, 100, 30))
        scrollView.addSubview(nameLabel)
        
        let sexLabel = addLabel("性别:", size: CGRectMake(10, 290, 100, 30))
        scrollView.addSubview(sexLabel)
        
        boyButton = addButton("1",imageString_p: "1",size: CGRectMake(110, 290, 20, 20))
        boyButton.addTarget(self, action: #selector(boyAction(_:)), forControlEvents: .TouchUpInside)
        scrollView.addSubview(boyButton)
        
        let boyLabel = addLabel("男", size: CGRectMake(140, 290, 20, 20))
        scrollView.addSubview(boyLabel)
        
        let girlLabel = addLabel("女", size: CGRectMake(220, 290, 20, 20))
        scrollView.addSubview(girlLabel)
        
        girlButton = addButton("1",imageString_p: "1", size: CGRectMake(190, 290, 20, 20))
        girlButton.addTarget(self, action: #selector(girlAction(_:)), forControlEvents: .TouchUpInside)
        scrollView.addSubview(girlButton)
        
        let ageLabel = addLabel("出生日期:", size: CGRectMake(10, 330, 100, 30))
        scrollView.addSubview(ageLabel)
        
        let adressLabel = addLabel("现住址:", size: CGRectMake(10, 370, 100, 30))
        scrollView.addSubview(adressLabel)
        
        let classLabel = addLabel("班级:", size: CGRectMake(10, 410, 100, 30))
        scrollView.addSubview(classLabel)
        
        let phoneNumLabel = addLabel("手机号:", size: CGRectMake(10, 450, 100, 30))
        scrollView.addSubview(phoneNumLabel)
    
        let QQLabel = addLabel("QQ:", size: CGRectMake(10, 490, 100, 30))
        scrollView.addSubview(QQLabel)
        
        let WXLabel = addLabel("微信:", size: CGRectMake(10, 530, 100, 30))
        scrollView.addSubview(WXLabel)

        let noteLabel = addLabel("备注:", size: CGRectMake(10, 570, 100, 30))
        scrollView.addSubview(noteLabel)
        
        let photoLabel = addLabel("资料照片", size: CGRectMake(10, 690, 100, 30))
        scrollView.addSubview(photoLabel)
        
        nameTextFiled = addTextField(CGRectMake(110, 250, WIDTH - 120, 30))
        scrollView.addSubview(nameTextFiled)
        
        ageTextFiled = addTextField(CGRectMake(110, 330, WIDTH - 120, 30))
        scrollView.addSubview(ageTextFiled)
        
        addressTextFiled = addTextField(CGRectMake(110, 370, WIDTH - 120, 30))
        scrollView.addSubview(addressTextFiled)
        
        classTextFiled = addTextField(CGRectMake(110, 410, WIDTH - 120, 30))
        scrollView.addSubview(classTextFiled)
        
        phoeNumTextFiled = addTextField(CGRectMake(110, 450, WIDTH - 120, 30))
        scrollView.addSubview(phoeNumTextFiled)
        
        QQTextFiled = addTextField(CGRectMake(110, 490, WIDTH - 120, 30))
        scrollView.addSubview(QQTextFiled)
        
        WXTextFiled = addTextField(CGRectMake(110, 530, WIDTH - 120, 30))
        scrollView.addSubview(WXTextFiled)
        
        noteTextView.frame = CGRectMake(110, 570, WIDTH - 120, 110)
        scrollView.addSubview(noteTextView)
        
        
        photoButton = addButton("1", imageString_p: "1", size: CGRectMake(10, 730, 80, 80))
        photoButton.addTarget(self, action: #selector(addPhotoAction), forControlEvents: .TouchUpInside)
        
        scrollView.addSubview(photoButton)
        
        let sureButton = UIButton()
        sureButton.frame = CGRectMake(20, 820, WIDTH - 40, 40)
        sureButton.cornerRadius = 5
        sureButton.backgroundColor = RGBA(155, g: 229, b: 180, a: 1)
        sureButton.setTitle("确定", forState: .Normal)
        sureButton.addTarget(self, action: #selector(sureAction), forControlEvents: .TouchUpInside)
        scrollView.addSubview(sureButton)
    }
//  MARK: - 点击类
    func boyAction(sender:UIButton){
        //  选择男
        sender.selected = true
            //  改变背景图片
//        isSexLabel.text = "1"
//        print(isSexLabel.text!)
        girlButton.selected = false

        
        
    }
    func girlAction(sender:UIButton){
        //  选择女
        sender.selected = true
        boyButton.selected = false
//        isSexLabel.text! = "0"
    }
    
//    func click(sender:UIButton){
//        
//        switch sender.tag {
//        case 11:
//            manImg.image = UIImage.init(named: "ic_yuan_purple")
//            menImg.image = UIImage.init(named: "ic_yuan")
//            flag = 2
//        case 12:
//            manImg.image = UIImage.init(named: "ic_yuan")
//            menImg.image = UIImage.init(named: "ic_yuan_purple")
//            print(manImg.image)
//            flag = 1
//        default:
//            break
//        }
//    }

    
    func addPhotoAction(){
        //  添加照片(需要添加一个collectionView)
        let image = UIImageView()
        self.changeHeaderImag(image)
        
    }
    func sureAction(){
        //  进行判断  （如果输入的某些项为空则无效）
        if  (nameTextFiled.text?.isEmpty)! || (ageTextFiled.text?.isEmpty)! || (addressTextFiled.text?.isEmpty)! || (classTextFiled.text?.isEmpty)! || (phoeNumTextFiled.text?.isEmpty)! || (QQTextFiled.text?.isEmpty)! || (WXTextFiled.text?.isEmpty)! || noteTextView.text.isEmpty || isSexLabel.text == nil{
            alert("请输入内容", delegate: self)
            return
        }
        
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=school&a=enterschol"
        let param = ["schoolid":"1",
                     "username":nameTextFiled.text!,
                     "sex":isSexLabel.text!,
                     "birthday":ageTextFiled.text!,
                     "address":addressTextFiled.text!,
                     "classname":classTextFiled.text!,
                     "phone":phoeNumTextFiled.text!,
                     "qq":QQTextFiled.text!,
                     "weixin":WXTextFiled.text!,
                     "education":noteTextView.text!,
                     ]
        POSTData(url, pmara: param)
        
    }
    
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
                if(status.status == "error"){
                    
                    messageHUD(self.view, messageData: status.errorData!)
                    
                }
                if(status.status == "success"){
                    
                    alert("报名成功", delegate: self)
                }
                
                //
                
            }
        }
    }

    func tapAction(tap:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
//  MARK: - 封装类
    func addLabel(content:String,size:CGRect) -> UILabel{
        let addLabel = UILabel()
        addLabel.frame = size
        addLabel.text = content
        return addLabel
    }
    func addTextField(size:CGRect) -> UITextField{
        let addTextField = UITextField()
        addTextField.frame = size
        return addTextField
    }
    func addButton(imageString:String,imageString_p:String,size:CGRect) -> UIButton{
        let addButton = UIButton()
        addButton.frame = size
        addButton.setImage(UIImage.init(named: imageString), forState: .Normal)
        addButton.setImage((UIImage.init(named: imageString_p)), forState: .Selected)
        return addButton
    }
    
//      MARK : -  更改图片
    
    func changeHeaderImag(image:UIImageView){
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
//        let vc = BSImagePickerViewController()
//        vc.maxNumberOfSelections = 9
//        bs_presentImagePickerController(vc, animated: true,
//                                        select: { (asset: PHAsset) -> Void in
//            }, deselect: { (asset: PHAsset) -> Void in
//            }, cancel: { (assets: [PHAsset]) -> Void in
//            }, finish: { (assets: [PHAsset]) -> Void in
//                self.getAssetThumbnail(assets)
//                dispatch_async(dispatch_get_main_queue()) { () -> Void in
////                    self.collectV!.reloadData()
//                }
//            }, completion: nil)
        
    }
//    //    选择图片
//    func getAssetThumbnail(asset: [PHAsset]) -> UIImage {
//        var thumbnail = UIImage()
//        i+=asset.count
//        if(i>9){
//        }
//        else{
//            print("选择的图片有\(i)张")
//            if(itemCount == 0){
//                itemCount = asset.count + 1
//                self.pictureArray.insertObject("", atIndex: 0)
//            }
//            else{
//                itemCount += asset.count
//            }
//            let manager = PHImageManager.defaultManager()
//            let option = PHImageRequestOptions()
//            option.synchronous = true
//            for j in 0..<asset.count{
//                manager.requestImageForAsset(asset[j], targetSize: CGSize(width: 1000.0, height: 1000.0), contentMode: .AspectFit, options: option, resultHandler: {(result, info)->Void in
//                    thumbnail = result!
//                    print("图片是")
//                    var temImage:CGImageRef = thumbnail.CGImage!
//                    temImage = CGImageCreateWithImageInRect(temImage, CGRectMake(0, 0, 1000.0, 1000.0))!
//                    let newImage = UIImage(CGImage: temImage)
//                    self.imageData.append(UIImageJPEGRepresentation(newImage, 1)!)
//                    self.pictureArray.addObject(newImage)
//                })
//            }
//        }
//        return thumbnail
//    }

    
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
        self.photoButton.imageView?.image = img
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //取消之后
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    

}
