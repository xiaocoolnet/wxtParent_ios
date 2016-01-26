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
    var DianzanSource = DianZanList()
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
        //self.sourceList.reloadData()
        self.tableView.reloadData()
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
        self.DianzanSource = DianZanList(bloginfo.dianzanlist!)
        print("begin::")
        print(indexPath.section)
        if(indexPath.row == 0){
            Indetifiername = "blogHeader"
            let cell1 = tableView.dequeueReusableCellWithIdentifier(Indetifiername, forIndexPath: indexPath) as! BlogCellTableViewCell
//            let dateformate = NSDateFormatter()
//            dateformate.dateFormat = "yyy-MM-dd"
//            cell1.blogTime.text = dateformate.stringFromDate(bloginfo.write_time!)
            cell1.blogName.text = bloginfo.name!
            return cell1
            
        }else if(indexPath.row == 1){
            Indetifiername = "Imagecell"
            var cell2:BlogCellTableViewCell? = tableView.dequeueReusableCellWithIdentifier(Indetifiername) as? BlogCellTableViewCell
            //var cell2:BlogCellTableViewCell? = tableView.cellForRowAtIndexPath(indexPath) as?BlogCellTableViewCell
            var blogimage:UIImageView?

            
            if cell2 == nil{
                cell2 = BlogCellTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: Indetifiername)
            }
            else{
                while(cell2?.contentView.subviews.last != nil){
                    cell2?.contentView.subviews.last?.removeFromSuperview()
                    
                }
            }


            let blogDicText = UILabel()
            //计算文本高度
            let options : NSStringDrawingOptions = NSStringDrawingOptions.UsesLineFragmentOrigin
            blogDicText.font = UIFont.systemFontOfSize(17)
            let string:NSString = bloginfo.content!
            let screenBounds:CGRect = UIScreen.mainScreen().bounds
            let boundingRect = string.boundingRectWithSize(CGSizeMake(screenBounds.width-5, 0), options: options, attributes: [NSFontAttributeName:blogDicText.font], context: nil)
            
            blogDicText.text = bloginfo.content!
            
            print(boundingRect)
            blogDicText.frame = CGRectMake(5, 5, boundingRect.size.width, boundingRect.size.height)
            
            print(blogDicText.frame)
            cell2?.contentView.addSubview(blogDicText)
            //如果高度大于140就显示7行
            if(boundingRect.size.height>140){
               blogDicText.numberOfLines = 7
                
                if(pciSource.count>0&&pciSource.count<=3){
                for i in 1...pciSource.count{
                    var x = 8
                    let pciInfo = pciSource.picturelist[i-1]
                    let imgUrl = microblogImageUrl+(pciInfo.pictureurl)!
                    
                    //let image = self.imageCache[imgUrl] as UIImage?
                    let avatarUrl = NSURL(string: imgUrl)
                    let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                    
                    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                        if(data != nil){
                            
                            x = x+((i-1)*85)
                           blogimage = UIImageView(frame: CGRectMake(CGFloat(x), 20*7+20, 80, 80))
                            let imgTmp = UIImage(data: data!)
                            //self.imageCache[imgUrl] = imgTmp
                            blogimage!.image = imgTmp
                            
                            cell2!.contentView.addSubview(blogimage!)
                        }
                    })
                    
                    }
                }
                if(pciSource.count>3&&pciSource.count<=6){
                    for i in 1...3{
                        var x = 8
                        let pciInfo = pciSource.picturelist[i-1]
                        let imgUrl = microblogImageUrl+(pciInfo.pictureurl)!
                        
                        //let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-1)*85)
                                blogimage = UIImageView(frame: CGRectMake(CGFloat(x), 20*7+20, 80, 80))
                                let imgTmp = UIImage(data: data!)
                                //self.imageCache[imgUrl] = imgTmp
                                blogimage!.image = imgTmp
                                
                                cell2!.contentView.addSubview(blogimage!)
                            }
                        })
                        //x = x+85
                    }
                    for i in 4...pciSource.count{
                        var x = 8
                        let pciInfo = pciSource.picturelist[i-1]
                        let imgUrl = microblogImageUrl+(pciInfo.pictureurl)!
                        
                        //let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-4)*85)
                                blogimage = UIImageView(frame: CGRectMake(CGFloat(x), 20*7+20+85, 80, 80))
                                let imgTmp = UIImage(data: data!)
                                //self.imageCache[imgUrl] = imgTmp
                                blogimage!.image = imgTmp
                                
                                cell2!.contentView.addSubview(blogimage!)
                            }
                        })
                       
                    }
                }
                if(pciSource.count>6&&pciSource.count<=9){
                    for i in 1...3{
                        var x = 8
                        let pciInfo = pciSource.picturelist[i-1]
                        let imgUrl = microblogImageUrl+(pciInfo.pictureurl)!
                        
                        //let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-1)*85)
                                blogimage = UIImageView(frame: CGRectMake(CGFloat(x), 20*7+20, 80, 80))
                                let imgTmp = UIImage(data: data!)
                                //self.imageCache[imgUrl] = imgTmp
                                blogimage!.image = imgTmp
                                cell2!.contentView.addSubview(blogimage!)
                            }
                        })
                        
                    }
                    for i in 4...6{
                        var x = 8
                        let pciInfo = pciSource.picturelist[i-1]
                        let imgUrl = microblogImageUrl+(pciInfo.pictureurl)!
                        
                        //let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-4)*85)
                                blogimage = UIImageView(frame: CGRectMake(CGFloat(x), 20*7+20+85, 80, 80))
                                let imgTmp = UIImage(data: data!)
                                //self.imageCache[imgUrl] = imgTmp
                                blogimage!.image = imgTmp
                                
                                cell2!.contentView.addSubview(blogimage!)
                            }
                        })

                    }
                    for i in 7...pciSource.count{
                        var x = 8
                        let pciInfo = pciSource.picturelist[i-1]
                        let imgUrl = microblogImageUrl+(pciInfo.pictureurl)!
                        
                        //let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-6)*85)
                                blogimage = UIImageView(frame: CGRectMake(CGFloat(x), 20*7+20+85+85, 80, 80))
                                let imgTmp = UIImage(data: data!)
                                //self.imageCache[imgUrl] = imgTmp
                                blogimage!.image = imgTmp
                                
                                cell2!.contentView.addSubview(blogimage!)
                            }
                        })

                    }

                }
            }
            //如果高度小于140全部显示
            else {
                blogDicText.numberOfLines = 0
                if(pciSource.count>0&&pciSource.count<=3){
                    for i in 1...pciSource.count{
                        var x = 8
                        let pciInfo = pciSource.picturelist[i-1]
                        let imgUrl = microblogImageUrl+(pciInfo.pictureurl)!
                        
                        //let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-1)*85)
                                blogimage = UIImageView(frame: CGRectMake(CGFloat(x), boundingRect.size.height+20, 80, 80))
                                let imgTmp = UIImage(data: data!)
                                //self.imageCache[imgUrl] = imgTmp
                                blogimage!.image = imgTmp
                                cell2!.contentView.addSubview(blogimage!)
                            }
                        })
                       
                    }
                }
                if(pciSource.count>3&&pciSource.count<=6){
                    for i in 1...3{
                        var x = 8
                        let pciInfo = pciSource.picturelist[i-1]
                        let imgUrl = microblogImageUrl+(pciInfo.pictureurl)!
                        
                        //let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-1)*85)
                                blogimage = UIImageView(frame: CGRectMake(CGFloat(x), boundingRect.size.height+20, 80, 80))
                                let imgTmp = UIImage(data: data!)
                                //self.imageCache[imgUrl] = imgTmp
                                blogimage!.image = imgTmp
                                
                                cell2!.contentView.addSubview(blogimage!)
                            }
                        })
                        
                    }
                    for i in 4...pciSource.count{
                        var x = 8
                        let pciInfo = pciSource.picturelist[i-1]
                        let imgUrl = microblogImageUrl+(pciInfo.pictureurl)!
                        
                        //let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-4)*85)
                                blogimage = UIImageView(frame: CGRectMake(CGFloat(x), boundingRect.size.height+20+85, 80, 80))
                                let imgTmp = UIImage(data: data!)
                                //self.imageCache[imgUrl] = imgTmp
                                blogimage!.image = imgTmp
                                
                                cell2!.contentView.addSubview(blogimage!)
                            }
                        })
                    }
                }
                if(pciSource.count>6&&pciSource.count<=9){
                for i in 1...3{
                        var x = 8
                        let pciInfo = pciSource.picturelist[i-1]
                        let imgUrl = microblogImageUrl+(pciInfo.pictureurl)!
                        
                        //let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-1)*85)
                                blogimage = UIImageView(frame: CGRectMake(CGFloat(x), boundingRect.size.height+20, 80, 80))
                                let imgTmp = UIImage(data: data!)
                                //self.imageCache[imgUrl] = imgTmp
                                blogimage!.image = imgTmp
                                
                                cell2!.contentView.addSubview(blogimage!)
                            }
                        })
                    
                    }
                    for i in 4...6{
                        var x = 8
                        let pciInfo = pciSource.picturelist[i-1]
                        let imgUrl = microblogImageUrl+(pciInfo.pictureurl)!
                        
                        //let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-1)*85)
                                blogimage = UIImageView(frame: CGRectMake(CGFloat(x), boundingRect.size.height+20+85, 80, 80))
                                let imgTmp = UIImage(data: data!)
                                //self.imageCache[imgUrl] = imgTmp
                                blogimage!.image = imgTmp
                                
                                cell2!.contentView.addSubview(blogimage!)
                            }
                        })
                        
                    }
                    for i in 7...pciSource.count{
                        var x = 8
                        let pciInfo = pciSource.picturelist[i-1]
                        let imgUrl = microblogImageUrl+(pciInfo.pictureurl)!
                        
                        //let image = self.imageCache[imgUrl] as UIImage?
                        let avatarUrl = NSURL(string: imgUrl)
                        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                            if(data != nil){
                                x = x+((i-1)*85)
                                blogimage = UIImageView(frame: CGRectMake(CGFloat(x), boundingRect.size.height+20+85+85, 80, 80))
                                let imgTmp = UIImage(data: data!)
                                //self.imageCache[imgUrl] = imgTmp
                                blogimage!.image = imgTmp
                                
                                cell2!.contentView.addSubview(blogimage!)
                            }
                        })
                        
                    }
                    
                }
                
            }
        
            return cell2!
 
        }else{
            Indetifiername = "blogFooter"
            
            let cell3 = tableView.dequeueReusableCellWithIdentifier(Indetifiername, forIndexPath: indexPath) as! BlogCellTableViewCell
            cell3.dianZanBtn.selected = false
            if(self.DianzanSource.count>3){
                let array3 = NSMutableArray()
                for i in 1...3{
                    let dianzanInfo = DianzanSource.dianzanlist[i-1]
                    array3.addObject(dianzanInfo.dianZanName!)
                    
                }
                let peopleArray = array3.componentsJoinedByString(",")
            cell3.dianZanPeople.text = "\(peopleArray)等\(self.DianzanSource.count)人觉得很赞"
            }
            if(self.DianzanSource.count == 0 ){
                cell3.dianZanPeople.text = ""
            }
            if(self.DianzanSource.count<3&&self.DianzanSource.count>0){
                let array3 = NSMutableArray()
                for i in 1...DianzanSource.count{
                    let dianzanInfo = DianzanSource.dianzanlist[i-1]
                    array3.addObject(dianzanInfo.dianZanName!)
                    
                }
                let peopleArray = array3.componentsJoinedByString(",")
                cell3.dianZanPeople.text = "\(peopleArray)觉得很赞"
            }
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
            return 60
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
