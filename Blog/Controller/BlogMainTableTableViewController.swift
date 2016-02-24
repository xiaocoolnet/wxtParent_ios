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
    var selectImgUrl:String?
    var imageCache = Dictionary<String,UIImage>()
    var mid:String?
    var pictureFangda:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.tabBarItem.badgeValue = nil
        ScrollViewImage()
        DropDownUpdate()
        UpPullAdd()
        
    }
    
    func ScrollViewImage(){
        scrollImageView.slideshowInterval = 5.0
        scrollImageView.setImageInputs([AFURLSource(urlString: "http://pic2.ooopic.com/01/03/51/25b1OOOPIC19.jpg")!, AFURLSource(urlString: "http://ppt360.com/background/UploadFiles_6733/201012/2010122016291897.jpg")!, AFURLSource(urlString: "http://img.taopic.com/uploads/allimg/130501/240451-13050106450911.jpg")!])
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
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
        if(indexPath.row == 0){
            Indetifiername = "blogHeader"
            let cell1 = tableView.dequeueReusableCellWithIdentifier(Indetifiername, forIndexPath: indexPath) as! BlogCellTableViewCell
            if(bloginfo.photo != nil){
                let imgUrl = imageUrl+(bloginfo.photo!)
                
                //let image = self.imageCache[imgUrl] as UIImage?
                let avatarUrl = NSURL(string: imgUrl)
                let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
                //异步获取
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
                    if(data != nil){
                        let imgTmp = UIImage(data: data!)
                        self.imageCache[imgUrl] = imgTmp
                        cell1.blogAvator.image = imgTmp
                        cell1.blogAvator.alpha = 1.0
                        
                    }
                })
                
            }
            cell1.blogName.text = bloginfo.name!
            return cell1
            
        }
        else if(indexPath.row == 1){
            Indetifiername = "blogCell"
            var cell2:BlogCellTableViewCell? = tableView.dequeueReusableCellWithIdentifier(Indetifiername) as? BlogCellTableViewCell
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
            blogDicText.frame = CGRectMake(5, 5, boundingRect.size.width, boundingRect.size.height)
            
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
                                self.pictureFangda = blogimage!.image
                                blogimage!.userInteractionEnabled = true
                                let singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "imageViewTouch")
                                blogimage!.addGestureRecognizer(singleTap)
                                let pciInfo = self.pciSource.picturelist[i-1]
                                let imgUrl = microblogImageUrl+(pciInfo.pictureurl)!
                                self.selectImgUrl = imgUrl
                                print("被选中的图片\(i)")
                                print(self.selectImgUrl)
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
 
        }
        else{
            
            Indetifiername = "blogFooter"
            let arrayPeople = NSMutableArray()
            var cell3:BlogCellTableViewCell? = tableView.dequeueReusableCellWithIdentifier(Indetifiername) as? BlogCellTableViewCell
            if cell3 == nil{
                cell3 = BlogCellTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: Indetifiername)
            }
            else{
                while(cell3?.contentView.subviews.last != nil){
                    cell3?.contentView.subviews.last?.removeFromSuperview()
                }
            }
            
            cell3!.dianZanBtn.frame = CGRectMake(10,10,30,30)
            cell3!.pingLunBtn.frame = CGRectMake(10,45,30,30)
            cell3!.pingLunBtn.setImage(UIImage(named: "评论"), forState: UIControlState.Normal)
            cell3!.pingLunBtn.addTarget(self, action: Selector("ToPingLun"), forControlEvents: UIControlEvents.TouchUpInside)
            cell3!.dianZanPeople.frame = CGRectMake(45,10,UIScreen.mainScreen().bounds.width-45,30)
            cell3!.dianZanPeople.font = UIFont.systemFontOfSize(15)
            cell3!.dianZanPeople.textColor = UIColor.grayColor()
            cell3?.contentView.addSubview(cell3!.pingLunBtn)
            cell3?.contentView.addSubview(cell3!.dianZanBtn)
            cell3?.contentView.addSubview(cell3!.dianZanPeople)
            
            //
            
            //获取缓存
            let userid = NSUserDefaults.standardUserDefaults()
            let uid = userid.stringForKey("userid")
            /**
            *  
            如果点赞数量等于0，不现实
            如果在1-5跟之间点赞，显示全部
            如果大于5个人点赞，显示5个人等X个人点赞
            */
            
            if(DianzanSource.count == 0){
                    cell3!.dianZanPeople.text = ""
                    cell3!.dianZanBtn.selected = false
                    cell3!.dianZanBtn.setImage(UIImage(named: "点赞"), forState: .Normal)
            }
            
            if(DianzanSource.count > 0 && DianzanSource.count <= 5){
                //循环遍历点赞数量，对比是否自己点过赞
                for i in 1...DianzanSource.count{
                    let dianzanInfo = DianzanSource.dianzanlist[i-1]
                    //如果点过赞，则显示点赞图标
                    if(dianzanInfo.dianZanId == uid){
                        cell3!.dianZanBtn.selected = true
                        cell3!.dianZanBtn.setImage(UIImage(named: "已点赞"), forState:.Normal)
                        arrayPeople.addObject(dianzanInfo.dianZanName!)
                        let peopleArray = arrayPeople.componentsJoinedByString(",")
                        cell3!.dianZanPeople.text = "\(peopleArray)觉得很赞"

                    }
                    //如果没点过赞，显示灰色图标
                    else{
                        cell3!.dianZanBtn.selected = false
                        cell3!.dianZanBtn.setImage(UIImage(named: "点赞"), forState: .Normal)
                        arrayPeople.addObject(dianzanInfo.dianZanName!)
                        let peopleArray = arrayPeople.componentsJoinedByString(",")
                        cell3!.dianZanPeople.text = "\(peopleArray)觉得很赞"
                    }
                }
            }
            if(DianzanSource.count > 5){
                for i in 1...DianzanSource.count{
                    let dianzanInfo = DianzanSource.dianzanlist[i-1]
                    //如果点过赞，则显示点赞图标
                    if(dianzanInfo.dianZanId == uid){
                        cell3!.dianZanBtn.selected = true
                        cell3!.dianZanBtn.setImage(UIImage(named: "已点赞"), forState: .Normal)
                        for i in 1...5{
                            let dianzanInfo = DianzanSource.dianzanlist[i-1]
                            arrayPeople.addObject(dianzanInfo.dianZanName!)
                            let peopleArray = arrayPeople.componentsJoinedByString(",")
                            cell3!.dianZanPeople.text = "\(peopleArray)等\(DianzanSource.count)人觉得很赞"
                        }
                    }
                        //如果没点过赞，显示灰色图标
                    else{
                        cell3!.dianZanBtn.selected = false
                        cell3!.dianZanBtn.setImage(UIImage(named: "点赞"), forState: .Normal)
                        for i in 1...5{
                            let dianzanInfo = DianzanSource.dianzanlist[i-1]
                            arrayPeople.addObject(dianzanInfo.dianZanName!)
                            let peopleArray = arrayPeople.componentsJoinedByString(",")
                            cell3!.dianZanPeople.text = "\(peopleArray)等\(DianzanSource.count)人觉得很赞"
                        }

                    }
                }

            }
            
            cell3!.mid = bloginfo.mid!
            if cell3!.myDianZan.containsObject(bloginfo.mid!){
                cell3!.dianZanBtn.setImage(UIImage(named: "已点赞"), forState: .Normal)
            }
            
            
            return cell3!
        }
            
        
    }
    
    func imageViewTouch(){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        //let imgvc = ImageViewController()
        //var imgvc:ImageViewController = ImageViewController()
        let vcI : ImageViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ImageView") as! ImageViewController
        vcI.imUrl = selectImgUrl!
        vcI.tupian = pictureFangda!
        print("图片地址是")
        //print(imgvc.imUrl)
        self.navigationController?.pushViewController(vcI, animated: true)
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
                return boundingRect.size.height+20
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
    return 80
    }
    
    func ToPingLun(){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("PingLunView") 
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        return 0.01
        
    }


    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5.0
    }

}
