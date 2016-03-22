//
//  FoodMenuTableViewController.swift
//  WXT_Parents
//
//  Created by 牛尧 on 16/2/23.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import XWSwiftRefresh
class FoodMenuTableViewController: UITableViewController {
    
    @IBOutlet var tableSource: UITableView!
    var FoodsSource = FoodList()
    var imageCache = Dictionary<String,UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DropDownUpdate()
    }
    
    func DropDownUpdate(){
        self.tableView.headerView = XWRefreshNormalHeader(target: self, action: #selector(FoodMenuTableViewController.GetDate))
        self.tableView.headerView?.beginRefreshing()
        
    }
    
    func GetDate(){
        //下面两句代码是从缓存中取出userid（入参）值
        let defalutid = NSUserDefaults.standardUserDefaults()
        let shid = defalutid.stringForKey("schoolid")
        let url = apiUrl + "WeekRecipe"
        let param = [
            "schoolid":shid!
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
                    hud.mode = MBProgressHUDMode.Text
                    hud.labelText = status.errorData
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                if(status.status == "success"){
                    self.tableView.headerView?.endRefreshing()
                    self.FoodsSource = FoodList(status.data!)
                    self.tableSource.reloadData()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
/*
        if(section == 0){
            return 3
        }
        if(section == 1){
            return 4
        }
*/
        return FoodsSource.count
    }
    /*
   override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String{
    
           if (section == 0)
          {
              return "周一"
           }
          else if (section == 1)
          {
                return  "评论区"
       }
        return "WQE"
    }
*/
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FoodMenu", forIndexPath: indexPath) as!FoodMenuTableViewCell
       /*
        cell.images.image = UIImage(named: "奥数")
       cell.lab.text = "标题"
        cell.Introduce.text = "如果你无法简介的表达你的想法，只能说明你还不够了解它！"
       */
        let foodInfo = self.FoodsSource.objectlist[indexPath.row]
        let dateformate = NSDateFormatter()
        dateformate.dateFormat = "MM-dd"
        cell.Introduce.text = foodInfo.recipe_info!
        cell.lab.text = foodInfo.recipe_title!
        let imgUrl = foodMenuImageUrl+(foodInfo.recipe_pic!)
        
        let image = self.imageCache[imgUrl] as UIImage?
        let avatarUrl = NSURL(string: imgUrl)
        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
        //异步获取
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
            if(data != nil){
                let imgTmp = UIImage(data: data!)
                self.imageCache[imgUrl] = imgTmp
                cell.images.image = imgTmp
                cell.images.alpha = 1.0
                
            }
        })
        return cell
    }
   
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        return 30.0
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5.0
    }

}
