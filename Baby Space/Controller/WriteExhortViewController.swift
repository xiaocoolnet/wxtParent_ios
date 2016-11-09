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
class WriteExhortViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,ToolProrocol,ToolProrocol1, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TZImagePickerControllerDelegate{

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
    var collectionV:UICollectionView?
    var flowLayout = UICollectionViewFlowLayout()
    var scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.tabBarController?.tabBar.hidden = true
        self.title = "叮嘱"
        self.view.backgroundColor = RGBA(242.0, g: 242.0, b: 242.0, a: 1)
        let rightItem = UIBarButtonItem(title: "发送", style: .Done, target: self, action: #selector(WriteExhortViewController.sendExhort))
        self.navigationItem.rightBarButtonItem = rightItem
        
        scrollView = UIScrollView(frame: CGRectMake(0, 0, WIDTH, HEIGHT-49))
        scrollView.backgroundColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1)
        //        scrollView.contentSize = CGSizeMake(WIDTH, HEIGHT+200)
        scrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(scrollView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(WriteQJViewController.keyboardHidden))
        //            手指头
        tap.numberOfTapsRequired = 1
        //            单击
        tap.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(tap)
        
        self.createUI()
    }

//    创建UI
    func createUI(){
        
        let v1 = UIView()
        v1.frame = CGRectMake(0, 0, self.view.frame.size.width, 121)
        v1.backgroundColor = UIColor.whiteColor()
        self.scrollView.addSubview(v1)
        
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
//        btn1.addTarget(self, action: #selector(WriteExhortViewController.chooseStudent), forControlEvents: .TouchUpInside)
        v1.addSubview(btn1)
        
        let button1 = UIButton(type: .Custom)
        button1.frame = CGRectMake(10, 20, WIDTH, 60)
        button1.backgroundColor = UIColor.clearColor()
        button1.addTarget(self, action: #selector(WriteExhortViewController.chooseStudent), forControlEvents: .TouchUpInside)
        v1.addSubview(button1)
        
        let lineView = UIView()
        lineView.frame = CGRectMake(0, 61, self.view.frame.size.width, 9)
        lineView.backgroundColor = RGBA(242.0, g: 242.0, b: 242.0, a: 1)
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
//        btn2.addTarget(self, action: #selector(WriteExhortViewController.chooseTeacher), forControlEvents: .TouchUpInside)
        v1.addSubview(btn2)
        
        let button2 = UIButton(type: .Custom)
        button2.frame = CGRectMake(10, 61, WIDTH, 59)
        button2.backgroundColor = UIColor.clearColor()
        button2.addTarget(self, action: #selector(WriteExhortViewController.chooseTeacher), forControlEvents: .TouchUpInside)
        v1.addSubview(button2)
        
        self.contentTextView.frame = CGRectMake(0, 131, self.view.bounds.width , 150)
        self.contentTextView.font = UIFont.systemFontOfSize(15)
        self.contentTextView.placeholder = "说说您的叮嘱"
        self.contentTextView.addMaxTextLengthWithMaxLength(200) { (contentTextView) -> Void in
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.mode = MBProgressHUDMode.Text
            hud.labelText = "超过200字啦"
            hud.margin = 10.0
            hud.removeFromSuperViewOnHide = true
            hud.hide(true, afterDelay: 3)
        }
    
//        let backGroudView = UIView(frame: CGRectMake(0,281,WIDTH,HEIGHT-281-49))
////        let height = HEIGHT-331-49
//        backGroudView.backgroundColor = RGBA(242.0, g: 242.0, b: 242.0, a: 1)
//        self.scrollView.addSubview(backGroudView)
        addPictureBtn.frame = CGRectMake(10,281, 59, 59)
        addPictureBtn.setBackgroundImage(UIImage(named: "add2"), forState: .Normal)
//        addPictureBtn.layer.borderWidth = 2.0
//        addPictureBtn.layer.borderColor = UIColor.lightGrayColor().CGColor
        addPictureBtn.addTarget(self, action: #selector(WriteExhortViewController.AddPictrures), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.scrollView.addSubview(self.contentTextView)

        scrollView.addSubview(addPictureBtn)
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
        //http://wxt.xiaocool.net/index.php?g=apps&m=student&a=addentrust&teacherid=597&userid=12&studentid=22&content=孩子有点感冒，让中午吃药&picture_url=1.png,2.png
        //下面两句代码是从缓存中取出userid（入参）值
//        if teacherid!.isEmpty || studentid!.isEmpty || self.contentTextView.text == nil || imageUrl!.isEmpty {
//            return
//        }
        if self.teacherid == nil || self.studentid == nil || self.contentTextView.text == "" {
            messageHUD(self.view, messageData: "请补全叮嘱信息")
        }else{
            
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
                "picture_url":imageUrl!
            ]
            print("wertrewdfgh")
            print(imageUrl)
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
        self.collectionV = UICollectionView.init(frame: CGRectMake(0, 340, WIDTH, height), collectionViewLayout: flowl)
        collectionV!.backgroundColor = UIColor.whiteColor()
        collectionV!.delegate = self
        collectionV!.dataSource = self
        collectionV!.registerNib(UINib(nibName: "PicNumCollectionViewCell",bundle: nil), forCellWithReuseIdentifier: "photo")
        //        self.collectionV?.registerClass(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "Photo")
        //        collectionV?.backgroundColor = UIColor.redColor()//测试用
        self.scrollView.addSubview(collectionV!)
        
        scrollView.contentSize = CGSizeMake(WIDTH, ((collectionV?.frame.maxY)! + 20))
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
    //   更新日记
    func sendExhort(){
        
        if self.teacherid == nil || self.studentid == nil || self.contentTextView.text == "" {
            messageHUD(self.view, messageData: "请补全叮嘱信息")
            
        }else{
            self.UpdatePic()
            
        }
        
        
    }
    //    更新图片
    func UpdatePic(){
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
        self.writeExhort()
    }
    
    //    收键盘
    func keyboardHidden(){
        self.contentTextView.endEditing(true)
    }
    //        键盘消失的通知方法
    func keyboardWillHideNotification(notification:NSNotification){
        UIView.animateWithDuration(0.3) { () -> Void in
            self.view.frame.origin.y = self.view.frame.origin.y + 200
            self.view.layoutIfNeeded()
        }
        
    }
    //     键盘出现的通知方法
    func keyboardWillShowNotification(notification:NSNotification){
        UIView.animateWithDuration(0.3) { () -> Void in
            self.view.frame.origin.y = self.view.frame.origin.y - 200
            self.view.layoutIfNeeded()
        }
    }
    
    //    收键盘
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

}
