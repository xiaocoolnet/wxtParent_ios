//
//  SendPhotoViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/5/6.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos
import MBProgressHUD
import Alamofire

class SendPhotoViewController: UIViewController,UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate, TZImagePickerControllerDelegate {

    var imageData:[NSData] = []
    var isuploading = false
    var imageUrl:String?
    var i = 0
    var imagePath = NSMutableArray()
    var pictureArray = NSMutableArray()
    var addPictureBtn = UIButton()
    var picture = UIImageView()
    let contentTextView = BRPlaceholderTextView()
    var itemCount = 0
    var collectionV:UICollectionView?
    var flowLayout = UICollectionViewFlowLayout()
    
    
    var image = UIImage()
    override func viewDidLoad() {
        super.viewDidLoad()
        //   打开手势交互
        self.view.userInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(_:)))
        self.view.addGestureRecognizer(tap)
        self.title = "发布照片"
        self.view.backgroundColor = UIColor.whiteColor()
        let rightItem = UIBarButtonItem(title: "发布", style: .Done, target: self, action: #selector(SendPhotoViewController.UpdateBlog))
        self.navigationItem.rightBarButtonItem = rightItem
        //        创建UI
        createPhotoName()
        self.createUI()
    }
    func tapAction(tap:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    // 相册名称
    func createPhotoName(){
        let nameField = UITextField()
        nameField.frame = CGRectMake(10, 0, WIDTH - 15, 40)
        nameField.placeholder = "相册名称"
        self.view.addSubview(nameField)
        
        let lable = UILabel()
        lable.frame = CGRectMake(0, 40, WIDTH, 10)
        lable.backgroundColor = RGBA(242.0, g: 242.0, b: 242.0, a: 1)
        self.view.addSubview(lable)
        
    }
    //    创建输入框
    func createUI(){
        self.contentTextView.frame = CGRectMake(8, 50, self.view.bounds.width - 16, 120)
        self.contentTextView.font = UIFont.systemFontOfSize(17)
        self.contentTextView.placeholder = "相册描述"
        self.contentTextView.addMaxTextLengthWithMaxLength(200) { (contentTextView) -> Void in
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.mode = MBProgressHUDMode.Text
            hud.labelText = "超过200字啦"
            hud.margin = 10.0
            hud.removeFromSuperViewOnHide = true
            hud.hide(true, afterDelay: 3)
        }
        
        self.view.addSubview(contentTextView)
        
        let line = UILabel()
        line.frame = CGRectMake(0, 171, WIDTH, 1)
        line.backgroundColor = RGBA(242.0, g: 242.0, b: 242.0, a: 1)
        self.view.addSubview(line)
        //        添加图片按钮
        addPictureBtn.frame = CGRectMake(8, 185, 55, 55)
        addPictureBtn.setBackgroundImage(UIImage(named: "add2"), forState: UIControlState.Normal)
        addPictureBtn.layer.borderWidth = 1.0
        addPictureBtn.layer.borderColor = UIColor.grayColor().CGColor
        addPictureBtn.addTarget(self, action: #selector(SendPhotoViewController.AddPictrures), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(addPictureBtn)
    }
    
    func addCollectionViewPicture(){
        
        let flowl = UICollectionViewFlowLayout.init()
        //设置每一个item大小
        flowl.itemSize = CGSizeMake((WIDTH-60)/3, (WIDTH-60)/3)
        flowl.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10)
        flowl.minimumInteritemSpacing = 10
        flowl.minimumLineSpacing = 10
        print(self.pictureArray.count)
        var height =  CGFloat(((self.pictureArray.count-1)/3))*((WIDTH-60)/3+10)+((WIDTH-60)/3+10)
        if self.pictureArray.count == 0 {
            height = 0
        }
        //创建集合视图
        self.collectionV?.removeFromSuperview()
        self.collectionV = UICollectionView.init(frame: CGRectMake(0, 240, WIDTH, height), collectionViewLayout: flowl)
        collectionV!.backgroundColor = UIColor.whiteColor()
        collectionV!.delegate = self
        collectionV!.dataSource = self
        collectionV!.registerNib(UINib(nibName: "PicNumCollectionViewCell",bundle: nil), forCellWithReuseIdentifier: "photo")
//        self.collectionV?.registerClass(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "Photo")
        //        collectionV?.backgroundColor = UIColor.redColor()//测试用
        self.view.addSubview(collectionV!)
        
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(self.pictureArray.count)
        if self.pictureArray.count == 0 {
            return 0
        }else{
            
            return pictureArray.count
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photo", forIndexPath: indexPath) as! PicNumCollectionViewCell
        
        let image = self.pictureArray[indexPath.item]
        let data:NSData = UIImageJPEGRepresentation(image as! UIImage, 1.0)!
        var myImagess = UIImage()
        myImagess = UIImage.init(data: data)!

        print(myImagess)
        cell.imgBtn.setBackgroundImage(myImagess, forState: .Normal)
       
        
        let button = UIButton.init(frame: CGRectMake(cell.frame.size.width-18, 0, 20, 20))
        button.setImage(UIImage(named: "ic_shanchu-cha"), forState: UIControlState.Normal)
        button.tag = indexPath.row
        button.addTarget(self, action: #selector(self.deleteImage(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cell.addSubview(button)
        return cell
    }
    
    
    //删除照片
    func deleteImage(btn:UIButton){
        print(btn.tag)
        self.pictureArray.removeObjectAtIndex(btn.tag)
        self.collectionV?.reloadData()
        if self.pictureArray.count%3 == 0&&self.pictureArray.count>1  {
            //            UIView.animateWithDuration(0.2, animations: {
//            self.collectionV?.height = (self.collectionV?.height)! - (WIDTH-60)/3
            
        }
        if self.pictureArray.count == 0 {
            self.collectionV?.frame.size.height = 0
            self.collectionV?.removeFromSuperview()
            self.addCollectionViewPicture()
        }
        
    }
    
    
    func imagePickerController(picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [AnyObject]!, isSelectOriginalPhoto: Bool, infos: [[NSObject : AnyObject]]!) {
        //        self.photoArray.removeAllObjects()
        for imagess in photos {
            pictureArray.addObject(imagess)
        }
        print(self.pictureArray.count)
        self.addCollectionViewPicture()
        
        
    }
    

    
    func AddPictrures(btn:UIButton){
        
        
        let imagePickerVc = TZImagePickerController.init(maxImagesCount: 9, delegate:self)
       
        print(pictureArray.count)
        print("上传图片")
        print(btn.tag)
        let imagePicker = UIImagePickerController();
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePickerVc, animated: true, completion: nil)
    }
//    //上传图片的协议与代理方法
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        
//        //        let image = info[UIImagePickerControllerEditedImage]as! UIImage
//        //        self.photoArray.addObject(image)
//        print(self.pictureArray)
//        self.addCollectionViewPicture()
//        let data = UIImageJPEGRepresentation((info[UIImagePickerControllerEditedImage] as? UIImage)!, 0.1)!
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "yyyyMMddHHmmss"
//        let dateStr = dateFormatter.stringFromDate(NSDate())
//        let imageName = "avatar" + dateStr
//        
//        //上传图片
//        ConnectModel.uploadWithImageName(imageName, imageData: data, URL: "WriteMicroblog_upload") { [unowned self] (data) in
//            dispatch_async(dispatch_get_main_queue(), {
//                
//                let result = Http(JSONDecoder(data))
//                if result.status != nil {
//                    dispatch_async(dispatch_get_main_queue(), {
//                        if result.status! == "success"{
//                            self.imagePath.addObject(result.data!)
//                            self.imageUrl = self.imagePath.componentsJoinedByString(",")
//                            
//                        }else{
//                            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//                            hud.mode = MBProgressHUDMode.Text;
//                            hud.labelText = "图片上传失败"
//                            hud.margin = 10.0
//                            hud.removeFromSuperViewOnHide = true
//                            hud.hide(true, afterDelay: 1)
//                        }
//                    })
//                }
//            })
//        }
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
    
    //   更新日记
    func UpdateBlog(){
//        if(i != 0){
//            //  图片
            self.fabu()
//        }
        //  发表日志
//        self.PutBlog()
    }
//    //    更新图片
//    func UpdatePic(){
//                for i in 0..<self.pictureArray.count{
//                    let chid = NSUserDefaults.standardUserDefaults()
//                    let studentid = chid.stringForKey("chid")
//                    let date = NSDate()
//                    let dateformate = NSDateFormatter()
//                    dateformate.dateFormat = "yyyy-MM-dd HH:mm"//获得日期
//                    let time:NSTimeInterval = (date.timeIntervalSince1970)
//                    let RanNumber = String(arc4random_uniform(1000) + 1000)
//                    let name = "\(studentid!)baby\(time)\(RanNumber)"
//                    isuploading = true
//                
//
//                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
//                        ConnectModel.uploadWithImageName(name, imageData:self.imageData[i], URL: "WriteMicroblog_upload", finish: { (data) -> Void in
//                            print("返回值")
//                            print(data)
//                            
//                        })
//        }
//                    self.imagePath.addObject(name + ".png")
//                }
//        self.imageUrl = self.imagePath.componentsJoinedByString(",")
//        print(self.imageUrl!)
//        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//        hud.mode = MBProgressHUDMode.Text
//        hud.margin = 10
//        hud.removeFromSuperViewOnHide = true
//        hud.labelText = "上传完成"
//        hud.hide(true, afterDelay: 1)
//        self.isuploading = false
//        
//    }

    //    发表日记
    func PutBlog(){
//        userid,schoolid,classid（班级相册时必填）,studentid（宝宝相册时必填）,type(1：个人动态，2，班级相册，3宝宝相册),content,picurl
        let chid = NSUserDefaults.standardUserDefaults()
        let stuid = chid.stringForKey("chid")
        let userid = chid.stringForKey("userid")
        let schoolid = chid.stringForKey("schoolid")
        let classid = chid.stringForKey("classid")

        
        let url = apiUrl+"WriteMicroblog"
        if(self.imagePath.count == 0){
            imageUrl = ""
        }
        let param = [
            "schoolid":schoolid!,
            "studentid":stuid!,
            "userid":userid!,
            "classid":classid!,
            "type":3,
            "content":self.contentTextView.text!,
            "picurl":imageUrl!
        ]
        if imageUrl == "" {
            messageHUD(self.view, messageData: "请添加照片")
        }else{
            
            Alamofire.request(.POST, url, parameters: param as? [String : AnyObject]).response { request, response, json, error in
                if(error != nil){
                }
                else{
                    print("request是")
                    print(request!)
                    print("====================")
                    let result = Httpresult(JSONDecoder(json!))
                    print("状态是")
                    print(result.status)
                    if(result.status == "error"){
                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        hud.mode = MBProgressHUDMode.Text
                        hud.labelText = result.errorData
                        hud.margin = 10.0
                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 1)
                    }
                    if(result.status == "success"){
                        print("Success")
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                    
                }
                
            }
        }
    }
    
    func fabu(){
        
        for ima in pictureArray{
            
            let dataPhoto:NSData = UIImageJPEGRepresentation(ima as! UIImage, 1.0)!
            var myImagess = UIImage()
            myImagess = UIImage.init(data: dataPhoto)!
            
            let data = UIImageJPEGRepresentation(myImagess, 0.1)!
            let chid = NSUserDefaults.standardUserDefaults()
            let studentid = chid.stringForKey("chid")
            let date = NSDate()
            let dateformate = NSDateFormatter()
            dateformate.dateFormat = "yyyy-MM-dd HH:mm"//获得日期
            let time:NSTimeInterval = (date.timeIntervalSince1970)
            let RanNumber = String(arc4random_uniform(1000) + 1000)
            let name = "\(studentid!)baby\(time)\(RanNumber)"
            
            //上传图片
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                ConnectModel.uploadWithImageName(name, imageData:data, URL: "WriteMicroblog_upload", finish: { (data) -> Void in
                    print("返回值")
                    print(data)
                    
                })
            }
            self.imagePath.addObject(name + ".png")
        }
        self.imageUrl = self.imagePath.componentsJoinedByString(",")
        print(self.imageUrl!)
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.mode = MBProgressHUDMode.Text
        hud.margin = 10
        hud.removeFromSuperViewOnHide = true
        hud.labelText = "上传完成"
        hud.hide(true, afterDelay: 1)
        self.PutBlog()
    }
//    收键盘
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
 
}
