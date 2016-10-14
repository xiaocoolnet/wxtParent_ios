//
//  CDWirteCommentViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/5/31.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos
import MBProgressHUD
import Alamofire

class CDWirteCommentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let tableView = UITableView()
    var dataSource : courseware_infoInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "课件详情页"
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.createUI()
    }
    
    //    创建输入框
    func createUI(){
        
        tableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT)
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.registerClass(QCDetailsClassActiveCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier:String(indexPath.row))
        cell.selectionStyle = .None
        
        let namePic = UIImageView()
        namePic.frame = CGRectMake(10, 10, 60, 60)
        let pi = self.dataSource?.teacher_photo
        let imgUrl = microblogImageUrl + pi!
        let photourl = NSURL(string: imgUrl)
        namePic.sd_setImageWithURL(photourl, placeholderImage: UIImage(named: "默认头像"))
        namePic.layer.cornerRadius = 30
        namePic.clipsToBounds = true
        cell.contentView.addSubview(namePic)
        
        let name = UILabel()
        name.frame = CGRectMake(80, 10, 100, 30)
        name.text = self.dataSource?.teacher_name
        cell.contentView.addSubview(name)
        
        let time = UILabel()
        time.frame = CGRectMake(180, 10, WIDTH - 190, 30)
        let dateformate = NSDateFormatter()
        dateformate.dateFormat = "MM-dd HH:mm"
        let date = NSDate(timeIntervalSince1970: NSTimeInterval(self.dataSource!.courseware_time!)!)
        let str:String = dateformate.stringFromDate(date)
        time.text = str
        time.textAlignment = NSTextAlignment.Right
        cell.contentView.addSubview(time)
        
        let duty = UILabel()
        duty.frame = CGRectMake(80, 40, WIDTH - 50, 30)
        duty.text = self.dataSource?.teacher_duty
        cell.contentView.addSubview(duty)
        
        
        // 内容
        let content = UILabel()
        content.frame = CGRectMake(10, 90, WIDTH - 20, 20)
        content.text = self.dataSource!.courseware_content
        content.numberOfLines = 0
        content.sizeToFit()
        cell.contentView.addSubview(content)
        //        自适应行高
        let options : NSStringDrawingOptions = NSStringDrawingOptions.UsesLineFragmentOrigin
        let screenBounds:CGRect = UIScreen.mainScreen().bounds
        let boundingRect = String(content.text).boundingRectWithSize(CGSizeMake(screenBounds.width, 0), options: options, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(17)], context: nil)
        content.textColor = UIColor.lightGrayColor()
        let height = boundingRect.size.height + 20 + 80
        
        //  图片
        var image_h = CGFloat()
        var button:CustomBtn?
        //判断图片张数显示
        
        let pic  = self.dataSource?.coursewarePic
        if(pic!.count>0&&pic!.count<=3){
            image_h=(WIDTH - 40)/3.0
            for i in 1...pic!.count{
                var x = 12
                let pciInfo = pic![i-1]
                let imgUrl = microblogImageUrl+(pciInfo.picture_url)
                let avatarUrl = NSURL(string: imgUrl)
                let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                    if(data != nil){
                        x = x+((i-1)*Int((WIDTH - 40)/3.0 + 10))
                        button = CustomBtn()
                        button?.flag = i
                        button!.frame = CGRectMake(CGFloat(x), height, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                        let imgTmp = UIImage(data: data!)
                        
                        button!.setImage(imgTmp, forState: .Normal)
                        button?.imageView?.contentMode = .ScaleAspectFill
                        button?.clipsToBounds = true
                        if button?.imageView?.image == nil{
                            button?.setBackgroundImage(UIImage(named: "图片默认加载"), forState: .Normal)
                        }
                        button?.tag = indexPath.row
                        button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                        cell.contentView.addSubview(button!)
                        
                    }
                })
                
            }
        }
        if(pic!.count>3&&pic!.count<=6){
            image_h=(WIDTH - 40)/3.0*2 + 10
            for i in 1...pic!.count{
                if i <= 3 {
                    var x = 12
                    let pciInfo = pic![i-1]
                    if pciInfo.picture_url != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.picture_url)
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-1)*Int((WIDTH - 40)/3.0 + 10))
                                button = CustomBtn()
                                button?.flag = i
                                button!.frame = CGRectMake(CGFloat(x), height, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                                let imgTmp = UIImage(data: data!)
                                button!.setImage(imgTmp, forState: .Normal)
                                button?.imageView?.contentMode = .ScaleAspectFill
                                button?.clipsToBounds = true
                                if button?.imageView?.image == nil{
                                    button!.setImage(UIImage(named: "图片默认加载"), forState: .Normal)
                                }
                                button?.tag = indexPath.row
                                button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                                cell.contentView.addSubview(button!)
                            }
                        })
                    }}else{
                    var x = 12
                    let pciInfo = pic![i-1]
                    if pciInfo.picture_url != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.picture_url)
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-4)*Int((WIDTH - 40)/3.0 + 10))
                                button = CustomBtn()
                                button?.flag = i
                                button!.frame = CGRectMake(CGFloat(x), height+(WIDTH - 40)/3.0 + 5, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                                let imgTmp = UIImage(data: data!)
                                button!.setImage(imgTmp, forState: .Normal)
                                button?.imageView?.contentMode = .ScaleAspectFill
                                button?.clipsToBounds = true
                                if button?.imageView?.image == nil{
                                    button!.setImage(UIImage(named: "图片默认加载"), forState: .Normal)
                                }
                                button?.tag = indexPath.row
                                button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                                cell.contentView.addSubview(button!)
                            }
                        })
                        
                    }
                }
            }}
        if(pic!.count>6&&pic!.count<=9){
            image_h=(WIDTH - 40)/3.0*3+20
            for i in 1...pic!.count{
                if i <= 3 {
                    var x = 12
                    let pciInfo = pic![i-1]
                    if pciInfo.picture_url != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.picture_url)
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-1)*Int((WIDTH - 40)/3.0 + 10))
                                button = CustomBtn()
                                button?.flag = i
                                button!.frame = CGRectMake(CGFloat(x), height, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                                let imgTmp = UIImage(data: data!)
                                button!.setImage(imgTmp, forState: .Normal)
                                button?.imageView?.contentMode = .ScaleAspectFill
                                button?.clipsToBounds = true
                                if button?.imageView?.image == nil{
                                    button!.setImage(UIImage(named: "图片默认加载"), forState: .Normal)
                                }
                                button?.tag = indexPath.row
                                button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                                cell.contentView.addSubview(button!)
                            }
                        })
                        
                    }}else if (i>3&&i<=6){
                    var x = 12
                    let pciInfo = pic![i-1]
                    if pciInfo.picture_url != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.picture_url)
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-4)*Int((WIDTH - 40)/3.0 + 10))
                                button = CustomBtn()
                                button?.flag = i
                                button!.frame = CGRectMake(CGFloat(x), height+(WIDTH - 40)/3.0 + 5, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                                let imgTmp = UIImage(data: data!)
                                
                                button!.setImage(imgTmp, forState: .Normal)
                                button?.imageView?.contentMode = .ScaleAspectFill
                                button?.clipsToBounds = true
                                if button?.imageView?.image == nil{
                                    button!.setImage(UIImage(named: "图片默认加载"), forState: .Normal)
                                }
                                button?.tag = indexPath.row
                                button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                                cell.contentView.addSubview(button!)
                            }
                        })
                        
                    } }else{
                    var x = 12
                    let pciInfo = pic![i-1]
                    if pciInfo.picture_url != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.picture_url)
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-7)*Int((WIDTH - 40)/3.0 + 10))
                                button = CustomBtn()
                                button?.flag = i
                                button!.frame = CGRectMake(CGFloat(x), height+(WIDTH - 40)/3.0 + 5+(WIDTH - 40)/3.0 + 5, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                                let imgTmp = UIImage(data: data!)
                                button!.setImage(imgTmp, forState: .Normal)
                                button?.imageView?.contentMode = .ScaleAspectFill
                                button?.clipsToBounds = true
                                if button?.imageView?.image == nil{
                                    button!.setImage(UIImage(named: "图片默认加载"), forState: .Normal)
                                }
                                button?.tag = indexPath.row
                                button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                                cell.contentView.addSubview(button!)
                            }
                        })
                        
                    }
                    
                }
                
            }}
        if pic!.count > 9 {
            image_h=(WIDTH - 40)/3.0*3 + 20
            for i in 1...pic!.count{
                if i <= 3 {
                    var x = 12
                    let pciInfo = pic![i-1]
                    if pciInfo.picture_url != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.picture_url)
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-1)*Int((WIDTH - 40)/3.0 + 10))
                                print(x)
                                button = CustomBtn()
                                button?.flag = i
                                button!.frame = CGRectMake(CGFloat(x), height, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                                let imgTmp = UIImage(data: data!)
                                
                                button!.setImage(imgTmp, forState: .Normal)
                                button?.imageView?.contentMode = .ScaleAspectFill
                                button?.clipsToBounds = true
                                if button?.imageView?.image == nil{
                                    button!.setImage(UIImage(named: "图片默认加载"), forState: .Normal)
                                }
                                button?.tag = indexPath.row
                                button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                                cell.contentView.addSubview(button!)
                            }
                        })
                        
                    }}else if (i>3&&i<=6){
                    var x = 12
                    let pciInfo = pic![i-1]
                    if pciInfo.picture_url != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.picture_url)
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-4)*Int((WIDTH - 40)/3.0 + 10))
                                button = CustomBtn()
                                button?.flag = i
                                button!.frame = CGRectMake(CGFloat(x), height+(WIDTH - 40)/3.0 + 5, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                                let imgTmp = UIImage(data: data!)
                                
                                button!.setImage(imgTmp, forState: .Normal)
                                button?.imageView?.contentMode = .ScaleAspectFill
                                button?.clipsToBounds = true
                                if button?.imageView?.image == nil{
                                    button!.setImage(UIImage(named: "图片默认加载"), forState: .Normal)
                                }
                                button?.tag = indexPath.row
                                button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                                cell.contentView.addSubview(button!)
                            }
                        })
                        
                    } }else{
                    var x = 12
                    let pciInfo = pic![i-1]
                    if pciInfo.picture_url != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.picture_url)
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-7)*Int((WIDTH - 40)/3.0 + 10))
                                button = CustomBtn()
                                button?.flag = i
                                button!.frame = CGRectMake(CGFloat(x), height+(WIDTH - 40)/3.0 + 5+(WIDTH - 40)/3.0 + 5, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                                let imgTmp = UIImage(data: data!)
                                
                                button!.setImage(imgTmp, forState: .Normal)
                                button?.imageView?.contentMode = .ScaleAspectFill
                                button?.clipsToBounds = true
                                if button?.imageView?.image == nil{
                                    button!.setImage(UIImage(named: "图片默认加载"), forState: .Normal)
                                }
                                button?.tag = indexPath.row
                                button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                                cell.contentView.addSubview(button!)
                            }
                        })
                        
                    }
                    
                }
                
            }}
        
        let imageView = UIImageView()
        imageView.frame = CGRectMake(10, 10 + image_h + height, 21, 21)
        imageView.image = UIImage.init(named: "ic_fasong")
        cell.contentView.addSubview(imageView)
        
        let teacher = UILabel()
        teacher.frame = CGRectMake(41, 10 + image_h + height, 100, 20)
        teacher.text = self.dataSource?.teacher_name
        cell.contentView.addSubview(teacher)
        
        tableView.rowHeight = height + image_h + 35
        
        
        return cell
    }
    
    func clickBtn(sender:CustomBtn){
        let vc = CDPLViewController()
        vc.dataSource = (self.dataSource?.coursewarePic)!
        vc.count = sender.flag!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
