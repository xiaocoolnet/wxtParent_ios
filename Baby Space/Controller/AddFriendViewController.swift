//
//  AddFriendViewController.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/8/8.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import XWSwiftRefresh

class AddFriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let myTableView = UITableView()
    var teacherSource = BabyFirendList()
    var dataSource = BabyFirendList()
    
    let arr  = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        myTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT - 64)
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.separatorStyle = .None
        myTableView.backgroundColor = RGBA(242.0, g: 242.0, b: 242.0, a: 1)
        self.view.addSubview(myTableView)
        
        self.GETDate()
        self.getDate()
        
    }
    
    func getDate(){
        //  http://wxt.xiaocool.net/index.php?g=apps&m=school&a=getStudentlistByClassid&classid=1
        //下面两句代码是从缓存中取出userid（入参）值
        let classid = NSUserDefaults.standardUserDefaults()
        let clid = classid.stringForKey("classid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=school&a=getStudentlistByClassid"
        let param = [
            "classid":clid!,
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
                    messageHUD(self.view, messageData: status.errorData!)
                }
                if(status.status == "success"){
                    self.dataSource = BabyFirendList(status.data!)
                
                    self.arr.removeAllObjects()
                    for i in 0...self.dataSource.objectlist.count - 1{
                        let info = self.dataSource.objectlist[i]
                        let str = self.dataSource.objectlist[i].id
                        let userid = classid.stringForKey("userid")
                        if str != userid{
                            self.arr.addObject(info)
                        }
                    }
                    
                    self.myTableView.reloadData()
                }
            }
        }
    }
    
    func GETDate(){
        //  http://wxt.xiaocool.net/index.php?g=apps&m=student&a=getfriendlist&studentid=597
        //下面两句代码是从缓存中取出userid（入参）值
        let defalutid = NSUserDefaults.standardUserDefaults()
        let sid = defalutid.stringForKey("chid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=getfriendlist"
        let param = [
            "studentid":sid!,
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
                    messageHUD(self.view, messageData: status.errorData!)
                }
                if(status.status == "success"){
                    self.teacherSource = BabyFirendList(status.data!)
                    
//                   self.myTableView.reloadData()
                }
            }
        }

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.objectlist.count - 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier:String(indexPath.row))
        cell.selectionStyle = .None
        
//        let model = self.dataSource.objectlist[indexPath.row]
        let model = (self.arr.objectAtIndex(indexPath.row) as? BabyFirendInfo)!
        
        
        let img = UIImageView()
        img.frame = CGRectMake(10, 15, 40, 40)
        let pic = model.photo
        let imgUrl = microblogImageUrl + pic!
        let photourl = NSURL(string: imgUrl)
        img.layer.cornerRadius = 20
        img.clipsToBounds = true
        img.sd_setImageWithURL(photourl, placeholderImage: UIImage(named: "Logo"))
        cell.contentView.addSubview(img)

        let name = UILabel()
        name.frame = CGRectMake(70, 15, 120, 40)
        name.text = model.name
        cell.contentView.addSubview(name)
        
        
        let baby = self.teacherSource.objectlist
        print(baby.count)
        let btn = UIButton()
        btn.frame = CGRectMake(WIDTH - 120, 15, 100, 40)
        btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        btn.tag = indexPath.row
        cell.contentView.addSubview(btn)

        
        for obj in baby {
            let str = obj.id
            print(str)
            print(model.id)
            if str == model.id {
                print("已添加")
                btn.setTitle("已添加", forState: .Normal)
                break
            }else{
                btn.setTitle("添加", forState: .Normal)
                btn.addTarget(self, action: #selector(self.clickBtn), forControlEvents: .TouchUpInside)
            }
        }
        
        return cell
    }
    
    func clickBtn(sender:UIButton){
//        http://wxt.xiaocool.net/index.php?g=apps&m=student&a=addfriend&studentid=597&friendid=605
        //下面两句代码是从缓存中取出userid（入参）值
        let defalutid = NSUserDefaults.standardUserDefaults()
        let sid = defalutid.stringForKey("chid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=addfriend&studentid=597&friendid=605"
        let param = [
            "studentid":sid!,
            "friendid":self.dataSource.objectlist[sender.tag].id
            ]
        Alamofire.request(.GET, url, parameters: param as? [String:String]).response { request, response, json, error in
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
                    messageHUD(self.view, messageData: status.errorData!)
                }
                if(status.status == "success"){
                    self.myTableView.reloadData()
                    self.GETDate()
                    self.getDate()
                }
            }
        }

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
