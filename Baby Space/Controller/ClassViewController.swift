//
//  ClassViewController.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/2/18.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import YYWebImage
import XWSwiftRefresh
import MBProgressHUD

class ClassViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    let table = UITableView()
    var blogSource = BlogList()
    var pciSource = PictureList()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createTable()
        self.loadData()
    }
    //    创建表
    func createTable(){
        table.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-40)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .None
        self.view.addSubview(table)
        
        table.registerNib(UINib.init(nibName: "PhotoTableViewCell", bundle: nil), forCellReuseIdentifier: "PhotoCellID")
    }
    func loadData(){
        //        http://wxt.xiaocool.net/index.php?g=apps&m=index&a=GetMicroblog&schoolid=1&classid=1&type=2
        let url = apiUrl+"GetMicroblog"
        
        let schoolid = NSUserDefaults.standardUserDefaults()
        let scid = schoolid.stringForKey("schoolid")
        
        let classid = NSUserDefaults.standardUserDefaults()
        let clid = classid.stringForKey("classid")
        
        let param = [
            "schoolid":scid!,
            "classid":clid!,
            "type":2
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
                    hud.mode = MBProgressHUDMode.Text;
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                
                if(status.status == "success"){
                    self.blogSource = BlogList(status.data!)
                    self.table.reloadData()
                }
            }
            
        }
        self.table.headerView?.endRefreshing()
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.blogSource.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCellID", forIndexPath: indexPath)
            as! PhotoTableViewCell
        cell.selectionStyle = .None
        let blogInfo = self.blogSource.objectlist[indexPath.row]
        cell.contentlbl.text = blogInfo.content
        cell.senderLbl.text = "发自 \(blogInfo.name!)"
        let dateformate = NSDateFormatter()
        dateformate.dateFormat = "yyyy-MM-dd HH:mm"
        let date = NSDate(timeIntervalSince1970: NSTimeInterval(blogInfo.write_time!)!)
        let str:String = dateformate.stringFromDate(date)
        cell.timeLbl.text = str
        let picList:PictureList = PictureList(blogInfo.piclist!)
        cell.moreBtn.setTitle("共\(picList.count)张", forState: .Normal)
        if picList.count != 0 {
            let picInfo = picList.picturelist[0]
            let imgUrl = imageUrl + picInfo.pictureurl!
            let photourl = NSURL(string: imgUrl)
            cell.bigImageIVew.yy_setImageWithURL(photourl, placeholder: UIImage(named: "无网络的背景.png"))
            //为图片视图添加点击事件
            cell.bigImageIVew.userInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(ClassViewController.tapAction(_:)))
            //            手指头
            tap.numberOfTapsRequired = 1
            //            单击
            tap.numberOfTouchesRequired = 1
            cell.bigImageIVew.addGestureRecognizer(tap)
            cell.bigImageIVew.tag = indexPath.row
        }
        //        自适应行高
        let options : NSStringDrawingOptions = NSStringDrawingOptions.UsesLineFragmentOrigin
        let screenBounds:CGRect = UIScreen.mainScreen().bounds
        let boundingRect = String(cell.contentlbl.text).boundingRectWithSize(CGSizeMake(screenBounds.width, 0), options: options, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(17)], context: nil)
        table.rowHeight = boundingRect.size.height + 311
        return cell
    }
    //    图片点击事件
    func tapAction(tap:UIGestureRecognizer) {
        var imageView = UIImageView()
        imageView = tap.view as! UIImageView
        let vc = ImagesViewController()
        vc.id = imageView.tag
        vc.type = 2
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
