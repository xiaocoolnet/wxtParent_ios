//
//  WriteExhortViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/5/4.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import BSImagePicker
import Photos
class WriteExhortViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,ToolProrocol,ToolProrocol1{

    var studentid:String?
    var teacherid:String?
    var teacherName:String?
    var studentName:String?
    let lbl2 = UILabel()
    let lbl4 = UILabel()
    
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
    
        self.tabBarController?.tabBar.hidden = true
        self.title = "叮嘱"
        self.view.backgroundColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1)
        let rightItem = UIBarButtonItem(title: "发送", style: .Done, target: self, action: #selector(WriteExhortViewController.sendExhort))
        self.navigationItem.rightBarButtonItem = rightItem
        self.createUI()
    }

//    创建UI
    func createUI(){
        
        let v1 = UIView()
        v1.frame = CGRectMake(0, 0, self.view.frame.size.width, 121)
        v1.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(v1)
        
        let lbl1 = UILabel()
        lbl1.frame = CGRectMake(10, 20, 60, 20)
        lbl1.text = "叮嘱人"
        lbl1.font = UIFont.systemFontOfSize(15)
        lbl1.textColor = UIColor(red: 171/255.0, green: 171/255.0, blue: 171/255.0, alpha: 1)
        v1.addSubview(lbl1)
        
        
        lbl2.frame = CGRectMake(80, 20, 100, 20)
        v1.addSubview(lbl2)
        
        let btn1 = UIButton(type: .Custom)
        btn1.frame = CGRectMake(WIDTH-30, 20, 20, 20)
        btn1.setImage(UIImage(named: "右边剪头.png"), forState: .Normal)
        btn1.addTarget(self, action: #selector(WriteExhortViewController.chooseStudent), forControlEvents: .TouchUpInside)
        v1.addSubview(btn1)
        
        let lineView = UIView()
        lineView.frame = CGRectMake(0, 61, self.view.frame.size.width, 1)
        lineView.backgroundColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1)
        v1.addSubview(lineView)
        
        let lbl3 = UILabel()
        lbl3.frame = CGRectMake(10, 81, 60, 20)
        lbl3.text = "接收人"
        lbl3.font = UIFont.systemFontOfSize(15)
        lbl3.textColor = UIColor(red: 171/255.0, green: 171/255.0, blue: 171/255.0, alpha: 1)
        v1.addSubview(lbl3)
        
        
        lbl4.frame = CGRectMake(80, 81, 100, 20)
        v1.addSubview(lbl4)

        let btn2 = UIButton(type: .Custom)
        btn2.frame = CGRectMake(WIDTH-30, 81, 20, 20)
        btn2.setImage(UIImage(named: "右边剪头.png"), forState: .Normal)
        btn2.addTarget(self, action: #selector(WriteExhortViewController.chooseTeacher), forControlEvents: .TouchUpInside)
        v1.addSubview(btn2)
        
        self.contentTextView.frame = CGRectMake(0, 131, self.view.bounds.width , 200)
        self.contentTextView.font = UIFont.systemFontOfSize(15)
        self.contentTextView.placeholder = "请输入内容～不能超过200字啦"
        self.contentTextView.addMaxTextLengthWithMaxLength(200) { (contentTextView) -> Void in
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.mode = MBProgressHUDMode.Text
            hud.labelText = "超过200字啦"
            hud.margin = 10.0
            hud.removeFromSuperViewOnHide = true
            hud.hide(true, afterDelay: 3)
        }
        let backGroudView = UIView(frame: CGRectMake(0,331,WIDTH,HEIGHT-331-49))
        let height = HEIGHT-331-49
        backGroudView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(backGroudView)
        addPictureBtn.frame = CGRectMake(10,height - 90, 80, 80)
        addPictureBtn.setBackgroundImage(UIImage(named: "add2"), forState: UIControlState.Normal)
        addPictureBtn.layer.borderWidth = 1.0
        addPictureBtn.layer.borderColor = UIColor.grayColor().CGColor
        addPictureBtn.addTarget(self, action: #selector(WriteExhortViewController.AddPictrures), forControlEvents: UIControlEvents.TouchUpInside)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Vertical
        flowLayout.itemSize = CGSizeMake(80,80)
        self.collectV = UICollectionView(frame: CGRectMake(10, 10, UIScreen.mainScreen().bounds.width-20, 359), collectionViewLayout: flowLayout)
        self.collectV?.registerClass(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCell")
        self.collectV?.delegate = self
        self.collectV?.dataSource = self
        self.collectV?.backgroundColor = UIColor.clearColor()
        self.view.addSubview(self.contentTextView)
        backGroudView.addSubview(self.collectV!)
        backGroudView.addSubview(addPictureBtn)
    }
//    选择孩子
    func chooseStudent(){
        let vc = StuRelationViewController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
//    代理方法
    func didRecieveStuInfo(studentid: String, studentName: String) {
        self.studentid = studentid
        self.studentName = studentName
        self.lbl2.text = studentName
    }
//    选择老师
    func chooseTeacher(){
        let vc = TeacherListViewController()
        if self.studentid == nil {
            let alert = UIAlertController(title: "提示", message: "请先选择叮嘱人", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler:nil))
            alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }else{
            vc.studentid = self.studentid
            vc.delegate = self
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func didRecieveTeaInfo(teacherid:String,teacherName:String){
        self.teacherid = teacherid
        self.teacherName = teacherName
        self.lbl4.text = self.teacherName
    }
//    网络请求
    func writeExhort(){
        //http://wxt.xiaocool.net/index.php?g=apps&m=student&a=addentrust&teacherid=597&userid=12&studentid=22&content=孩子有点感冒，让中午吃药
        //下面两句代码是从缓存中取出userid（入参）值
//        if teacherid!.isEmpty || studentid!.isEmpty || self.contentTextView.text == nil || imageUrl!.isEmpty {
//            return
//        }
        if self.teacherid == nil || self.studentid == nil || self.contentTextView.text == nil {
            return
        }
        let defalutid = NSUserDefaults.standardUserDefaults()
        let uid = defalutid.stringForKey("userid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=addentrust"
        if(self.imagePath.count == 0){
            imageUrl = ""
        }
        let param = [
            "teacherid":teacherid!,
            "studentid":studentid!,
            "userid":uid!,
            "content":self.contentTextView.text,
            "pictrue_url":imageUrl!
        ]
        Alamofire.request(.POST, url, parameters: param).response { request, response, json, error in
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
                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.mode = MBProgressHUDMode.Text
                    hud.labelText = status.errorData
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                if(status.status == "success"){
                  print("叮嘱发送成功")
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
        }
    }
//    行数
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount
    }
//    分区数
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
//    单元格
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        print("显示")
        print(self.pictureArray[indexPath.row])
        let cell:ImageCollectionViewCell  = collectV!.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as! ImageCollectionViewCell
        if(self.pictureArray.count != 0){
            cell.imageView.frame = CGRectMake(0, 0, 80, 80)
            cell.imageView.image = self.pictureArray[indexPath.row] as? UIImage
            cell.contentView.addSubview(cell.imageView)
            return cell
        }
        
        return cell
    }
//    每组之间的最小高度
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

//    发送
    func sendExhort(){
        if(i != 0){
            self.UpdatePic()
        }
        self.writeExhort()
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
                manager.requestImageForAsset(asset[j], targetSize: CGSize(width: 1000.0, height: 1000.0), contentMode: .AspectFit, options: option, resultHandler: {(result, info)->Void in
                    thumbnail = result!
                    print("图片是")
                    var temImage:CGImageRef = thumbnail.CGImage!
                    temImage = CGImageCreateWithImageInRect(temImage, CGRectMake(0, 0, 1000.0, 1000.0))!
                    let newImage = UIImage(CGImage: temImage)
                    self.imageData.append(UIImageJPEGRepresentation(newImage, 1)!)
                    self.pictureArray.addObject(newImage)
                })
            }
        }
        return thumbnail
    }
 
    //    更新图片
    func UpdatePic(){
        for i in 0..<self.imageData.count{
            let chid = NSUserDefaults.standardUserDefaults()
            let userid = chid.stringForKey("userid")
            let RanNumber = String(arc4random_uniform(1000) + 1000)
//            let name = "\(userid!)\(RanNumber)"
            isuploading = true
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                ConnectModel.uploadWithImageName(RanNumber, imageData:self.imageData[i], URL: "WriteMicroblog_upload", finish: { (data) -> Void in
                    print("返回值")
                    print(data)
                    
                })
            }
            self.imagePath.addObject(userid! + RanNumber + ".png")
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
    
    //    收键盘
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

}
