//
//  AddDiaryViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/6/6.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos
import MBProgressHUD
import Alamofire
//  写日志
class AddDiaryViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    var id:String?
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
    var collectV:UICollectionView?
    var flowLayout = UICollectionViewFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //   打开手势交互
        self.view.userInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(_:)))
        self.view.addGestureRecognizer(tap)

        self.title = "新增日记"
        self.view.backgroundColor = UIColor.whiteColor()
        let rightItem = UIBarButtonItem(title: "发布", style: .Done, target: self, action: #selector(SendPhotoViewController.UpdateBlog))
        self.navigationItem.rightBarButtonItem = rightItem
        //        创建UI
        self.createUI()
    }
    func tapAction(tap:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    //    创建输入框
    func createUI(){
        self.contentTextView.frame = CGRectMake(8, 5, self.view.bounds.width - 16, 150)
        self.contentTextView.font = UIFont.systemFontOfSize(15)
        self.contentTextView.placeholder = "编辑宝贝的精彩日记"
        //        添加图片按钮
        addPictureBtn.frame = CGRectMake(8, 160, 80, 80)
        addPictureBtn.setBackgroundImage(UIImage(named: "add2"), forState: UIControlState.Normal)
        addPictureBtn.layer.borderWidth = 1.0
        addPictureBtn.layer.borderColor = UIColor.grayColor().CGColor
        addPictureBtn.addTarget(self, action: #selector(SendPhotoViewController.AddPictrures), forControlEvents: UIControlEvents.TouchUpInside)
        //        创建流视图
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Vertical
        flowLayout.itemSize = CGSizeMake(80,80)
        self.collectV = UICollectionView(frame: CGRectMake(8, 165, UIScreen.mainScreen().bounds.width-30, 359), collectionViewLayout: flowLayout)
        //        注册
        self.collectV?.registerClass(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCell")
        
        self.collectV?.delegate = self
        self.collectV?.dataSource = self
        self.collectV?.backgroundColor = UIColor.clearColor()
        self.view.addSubview(self.contentTextView)
        self.view.addSubview(self.collectV!)
        self.view.addSubview(addPictureBtn)
    }
    //    图片的个数
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount
    }
    //    每行几个
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    //    单元格
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell:ImageCollectionViewCell  = collectV!.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as! ImageCollectionViewCell
        if(self.pictureArray.count != 0){
            cell.imageView.frame = CGRectMake(0, 0, 80, 80)
            cell.imageView.image = self.pictureArray[indexPath.row] as? UIImage
            cell.contentView.addSubview(cell.imageView)
            return cell
        }
        return cell
    }
    //    最小高度
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CGFloat(0)
    }
    
    //    上下间距
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CGFloat(6)
    }
    
    override func viewWillAppear(animated: Bool) {
        if(self.i>9){
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.mode = MBProgressHUDMode.Text
            hud.labelText = "最多选择9张图片哦"
            hud.margin = 10.0
            hud.removeFromSuperViewOnHide = true
            hud.hide(true, afterDelay: 2)
        }
    }
    //   添加图片
    func AddPictrures(){
        let vc = BSImagePickerViewController()
        vc.maxNumberOfSelections = 9
        bs_presentImagePickerController(vc, animated: true,
                                        select: { (asset: PHAsset) -> Void in
            }, deselect: { (asset: PHAsset) -> Void in
            }, cancel: { (assets: [PHAsset]) -> Void in
            }, finish: { (assets: [PHAsset]) -> Void in
                self.getAssetThumbnail(assets)
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.collectV!.reloadData()
                }
            }, completion: nil)
    }
    //    选择图片
    func getAssetThumbnail(asset: [PHAsset]) -> UIImage {
        //  图片
        var thumbnail = UIImage()
        i+=asset.count
        if(i>9){
        }
        else{
            print("选择的图片有\(i)张")
            if(itemCount == 0){
                itemCount = asset.count + 1
                self.pictureArray.insertObject("", atIndex: 0)
            }
            else{
                itemCount += asset.count
            }
            let manager = PHImageManager.defaultManager()
            let option = PHImageRequestOptions()
            option.synchronous = true
            
            
            for j in 0..<asset.count{
                
                //  这里的参数应该喝照片的大小一致（需要进行判断）
                manager.requestImageForAsset(asset[j], targetSize: PHImageManagerMaximumSize, contentMode: .AspectFit, options: option, resultHandler: {(result, info)->Void in
                    //  设置像素
                    option.resizeMode = PHImageRequestOptionsResizeMode.Exact
                    let downloadFinined = !((info!["PHImageResultIsDegradedKey"]?.boolValue)!)
                    
                    //                let downloadFinined:Bool = !((info!["PHImageCancelledKey"]?.boolValue)! ?? false) && !((info!["PHImageErrorKey"]?.boolValue)! ?? false) && !((info!["PHImageResultIsDegradedKey"]?.boolValue)! ?? false)
                    if downloadFinined == true {
                        thumbnail = result!
                        print(" print(result?.images)")
                        //  改变frame
                        print(result)
                        print("图片是")
                        let temImage:CGImageRef = thumbnail.CGImage!
                        //                    temImage = CGImageCreateWithImageInRect(temImage, CGRectMake(0, 0, 1000, 1000))!
                        let newImage = UIImage(CGImage: temImage)
                        //  压缩最多1  最少0
                        self.imageData.append(UIImageJPEGRepresentation(newImage, 0)!)
                        self.pictureArray.addObject(newImage)
                        
                    }
                    //                thumbnail = result!
                    
                    //
                    
                })
            }
        }
        return thumbnail
    }
    
    func byScalingToSize(image:UIImage,targetSize:CGSize) ->(UIImage){
        let sourceImage = image
        var newImage = UIImage()
        UIGraphicsBeginImageContext(targetSize)
        var thumbnailRect = CGRectZero;
        thumbnailRect.origin = CGPointZero;
        thumbnailRect.size.width  = targetSize.width;
        thumbnailRect.size.height = targetSize.height;
        sourceImage.drawInRect(thumbnailRect)
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    //   更新日记
    func UpdateBlog(){
        if(i != 0){
            self.UpdatePic()
        }
        self.PutBlog()
    }
    //    更新图片
    func UpdatePic(){
        for i in 0..<self.imageData.count{
                let chid = NSUserDefaults.standardUserDefaults()
                let studentid = chid.stringForKey("chid")
                let date = NSDate()
                let dateformate = NSDateFormatter()
                dateformate.dateFormat = "yyyy-MM-dd HH:mm"//获得日期
                let time:NSTimeInterval = (date.timeIntervalSince1970)
                let RanNumber = String(arc4random_uniform(1000) + 1000)
                let name = "\(studentid!)baby\(time)\(RanNumber)"
                isuploading = true
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                    ConnectModel.uploadWithImageName(name, imageData:self.imageData[i], URL: "WriteMicroblog_upload", finish: { (data) -> Void in
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
            self.isuploading = false
        
    }
    //    发表日记
    //  babyid,userid,cover_photo,title,conten,write_time
//    出参：无
//    Demo:http://wxt.xiaocool.net/index.php?g=apps&m=index&a=WriteBabyGrow
    func PutBlog(){
        
        let chid = NSUserDefaults.standardUserDefaults()
//        let stuid = chid.stringForKey("chid")
        let userid = chid.stringForKey("chid")
        let schoolid = chid.stringForKey("schoolid")
        let classid = chid.stringForKey("classid")
        
        
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=index&a=WriteMicroblog"
        if(self.imagePath.count == 0){
            imageUrl = ""
        }
        let param = [
            "schoolid":schoolid!,
//            "studentid":stuid!,
            "userid":userid!,
            "classid":classid!,
            "type":"7",
            "content":self.contentTextView.text!,
            "picurl":imageUrl!
        ]
        
        
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
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



