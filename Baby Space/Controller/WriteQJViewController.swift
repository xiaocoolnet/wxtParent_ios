//
//  WriteQJViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/5/5.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import BSImagePicker
import Photos

class WriteQJViewController: UIViewController,HZQDatePickerViewDelegate,ToolTwoProrocol,ToolTwoProrocol1, UICollectionViewDataSource,UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TZImagePickerControllerDelegate{

    var studentid : String!
    var teacherid : String!
    var teacherName:String?
    var studentName:String?
    var scrollView = UIScrollView()
    let btn = UIButton()//开始时间按钮
    let btn1 = UIButton()//截止时间按钮
    let lbl2 = UILabel()//请假者
    let lbl4 = UILabel()//接收人
    let lbl8 = UILabel()//请假类型
//    var param = NSMutableDictionary()
    //  开始事件
    
    var dateformate : NSDateFormatter!
    var begintime : NSTimeInterval!
    //  结束时间
    var endtime : NSTimeInterval!
    //  userid
    var uid : String!
    
    let rightButton = UIButton()
    
    let contentTextView = BRPlaceholderTextView()
    var pikerView = HZQDatePickerView()
    
    var itemCount = 0
    var collectionV:UICollectionView?
    var flowLayout = UICollectionViewFlowLayout()
    var imageData:[NSData] = []
    var isuploading = false
    var imageUrl:String?
    var i = 0
    var imagePath = NSMutableArray()
    var pictureArray = NSMutableArray()
    var addPictureBtn = UIButton()
    var picture = UIImageView()
  
    override func viewDidLoad() {

        super.viewDidLoad()
        self.tabBarController?.tabBar.hidden = true

        XKeyBoard.registerKeyBoardHide(self)
        XKeyBoard.registerKeyBoardShow(self)
        self.title = "在线请假"
        
        rightButton.frame = CGRectMake(0, 0, 40, 20)
        rightButton.setTitle("发送", forState: .Normal)
        
        rightButton.addTarget(self, action: #selector(sendQJ), forControlEvents: .TouchUpInside)
        let rightBtn = UIBarButtonItem(customView: rightButton)
        self.navigationItem.rightBarButtonItem = rightBtn

        
        self.createUI()
        
        

    }
    
    //    创建UI
    func createUI(){
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
       
        
        
        let v1 = UIView()
        v1.frame = CGRectMake(0, 0, self.view.frame.size.width, 121)
        v1.backgroundColor = UIColor.whiteColor()
        scrollView.addSubview(v1)
        
        let lbl1 = UILabel()
        lbl1.frame = CGRectMake(10, 20, 60, 20)
        lbl1.text = "请假者"
        lbl1.font = UIFont.systemFontOfSize(15)
        lbl1.textColor = UIColor(red: 171/255.0, green: 171/255.0, blue: 171/255.0, alpha: 1)
        v1.addSubview(lbl1)
        
        
        lbl2.frame = CGRectMake(80, 20, 100, 20)
        v1.addSubview(lbl2)
        
        let btn11 = UIButton(type: .Custom)
        btn11.frame = CGRectMake(WIDTH-30, 20, 20, 20)
        btn11.setImage(UIImage(named: "右边剪头.png"), forState: .Normal)
//        btn11.addTarget(self, action: #selector(WriteQJViewController.chooseStudent), forControlEvents: .TouchUpInside)
        v1.addSubview(btn11)
        
        let firstBtn = UIButton(type: .Custom)
        firstBtn.frame = CGRectMake(10, 20, WIDTH - 10, 60)
        firstBtn.backgroundColor = UIColor.clearColor()
        firstBtn.addTarget(self, action: #selector(WriteQJViewController.chooseStudent), forControlEvents: .TouchUpInside)
        v1.addSubview(firstBtn)
        
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
        btn2.addTarget(self, action: #selector(WriteQJViewController.chooseTeacher), forControlEvents: .TouchUpInside)
        v1.addSubview(btn2)
        
        let secondBtn = UIButton(type: .Custom)
        secondBtn.frame = CGRectMake(10, 61, WIDTH, 59)
        secondBtn.backgroundColor = UIColor.clearColor()
        secondBtn.addTarget(self, action: #selector(WriteQJViewController.chooseTeacher), forControlEvents: .TouchUpInside)
        v1.addSubview(secondBtn)
        
        let v2 = UIView()
        v2.frame = CGRectMake(0, 131, self.view.frame.size.width, 121)
        v2.backgroundColor = UIColor.whiteColor()
        scrollView.addSubview(v2)
        
        let lbl5 = UILabel()
        lbl5.frame = CGRectMake(10, 20, 60, 20)
        lbl5.text = "开始时间"
        lbl5.font = UIFont.systemFontOfSize(15)
        lbl5.textColor = UIColor.blackColor()
        v2.addSubview(lbl5)
        
        btn.frame = CGRectMake(10, 0, WIDTH - 10, 60)
//        btn.setTitle("选择时间", forState: .Normal)
        btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        btn.addTarget(self, action: #selector(WriteQJViewController.selectTime(_:)), forControlEvents: .TouchUpInside)
        btn.tag = 99
        v2.addSubview(btn)
        
        let imageView1 = UIImageView()
        imageView1.frame = CGRectMake(WIDTH-20, 20, 10, 20)
        imageView1.image = UIImage(named: "右边剪头.png")
        v2.addSubview(imageView1)
        
        let lineView1 = UIView()
        lineView1.frame = CGRectMake(0, 61, self.view.frame.size.width, 1)
        lineView1.backgroundColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1)
        v2.addSubview(lineView1)
        
        let lbl6 = UILabel()
        lbl6.frame = CGRectMake(10, 81, 60, 20)
        lbl6.text = "截止时间"
        lbl6.font = UIFont.systemFontOfSize(15)
        lbl6.textColor = UIColor.blackColor()
        v2.addSubview(lbl6)
        
        btn1.frame = CGRectMake(10, 61, WIDTH, 60)
//        btn1.setTitle("选择时间", forState: .Normal)
        btn1.setTitleColor(UIColor.blackColor(), forState: .Normal)
        btn1.addTarget(self, action: #selector(WriteQJViewController.selectTime(_:)), forControlEvents: .TouchUpInside)
        btn1.tag = 100
        v2.addSubview(btn1)
        
        let imageView2 = UIImageView()
        imageView2.frame = CGRectMake(WIDTH-20, 81, 10, 20)
        imageView2.image = UIImage(named: "右边剪头.png")
        v2.addSubview(imageView2)
        
        let v3 = UIView()
        v3.frame = CGRectMake(0, 262, self.view.frame.size.width, 50)
        v3.backgroundColor = UIColor.whiteColor()
        scrollView.addSubview(v3)
        
        let lbl7 = UILabel()
        lbl7.frame = CGRectMake(10, 15, 60, 20)
        lbl7.text = "请假类型"
        lbl7.font = UIFont.systemFontOfSize(15)
        lbl7.textColor = UIColor.blackColor()
        v3.addSubview(lbl7)
        
        lbl8.frame = CGRectMake(WIDTH-90, 15, 60, 20)
        lbl8.font = UIFont.systemFontOfSize(15)
        lbl8.textColor = UIColor.blackColor()
        lbl8.textAlignment = .Right
        v3.addSubview(lbl8)
        
        let typeBtn = UIButton(type: .Custom)
        typeBtn.frame = CGRectMake(WIDTH-20, 15, 10, 20)
        typeBtn.setImage(UIImage(named: "右边剪头.png"), forState: .Normal)
        typeBtn.addTarget(self, action: #selector(WriteQJViewController.chooseType), forControlEvents: .TouchUpInside)
        v3.addSubview(typeBtn)
        
        let type = UIButton(type: .Custom)
        type.frame = CGRectMake(10, 0, WIDTH - 10, 50)
        type.backgroundColor = UIColor.clearColor()
        type.addTarget(self, action: #selector(WriteQJViewController.chooseType), forControlEvents: .TouchUpInside)
        v3.addSubview(type)
        
        
        self.contentTextView.frame = CGRectMake(0, 322, self.view.bounds.width, 150)
        self.contentTextView.font = UIFont.systemFontOfSize(15)
        self.contentTextView.placeholder = "请输入请假事由"
        scrollView.addSubview(self.contentTextView)
        
        //  添加图片
        let addImageButton = UIButton()
        addImageButton.frame = CGRectMake(10, 480, 60, 60)
        addImageButton.setBackgroundImage(UIImage(named: "add2"), forState: .Normal)
        addImageButton.addTarget(self, action: #selector(addImage), forControlEvents: .TouchUpInside)
        
        scrollView.addSubview(addImageButton)
        
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
        self.collectionV = UICollectionView.init(frame: CGRectMake(0, 540, WIDTH, height), collectionViewLayout: flowl)
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
    
    
    
    func addImage(btn:UIButton){
        
        
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
    func sendQJ(){
        if teacherid == nil || studentid == nil || (btn.titleLabel?.text!)! == "" || self.contentTextView.text == "" || (btn1.titleLabel?.text!)! == "" || self.lbl8.text == nil{
            messageHUD(self.view, messageData: "请补全假条信息")
            
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
        self.writeQJ()
        
    }

    //  选择学生
    func chooseStudent(){
        let vc = LeaveChildViewController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //    代理方法
    func didRecieveChildInfo(studentid: String, studentName: String) {
        self.studentid = studentid
        self.studentName = studentName
        self.lbl2.text = studentName
    }
    //  选择老师
    func chooseTeacher(){
        let vc = LeaveteacherViewController()
        if self.studentid.isEmpty {
            let alert = UIAlertController(title: "提示", message: "请先选择请假者", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler:nil))
            alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }else{
            vc.studentid = self.studentid
            vc.delegate = self
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func didRecieveTeacherInfo(teacherid:String,teacherName:String){
        self.teacherid = teacherid
        self.teacherName = teacherName
        self.lbl4.text = self.teacherName
    }
//    选择请假类型
    func chooseType(){
        let alert = UIAlertController()
        alert.addAction(UIAlertAction(title: "事假", style: .Default, handler: { (UIAlertAction) -> Void in
            self.lbl8.text = "事假"
        }))
        alert.addAction(UIAlertAction(title: "病假", style: .Default, handler: { (UIAlertAction) -> Void in
            self.lbl8.text = "病假"
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    
    }
//    写请假条
    func writeQJ(){
        
        if teacherid == nil || studentid == nil || (btn.titleLabel?.text!)! == "" || self.contentTextView.text == "" || (btn1.titleLabel?.text!)! == "" {
            messageHUD(self.view, messageData: "请补全假条信息")
        }else{
            
            //     将字符串转换成时间戳
            let dateformate = NSDateFormatter()
            dateformate.dateFormat = "yyyy-MM-dd"
            let date = dateformate.dateFromString((btn.titleLabel?.text!)!)
            let begintime:NSTimeInterval = (date?.timeIntervalSince1970)!
            let date1 = dateformate.dateFromString((btn1.titleLabel?.text!)!)
            let endtime:NSTimeInterval = (date1?.timeIntervalSince1970)!
            
            //下面两句代码是从缓存中取出userid（入参）值
            let defalutid = NSUserDefaults.standardUserDefaults()
            let uid = defalutid.stringForKey("userid")
            let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=addleave"
            if(self.imagePath.count == 0){
                imageUrl = ""
            }
            let param = [
                "teacherid":teacherid,
                "studentid":studentid,
                "parentid":uid!,
                "begintime":begintime,
                "endtime":endtime,
                "reason":self.contentTextView.text,
                "picture_url":imageUrl!,
                "leavetype":String(self.lbl8.text)
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
                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        hud.mode = MBProgressHUDMode.Text
                        hud.labelText = status.errorData
                        hud.margin = 10.0
                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 1)
                    }
                    if(status.status == "success"){
                        print("请假条发送成功")
                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        hud.mode = MBProgressHUDMode.Text
                        hud.labelText = "请假条发送成功"
                        hud.margin = 10.0
                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 1)
                        self.view.endEditing(true)
                        // 返回上一个界面
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                }
            }
        }
    }
//    选择时间
    func selectTime(sender:UIButton){
        let btn:UIButton = sender
        self.pikerView = HZQDatePickerView.instanceDatePickerView()
        self.pikerView.frame = CGRectMake(0, 0, WIDTH, HEIGHT)
        self.pikerView.backgroundColor = UIColor.clearColor()
            self.pikerView.delegate = self
        
        if btn.tag == 99 {
            self.pikerView.type = DateTypeOfStart
        }
        else if btn.tag == 100{
           self.pikerView.type = DateTypeOfEnd
        }
        self.pikerView.datePickerView.minimumDate = NSDate()
        self.view.addSubview(self.pikerView)
    }
    func getSelectDate(date: String!, type: DateType) {
        if type == DateTypeOfStart{
            btn.setTitle(date, forState: .Normal)
            btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        }
        else if type == DateTypeOfEnd{
            btn1.setTitle(date, forState: .Normal)
            btn1.setTitleColor(UIColor.blackColor(), forState: .Normal)
        }
        
        
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
    
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.contentTextView.resignFirstResponder()
    }
    
    
}
