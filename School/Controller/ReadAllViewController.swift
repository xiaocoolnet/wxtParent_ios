//
//  ReadAllViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/6/4.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos
import MBProgressHUD
import Alamofire

class ReadAllViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    var table = UITableView()
    var bottomView = UIView()
    var textView = UITextView()
    var kbHeight = CGFloat()
    var i = 0
    var itemCount = 0
    var pictureArray = NSMutableArray()
    var imageData:[NSData] = []
    var isuploading = false
    var imageUrl:String?
    var imagePath = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "新闻动态"
        self.tabBarController?.tabBar.hidden = true
        self.createTable()
        self.createBottomView()
//        监听键盘
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ReadAllViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
    }
//    键盘出现时
    func keyboardWillShow(noti:NSNotification){
        // 获取键盘的高度
        let kbEndFrm:CGRect = (noti.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue())!
        kbHeight = kbEndFrm.size.height
        self.view.frame.origin.y = self.view.frame.origin.y - kbHeight
    }
//    键盘消失时
    func keyboardWillHide(){
        self.view.frame.origin.y = self.view.frame.origin.y + kbHeight
        self.view.endEditing(true)
    }
//    创建表
    func createTable(){
        table = UITableView(frame: CGRectMake(0, 0, WIDTH, HEIGHT-64-50))
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 300
        table.separatorStyle = .None
        table.backgroundColor = RGBA(242.0, g: 242.0, b: 242.0, a: 1)
        self.view.addSubview(table)
        
        table.registerNib(UINib.init(nibName: "ReadAllTableViewCell", bundle: nil), forCellReuseIdentifier: "ReadAllCell")
    }
//    创建底部视图
    func createBottomView(){
        let v = UIView(frame: CGRectMake(0,HEIGHT-114,WIDTH,50))
        v.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(v)
        
        let dianzanBtn = UIButton(frame: CGRectMake(WIDTH-80,15,20,20))
        dianzanBtn.setBackgroundImage(UIImage(named: "点赞"), forState: .Normal)
        dianzanBtn.setBackgroundImage(UIImage(named: "已点赞"), forState: .Selected)
        //循环遍历点赞数量，对比是否自己点过赞
//        for i in 0..<dianzanSource.count{
//            let dianzanInfo = self.dianzanSource.dianzanlist[i]
//            //如果点过赞，则显示点赞图标
//            let userid = NSUserDefaults.standardUserDefaults()
//            let uid = userid.stringForKey("userid")
//            if(dianzanInfo.dianZanId == uid){
//                dianzanBtn.selected = true
//                dianzanBtn.setBackgroundImage(UIImage(named: "已点赞"), forState:.Normal)
//            }else{//如果没点过赞，显示灰色图标
//                dianzanBtn.selected = false
//                dianzanBtn.setBackgroundImage(UIImage(named: "点赞"), forState: .Normal)
//            }
//        }
        
        dianzanBtn.addTarget(self, action: #selector(ReadAllViewController.dianzan(_:)), forControlEvents: .TouchUpInside)
        v.addSubview(dianzanBtn)
        
        let pinglunBtn = UIButton(frame: CGRectMake(WIDTH-40,15,20,20))
        pinglunBtn.setBackgroundImage(UIImage(named: "评论"), forState: .Normal)
        pinglunBtn.addTarget(self, action: #selector(ReadAllViewController.pinglun), forControlEvents: .TouchUpInside)
        v.addSubview(pinglunBtn)
    }
//    点赞
    func dianzan(sender:UIButton){
        let btn:UIButton = sender
//        let noticeInfo = self.noticeSource.objectlist[btn.tag]
        if btn.selected {
            btn.selected = false
//            self.xuXiaoDianZan(noticeInfo.id!)
        }else{
            btn.selected = true
//            self.getDianZan(noticeInfo.id!)
        }
    }
//    评论
    func pinglun(){
        bottomView = UIView(frame: CGRectMake(0,HEIGHT-114,WIDTH,50))
        bottomView.backgroundColor = UIColor.whiteColor()
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bottomView)
        
//        选择图片的按钮
        let choosePicBtn = UIButton(frame: CGRectMake(10,10,30,30))
        choosePicBtn.setImage(UIImage(named: "添加"), forState: .Normal)
        choosePicBtn.addTarget(self, action: #selector(ReadAllViewController.addPictrue), forControlEvents: .TouchUpInside)
        bottomView.addSubview(choosePicBtn)
//        输入框
        textView = UITextView(frame:CGRectMake(50, 10, WIDTH-120,30))
        textView.backgroundColor = RGBA(242.0, g: 242.0, b: 242.0, a: 1)
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 10
        bottomView.addSubview(textView)
//        发送按钮
        let sendBtn = UIButton(frame: CGRectMake(WIDTH-60,10,50,30))
        sendBtn.backgroundColor = RGBA(140.0, g: 226.0, b: 163.0, a: 1)
        sendBtn.setTitle("发送", forState: .Normal)
        sendBtn.layer.masksToBounds = true
        sendBtn.layer.cornerRadius = 10
        sendBtn.addTarget(self, action: #selector(ReadAllViewController.sendComment), forControlEvents: .TouchUpInside)
        bottomView.addSubview(sendBtn)
        
    }
//    添加图片
    func addPictrue(){
        let vc = BSImagePickerViewController()
        vc.maxNumberOfSelections = 1
        bs_presentImagePickerController(vc, animated: true,
                                        select: { (asset: PHAsset) -> Void in
            }, deselect: { (asset: PHAsset) -> Void in
            }, cancel: { (assets: [PHAsset]) -> Void in
            }, finish: { (assets: [PHAsset]) -> Void in
                self.getAssetThumbnail(assets)
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.UpdatePic()
                }
            }, completion: nil)
    }
    //    选择图片
    func getAssetThumbnail(asset: [PHAsset]) -> UIImage {
        var thumbnail = UIImage()
        i+=asset.count
        if(i>1){
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
            let name = "\(userid!)\(RanNumber)"
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
//    发表评论
    func sendComment(){
        if !textView.text.isEmpty{
            self.keyboardWillHide()
            self.bottomView.removeFromSuperview()
        }else{
            let alert = UIAlertController(title: "提示", message: "输入内容不能为空", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
//    行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
//    单元格
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ReadAllCell", forIndexPath: indexPath) as! ReadAllTableViewCell
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("111111")
    }
    

}
