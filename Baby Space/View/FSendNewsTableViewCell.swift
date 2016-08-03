//
//  FSendNewsTableViewCell.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/26.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class FSendNewsTableViewCell: UITableViewCell {
    
    var contentLabel = UILabel()
    var teacherLabel = UILabel()
    var comment = UIButton()
    var timeLabel = UILabel()
    var dianzanBtn = UIButton()
    var allLable = UILabel()
    var already = UILabel()
    var weiDu = UILabel()
    var picBtn = UIButton()
    var zong = UILabel()
    var yiDu = UILabel()
    var meiDu = UILabel()
//    var button = UIButton()
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
       
        contentLabel.textColor = UIColor.lightGrayColor()
        contentView.addSubview(contentLabel)
        contentView.addSubview(teacherLabel)
        contentView.addSubview(comment)
        
        timeLabel.textColor = UIColor.lightGrayColor()
        timeLabel.font = UIFont.systemFontOfSize(15)
        contentView.addSubview(timeLabel)
        contentView.addSubview(dianzanBtn)
        contentView.addSubview(allLable)
        contentView.addSubview(weiDu)
        contentView.addSubview(picBtn)
        
        zong.text = "总发"
        contentView.addSubview(zong)
        
        yiDu.text = "已阅读"
        contentView.addSubview(yiDu)
        
        meiDu.text = "未读"
        contentView.addSubview(meiDu)
        
//        contentView.addSubview(button)
        
    }
    
    func showCell(model:FSendInfo){
        //  图片
        var image_h = CGFloat()
        let pic = model.picture
        let recModel = model.receiver
        var button : UIButton?
        
        
        //判断图片张数显示
        if(pic.count>0&&pic.count<=3){
            image_h=(WIDTH - 40)/3.0
            for i in 1...pic.count{
                var x = 12
                let pciInfo = pic[i-1]
                let imgUrl = microblogImageUrl+(pciInfo.picture_url)
                print(imgUrl)
                
                //let image = self.imageCache[imgUrl] as UIImage?
                let avatarUrl = NSURL(string: imgUrl)
                let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                    if(data != nil){
                        x = x+((i-1)*Int((WIDTH - 40)/3.0 + 10))
                        //                        blogimage = UIImageView(frame: CGRectMake(CGFloat(x), 150, 110, 80))
                        button = UIButton()
                        button!.frame = CGRectMake(CGFloat(x), 40, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                        let imgTmp = UIImage(data: data!)
                        //self.imageCache[imgUrl] = imgTmp
                        //                        blogimage!.image = imgTmp
                        //                        if blogimage?.image==nil{
                        //                            blogimage?.image=UIImage(named: "Logo")
                        //                        }
                        //                        cell.addSubview(blogimage!)
                        button!.setImage(imgTmp, forState: .Normal)
//                        button?.tag = indexPath.row
//                        button.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                        
                        self.contentView.addSubview(button!)
                        
                    }
                })
                
            }
        }
        if(pic.count>3&&pic.count<=6){
            image_h=(WIDTH - 40)/3.0*2 + 10
            for i in 1...pic.count{
                if i <= 3 {
                    var x = 12
                    let pciInfo = pic[i-1]
                    if pciInfo.picture_url != "" {
                        
                        
                        let imgUrl = microblogImageUrl+(pciInfo.picture_url)
                        
                        //let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-1)*Int((WIDTH - 40)/3.0 + 10))
                                button = UIButton()
                                button!.frame = CGRectMake(CGFloat(x), 40, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                                
                                let imgTmp = UIImage(data: data!)
                                //self.imageCache[imgUrl] = imgTmp
                                //                                blogimage!.image = imgTmp
                                //                                if blogimage?.image==nil{
                                //                                    blogimage?.image=UIImage(named: "Logo")
                                //                                }
                                //
                                //                                cell.addSubview(blogimage!)
                                button!.setImage(imgTmp, forState: .Normal)
//                                button?.tag = indexPath.row
//                                button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                                self.contentView.addSubview(button!)
                            }
                        })
                    }}else{
                    var x = 12
                    let pciInfo = pic[i-1]
                    if pciInfo.picture_url != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.picture_url)
                        
                        //let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-4)*Int((WIDTH - 40)/3.0 + 10))
                                button = UIButton()
                                button!.frame = CGRectMake(CGFloat(x), 40+(WIDTH - 40)/3.0 + 5, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                                let imgTmp = UIImage(data: data!)
                                //self.imageCache[imgUrl] = imgTmp
                                //                                blogimage!.image = imgTmp
                                //                                if blogimage?.image==nil{
                                //                                    blogimage?.image=UIImage(named: "Logo")
                                //                                }
                                //                                cell.addSubview(blogimage!)
                                button!.setImage(imgTmp, forState: .Normal)
//                                button?.tag = indexPath.row
//                                button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                                self.contentView.addSubview(button!)
                            }
                        })
                        
                    }
                }
            }}
        if(pic.count>6&&pic.count<=9){
            image_h=(WIDTH - 40)/3.0*3+20
            for i in 1...pic.count{
                if i <= 3 {
                    var x = 12
                    let pciInfo = pic[i-1]
                    if pciInfo.picture_url != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.picture_url)
                        
                        //let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-1)*Int((WIDTH - 40)/3.0 + 10))
                                button = UIButton()
                                button!.frame = CGRectMake(CGFloat(x), 40, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                                let imgTmp = UIImage(data: data!)
                                
                                button!.setImage(imgTmp, forState: .Normal)
//                                button?.tag = indexPath.row
//                                button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                                self.contentView.addSubview(button!)
                            }
                        })
                        
                    }}else if (i>3&&i<=6){
                    var x = 12
                    let pciInfo = pic[i-1]
                    if pciInfo.picture_url != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.picture_url)
                        
                        //let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-4)*Int((WIDTH - 40)/3.0 + 10))
                                button = UIButton()
                                button!.frame = CGRectMake(CGFloat(x), 40+(WIDTH - 40)/3.0 + 5, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                                let imgTmp = UIImage(data: data!)
                                
                                button!.setImage(imgTmp, forState: .Normal)
//                                button?.tag = indexPath.row
//                                button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                                self.contentView.addSubview(button!)
                            }
                        })
                        
                    } }else{
                    var x = 12
                    let pciInfo = pic[i-1]
                    if pciInfo.picture_url != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.picture_url)
                        
                        //let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-7)*Int((WIDTH - 40)/3.0 + 10))
                                button = UIButton()
                                button!.frame = CGRectMake(CGFloat(x), 40+(WIDTH - 40)/3.0 + 5+(WIDTH - 40)/3.0 + 5, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                                let imgTmp = UIImage(data: data!)
                                //self.imageCache[imgUrl] = imgTmp
                                //                                blogimage!.image = imgTmp
                                //                                if blogimage?.image==nil{
                                //                                    blogimage?.image=UIImage(named: "Logo")
                                //                                }
                                //                                cell.addSubview(blogimage!)
                                button!.setImage(imgTmp, forState: .Normal)
//                                button?.tag = indexPath.row
//                                button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                                self.contentView.addSubview(button!)
                            }
                        })
                        
                    }
                    
                }
                
            }}
        if pic.count > 9 {
            image_h=(WIDTH - 40)/3.0*3 + 20
            for i in 1...pic.count{
                if i <= 3 {
                    var x = 12
                    let pciInfo = pic[i-1]
                    if pciInfo.picture_url != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.picture_url)
                        
                        //let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-1)*Int((WIDTH - 40)/3.0 + 10))
                                print(x)
                                button = UIButton()
                                button!.frame = CGRectMake(CGFloat(x), 40, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                                let imgTmp = UIImage(data: data!)
                                //self.imageCache[imgUrl] = imgTmp
                                //                                blogimage!.image = imgTmp
                                //                                if blogimage?.image==nil{
                                //                                    blogimage?.image=UIImage(named: "Logo")
                                //                                }
                                //                                cell.addSubview(blogimage!)
                                button!.setImage(imgTmp, forState: .Normal)
//                                button?.tag = indexPath.row
//                                button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                                self.contentView.addSubview(button!)
                            }
                        })
                        
                    }}else if (i>3&&i<=6){
                    var x = 12
                    let pciInfo = pic[i-1]
                    if pciInfo.picture_url != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.picture_url)
                        
                        //let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-4)*Int((WIDTH - 40)/3.0 + 10))
                                button = UIButton()
                                button!.frame = CGRectMake(CGFloat(x), 40+(WIDTH - 40)/3.0 + 5, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                                let imgTmp = UIImage(data: data!)
                                //self.imageCache[imgUrl] = imgTmp
                                //                                blogimage!.image = imgTmp
                                //                                if blogimage?.image==nil{
                                //                                    blogimage?.image=UIImage(named: "Logo")
                                //                                }
                                //                                cell.addSubview(blogimage!)
                                button!.setImage(imgTmp, forState: .Normal)
//                                button?.tag = indexPath.row
//                                button?.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
                                self.contentView.addSubview(button!)
                            }
                        })
                        
                    } }else{
                    var x = 12
                    let pciInfo = pic[i-1]
                    if pciInfo.picture_url != "" {
                        let imgUrl = microblogImageUrl+(pciInfo.picture_url)
                        
                        //let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-7)*Int((WIDTH - 40)/3.0 + 10))
                                button = UIButton()
                                button!.frame = CGRectMake(CGFloat(x), 40+(WIDTH - 40)/3.0 + 5+(WIDTH - 40)/3.0 + 5, (WIDTH - 40)/3.0, (WIDTH - 40)/3.0)
                                let imgTmp = UIImage(data: data!)
                                //self.imageCache[imgUrl] = imgTmp
                                //                                blogimage!.image = imgTmp
                                //                                if blogimage?.image==nil{
                                //                                    blogimage?.image=UIImage(named: "Logo")
                                //                                }
                                //                                cell.addSubview(blogimage!)
                                button!.setImage(imgTmp, forState: .Normal)
//                                button?.tag = indexPath.row
//                                button?.addTarget(self, action: #selector(self.clickBtn(_:)), forControlEvents: .TouchUpInside)
                                self.contentView.addSubview(button!)
                            }
                        })
                        
                    }
                    
                }
                
            }
        }
        //        tableView.rowHeight=100+image_h
        
        
        
        
        contentLabel.frame = CGRectMake(10, 10, WIDTH - 20, 30)
        teacherLabel.frame = CGRectMake(40, 40 + image_h + 10, 100, 20)
        timeLabel.frame = CGRectMake(WIDTH - 150, 40 + image_h + 10, 140, 20)
        timeLabel.textAlignment = NSTextAlignment.Right
        
        zong.frame = CGRectMake(10, 70 + image_h + 20, 30, 20)
        zong.font = UIFont.systemFontOfSize(15)
        allLable.frame = CGRectMake(40, 70 + image_h + 20, 20, 20)
        allLable.font = UIFont.systemFontOfSize(15)
        yiDu.frame = CGRectMake(65, 70 + image_h + 20, 30, 20)
        yiDu.font = UIFont.systemFontOfSize(15)
        already.frame = CGRectMake(95, 70 + image_h + 20, 20, 20)
        already.font = UIFont.systemFontOfSize(15)
        meiDu.frame = CGRectMake(120, 70 + image_h + 20, 30, 20)
        meiDu.font = UIFont.systemFontOfSize(15)
        weiDu.frame = CGRectMake(150, 70 + image_h + 20, 20, 20)
        weiDu.font = UIFont.systemFontOfSize(15)
        
        let line = UILabel()
        line.frame = CGRectMake(1, 80, WIDTH - 2, 0.5)
        line.backgroundColor = UIColor.lightGrayColor()
        self.contentView.addSubview(line)
        
        
        
        //        for i in 0...messageModel.count {
        //            let strInfo = messageModel[i]
        //            cell.contentLabel.text = strInfo.message_content
        //            cell.teacherLabel.text = strInfo.send_user_name
        //
        //            let dateformate = NSDateFormatter()
        //            dateformate.dateFormat = "yyyy-MM-dd HH:mm"
        //            let date = NSDate(timeIntervalSince1970: NSTimeInterval(strInfo.message_time!)!)
        //             cell.timeLabel.text = dateformate.stringFromDate(date)
        ////            cell.timeLabel.text = str
        //
        //        }
        //        cell.zong.text = ""
        
        allLable.text = String(recModel.count)
        

    }
    
 
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
