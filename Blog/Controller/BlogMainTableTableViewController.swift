//
//  BlogMainTableTableViewController.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/1/22.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import ImageSlideshow
import XWSwiftRefresh

class BlogMainTableTableViewController: UITableViewController {

    @IBOutlet var sourceList: UITableView!
    @IBOutlet weak var scrollImageView: ImageSlideshow!

    var blogSource = BlogList()
    var pciSource = PictureList()
    var imageCache = Dictionary<String,UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollImageView.slideshowInterval = 5.0
        scrollImageView.setImageInputs([AFURLSource(urlString: "http://pic2.ooopic.com/01/03/51/25b1OOOPIC19.jpg")!, AFURLSource(urlString: "http://ppt360.com/background/UploadFiles_6733/201012/2010122016291897.jpg")!, AFURLSource(urlString: "http://img.taopic.com/uploads/allimg/130501/240451-13050106450911.jpg")!])
        
        DropDownUpdate()
        UpPullAdd()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func DropDownUpdate(){
        self.tableView.headerView = XWRefreshNormalHeader(target: self, action: "GetDate")
        self.tableView.headerView?.beginRefreshing()
        
    }
    
    func UpPullAdd(){
        self.tableView.footerView = XWRefreshAutoNormalFooter(target: self, action: "downPlullLoadData")
    }
    
    func GetDate(){
        let url = apiUrl+"GetMicroblog"
        
        let schoolid = NSUserDefaults.standardUserDefaults()
        let scid = schoolid.stringForKey("schoolid")
        
        let classid = NSUserDefaults.standardUserDefaults()
        let clid = classid.stringForKey("classid")
        
        let param = [
            "schoolid":scid!,
            "classid":clid!
        ]
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
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
                    hud.mode = MBProgressHUDMode.Text;
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                
                if(status.status == "success"){
                    self.blogSource = BlogList(status.data!)
                    print(self.blogSource.count)
                    self.sourceList.reloadData()
                }
            }
            
        }
        self.tableView.headerView?.endRefreshing()
    }
    
    func downPlullLoadData(){
        self.tableView.footerView?.endRefreshing()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        if (blogSource.count > 0 ){
            return blogSource.count
        }
        else{
            return 0
        }
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var Indetifiername = "blogHeader"
        let bloginfo = self.blogSource.objectlist[indexPath.section]

        self.pciSource = PictureList(bloginfo.piclist!)

        if(indexPath.row == 0){
            Indetifiername = "blogHeader"
            let cell1 = tableView.dequeueReusableCellWithIdentifier(Indetifiername, forIndexPath: indexPath) as! BlogCellTableViewCell
//            let dateformate = NSDateFormatter()
//            dateformate.dateFormat = "yyy-MM-dd"
//            cell1.blogTime.text = dateformate.stringFromDate(bloginfo.write_time!)
            cell1.blogName.text = bloginfo.name!
            return cell1
            
        }else if(indexPath.row == 1){
            Indetifiername = "blogCell"
            let cell2 = tableView.dequeueReusableCellWithIdentifier(Indetifiername, forIndexPath: indexPath) as! BlogCellTableViewCell
            var blogimage:UIImageView?

            
            
            cell2.blogDicText.text = bloginfo.content!
            
            //计算文本高度
            let options : NSStringDrawingOptions = NSStringDrawingOptions.UsesLineFragmentOrigin
            cell2.blogDicText.font = UIFont.systemFontOfSize(17)
            let string:NSString = cell2.blogDicText.text!
            let screenBounds:CGRect = UIScreen.mainScreen().bounds
            let boundingRect = string.boundingRectWithSize(CGSizeMake(screenBounds.width, 0), options: options, attributes: [NSFontAttributeName:cell2.blogDicText.font], context: nil)
            
            //如果高度大于140就显示7行
            if(boundingRect.size.height>140){
               cell2.blogDicText.numberOfLines = 7
                
                if(pciSource.count>0&&pciSource.count<=3){
                for i in 1...pciSource.count{
                    var x = 8
                    let pciInfo = pciSource.picturelist[i-1]
                    let imgUrl = microblogImageUrl+(pciInfo.pictureurl)!
                    
                    let image = self.imageCache[imgUrl] as UIImage?
                    let avatarUrl = NSURL(string: imgUrl)
                    let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                    
                    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                        if(data != nil){
                            
                            x = x+((i-1)*85)
                           blogimage = UIImageView(frame: CGRectMake(CGFloat(x), 20*7+20, 80, 80))
                            let imgTmp = UIImage(data: data!)
                            //self.imageCache[imgUrl] = imgTmp
                            blogimage!.image = imgTmp
                            
                            cell2.addSubview(blogimage!)
                        }
                    })
                    
                    }
                }
                if(pciSource.count>3&&pciSource.count<=6){
                    for i in 1...3{
                        var x = 8
                        let pciInfo = pciSource.picturelist[i-1]
                        let imgUrl = microblogImageUrl+(pciInfo.pictureurl)!
                        
                        let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-1)*85)
                                blogimage = UIImageView(frame: CGRectMake(CGFloat(x), 20*7+20, 80, 80))
                                let imgTmp = UIImage(data: data!)
                                //self.imageCache[imgUrl] = imgTmp
                                blogimage!.image = imgTmp
                                
                                cell2.addSubview(blogimage!)
                            }
                        })
                        //x = x+85
                    }
                    for i in 4...pciSource.count{
                        var x = 8
                        let pciInfo = pciSource.picturelist[i-1]
                        let imgUrl = microblogImageUrl+(pciInfo.pictureurl)!
                        
                        let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-4)*85)
                                blogimage = UIImageView(frame: CGRectMake(CGFloat(x), 20*7+20+85, 80, 80))
                                let imgTmp = UIImage(data: data!)
                                //self.imageCache[imgUrl] = imgTmp
                                blogimage!.image = imgTmp
                                
                                cell2.addSubview(blogimage!)
                            }
                        })
                       
                    }
                }
                if(pciSource.count>6&&pciSource.count<=9){
                    for i in 1...3{
                        var x = 8
                        let pciInfo = pciSource.picturelist[i-1]
                        let imgUrl = microblogImageUrl+(pciInfo.pictureurl)!
                        
                        let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-1)*85)
                                blogimage = UIImageView(frame: CGRectMake(CGFloat(x), 20*7+20, 80, 80))
                                let imgTmp = UIImage(data: data!)
                                //self.imageCache[imgUrl] = imgTmp
                                blogimage!.image = imgTmp
                                cell2.addSubview(blogimage!)
                            }
                        })
                        
                    }
                    for i in 4...6{
                        var x = 8
                        let pciInfo = pciSource.picturelist[i-1]
                        let imgUrl = microblogImageUrl+(pciInfo.pictureurl)!
                        
                        let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-4)*85)
                                blogimage = UIImageView(frame: CGRectMake(CGFloat(x), 20*7+20+85, 80, 80))
                                let imgTmp = UIImage(data: data!)
                                //self.imageCache[imgUrl] = imgTmp
                                blogimage!.image = imgTmp
                                
                                cell2.addSubview(blogimage!)
                            }
                        })

                    }
                    for i in 7...pciSource.count{
                        var x = 8
                        let pciInfo = pciSource.picturelist[i-1]
                        let imgUrl = microblogImageUrl+(pciInfo.pictureurl)!
                        
                        let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-6)*85)
                                blogimage = UIImageView(frame: CGRectMake(CGFloat(x), 20*7+20+85+85, 80, 80))
                                let imgTmp = UIImage(data: data!)
                                //self.imageCache[imgUrl] = imgTmp
                                blogimage!.image = imgTmp
                                
                                cell2.addSubview(blogimage!)
                            }
                        })

                    }

                }
            }
            //如果高度小于140全部显示
            else {
                cell2.blogDicText.numberOfLines = 0
                cell2.removeFromSuperview()
                print("====")
                print(pciSource.count)
                if(pciSource.count>0&&pciSource.count<=3){
                    for i in 1...pciSource.count{
                        var x = 8
                        let pciInfo = pciSource.picturelist[i-1]
                        let imgUrl = microblogImageUrl+(pciInfo.pictureurl)!
                        
                        let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-1)*85)
                                blogimage = UIImageView(frame: CGRectMake(CGFloat(x), boundingRect.size.height+20, 80, 80))
                                let imgTmp = UIImage(data: data!)
                                //self.imageCache[imgUrl] = imgTmp
                                blogimage!.image = imgTmp
                                cell2.addSubview(blogimage!)
                            }
                        })
                       
                    }
                }
                if(pciSource.count>3&&pciSource.count<=6){
                    for i in 1...3{
                        var x = 8
                        let pciInfo = pciSource.picturelist[i-1]
                        let imgUrl = microblogImageUrl+(pciInfo.pictureurl)!
                        
                        let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-1)*85)
                                blogimage = UIImageView(frame: CGRectMake(CGFloat(x), boundingRect.size.height+20, 80, 80))
                                let imgTmp = UIImage(data: data!)
                                //self.imageCache[imgUrl] = imgTmp
                                blogimage!.image = imgTmp
                                
                                cell2.addSubview(blogimage!)
                            }
                        })
                        
                    }
                    for i in 4...pciSource.count{
                        var x = 8
                        let pciInfo = pciSource.picturelist[i-1]
                        let imgUrl = microblogImageUrl+(pciInfo.pictureurl)!
                        
                        let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-4)*85)
                                blogimage = UIImageView(frame: CGRectMake(CGFloat(x), boundingRect.size.height+20+85, 80, 80))
                                let imgTmp = UIImage(data: data!)
                                //self.imageCache[imgUrl] = imgTmp
                                blogimage!.image = imgTmp
                                
                                cell2.addSubview(blogimage!)
                            }
                        })
                    }
                }
                if(pciSource.count>6&&pciSource.count<=9){
                for i in 1...3{
                        var x = 8
                        let pciInfo = pciSource.picturelist[i-1]
                        let imgUrl = microblogImageUrl+(pciInfo.pictureurl)!
                        
                        let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-1)*85)
                                blogimage = UIImageView(frame: CGRectMake(CGFloat(x), boundingRect.size.height+20, 80, 80))
                                let imgTmp = UIImage(data: data!)
                                //self.imageCache[imgUrl] = imgTmp
                                blogimage!.image = imgTmp
                                
                                cell2.addSubview(blogimage!)
                            }
                        })
                    
                    }
                    for i in 4...6{
                        var x = 8
                        let pciInfo = pciSource.picturelist[i-1]
                        let imgUrl = microblogImageUrl+(pciInfo.pictureurl)!
                        
                        let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-1)*85)
                                blogimage = UIImageView(frame: CGRectMake(CGFloat(x), boundingRect.size.height+20+85, 80, 80))
                                let imgTmp = UIImage(data: data!)
                                //self.imageCache[imgUrl] = imgTmp
                                blogimage!.image = imgTmp
                                
                                cell2.addSubview(blogimage!)
                            }
                        })
                        
                    }
                    for i in 7...pciSource.count{
                        var x = 8
                        let pciInfo = pciSource.picturelist[i-1]
                        let imgUrl = microblogImageUrl+(pciInfo.pictureurl)!
                        
                        let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-1)*85)
                                blogimage = UIImageView(frame: CGRectMake(CGFloat(x), boundingRect.size.height+20+85+85, 80, 80))
                                let imgTmp = UIImage(data: data!)
                                //self.imageCache[imgUrl] = imgTmp
                                blogimage!.image = imgTmp
                                
                                cell2.addSubview(blogimage!)
                            }
                        })
                        
                    }
                    
                }

                
            }
        
            return cell2
 
        }else{
            Indetifiername = "blogFooter"
            let cell3 = tableView.dequeueReusableCellWithIdentifier(Indetifiername, forIndexPath: indexPath) as! BlogCellTableViewCell
            
            return cell3
        }
            
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        if(indexPath.row == 0){
            return 60
        }
        if(indexPath.row == 1){
            let options : NSStringDrawingOptions = NSStringDrawingOptions.UsesLineFragmentOrigin
            let bloginfo = self.blogSource.objectlist[indexPath.section]
            
            self.pciSource = PictureList(bloginfo.piclist!)
            if(pciSource.count == 0){
                let string:NSString = bloginfo.content!
                let screenBounds:CGRect = UIScreen.mainScreen().bounds
                let boundingRect = string.boundingRectWithSize(CGSizeMake(screenBounds.width, 0), options: options, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(17)], context: nil)
                return boundingRect.size.height
            }
            if(pciSource.count<=3&&pciSource.count>0){
                let string:NSString = bloginfo.content!
                let screenBounds:CGRect = UIScreen.mainScreen().bounds
                let boundingRect = string.boundingRectWithSize(CGSizeMake(screenBounds.width, 0), options: options, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(17)], context: nil)
                if(boundingRect.size.height>140){
                    return 20*7+110
                }else{
                    return boundingRect.size.height + 130
                }

            }
            else if(pciSource.count>3&&pciSource.count<=6){
                let string:NSString = bloginfo.content!
                let screenBounds:CGRect = UIScreen.mainScreen().bounds
                let boundingRect = string.boundingRectWithSize(CGSizeMake(screenBounds.width, 0), options: options, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(17)], context: nil)
                if(boundingRect.size.height>140){
                    return 20*7+200
                }else{
                    return boundingRect.size.height + 210
                }

            }else{
                let string:NSString = bloginfo.content!
                let screenBounds:CGRect = UIScreen.mainScreen().bounds
                let boundingRect = string.boundingRectWithSize(CGSizeMake(screenBounds.width, 0), options: options, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(17)], context: nil)
                if(boundingRect.size.height>140){
                    return 20*7+110
                }else{
                    return boundingRect.size.height + 300
                }

            }
            
        }
        if(indexPath.row == 3){
            return 100
        }
    return 100
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        return 0.01
        
    }


    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5.0
    }

}
