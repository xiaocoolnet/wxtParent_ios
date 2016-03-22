//
//  BlogCellTableViewCell.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/1/22.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire

class BlogCellTableViewCell: UITableViewCell {

    

    
    @IBOutlet weak var blogAvator: UIImageView!
    
    @IBOutlet weak var blogName: UILabel!
    
    @IBOutlet weak var blogTime: UILabel!
    
    let dianZanBtn = UIButton()
    let dianZanPeople = UILabel()
    let pingLunBtn = UIButton()
    var myDianZan = NSMutableSet()
    var indexPath:NSIndexPath?
    var mid:String?
    var flag:Int = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        dianZanBtn.addTarget(self, action: #selector(BlogCellTableViewCell.ChangeDianZan), forControlEvents: UIControlEvents.TouchUpInside)
        

        // Initialization code
    }

    func ChangeDianZan(){
        dianZanBtn.selected = !dianZanBtn.selected
        if(!dianZanBtn.selected){
            myDianZan.removeObject(mid!)
            QuXiaoDianZan()
            dianZanBtn.setImage(UIImage(named: "点赞"), forState: .Normal)
        }
        else{
            myDianZan.addObject(mid!)
            GetDianZanDate()
            dianZanBtn.setImage(UIImage(named: "已点赞"), forState: .Normal)
        }

    }
    
    func QuXiaoDianZan(){
        let url = apiUrl+"ResetLike"
        let userid = NSUserDefaults.standardUserDefaults()
        let uid = userid.stringForKey("userid")
        let param = [
            "mid":mid!,
            "userid":uid!
        ]
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            if(error != nil){
            }
            else{
                print("request是")
                print(request!)
                print("====================")
                let status = MineModel(JSONDecoder(json!))
                print("状态是")
                print(status.status)
                if(status.status == "error"){
                    
                    let hud = MBProgressHUD.showHUDAddedTo(self.contentView, animated: true)
                    hud.mode = MBProgressHUDMode.Text;
                    hud.labelText = status.errorData
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                
                if(status.status == "success"){
                    //self.dianZanBtn.selected == true
                    self.dianZanBtn.frame = CGRectMake(10,10,30,30)
                    self.flag = 1
                    let hud = MBProgressHUD.showHUDAddedTo(self.contentView, animated: true)
                    hud.mode = MBProgressHUDMode.Text;
                    hud.labelText = "取消点赞"
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                
            }
            
        }

    }
    
    func GetDianZanDate(){
        
        let url = apiUrl+"SetLike"
        let userid = NSUserDefaults.standardUserDefaults()
        let uid = userid.stringForKey("userid")
        let time = String(NSDate().timeIntervalSince1970)
        let param = [
            "mid":mid!,
            "userid":uid!,
            "time":time
        ]
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            if(error != nil){
            }
            else{
                print("request是")
                print(request!)
                print("====================")
                let status = MineModel(JSONDecoder(json!))
                print("状态是")
                print(status.status)
                if(status.status == "error"){
                    
                    let hud = MBProgressHUD.showHUDAddedTo(self.contentView, animated: true)
                    hud.mode = MBProgressHUDMode.Text;
                    hud.labelText = status.errorData
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                
                if(status.status == "success"){
                    //self.dianZanBtn.selected == true
                    self.dianZanBtn.frame = CGRectMake(10,10,30,30)
                    self.flag = 1
                    let hud = MBProgressHUD.showHUDAddedTo(self.contentView, animated: true)
                    hud.mode = MBProgressHUDMode.Text;
                    hud.labelText = "点赞成功"
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                
            }
            
        }
    }
    
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
