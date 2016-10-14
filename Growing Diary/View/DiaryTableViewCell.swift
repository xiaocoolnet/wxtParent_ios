//
//  DiaryTableViewCell.swift
//  WXT_Parents
//
//  Created by zhang on 16/6/6.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

typealias callBack = (CGFloat) ->Void

class DiaryTableViewCell: UITableViewCell,UITableViewDataSource,UITableViewDelegate {
    
    var block : callBack!

    @IBOutlet weak var weekLbl: UILabel!
    @IBOutlet weak var datelbl: UILabel!
    @IBOutlet weak var bigImageView: UIImageView!
    
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var senderLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var pinglunBtn: UIButton!
    @IBOutlet weak var dianzanBtn: UIButton!
    
    @IBOutlet weak var zanListLbl: UILabel!
    
    

    var dataSource = QCCommentInfo()

    @IBOutlet weak var tableView: QCCommentView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.dianzanBtn.setBackgroundImage(UIImage(named: "点赞"), forState: .Normal)
        self.pinglunBtn.setBackgroundImage(UIImage(named: "评论"), forState: .Normal)
        
        createUI()
        GETComment()
        
    }
    // MARK: - 初始化UI列表
    func createUI(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.scrollEnabled = false
        self.tableView.backgroundColor = UIColor.lightGrayColor()
                //   注册cell
        self.tableView.registerClass(QCCommentCell.self, forCellReuseIdentifier: QCCommentCell.QCCommentCell())
            }
//             MARK: - 得到评论的数据请求
    func GETComment(){
        //  http://wxt.xiaocool.net/index.php?g=apps&m=school&a=GetCommentlist&userid=597&refid=21&type=3
        //  需要通过沙盒进行取值
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let userid = userDefaults.stringForKey("userid")
        let refid = userDefaults.stringForKey("grow_id")
        print("refid")
        print(refid)
        let param = ["a":"GetCommentlist",
                             "userid":userid,
                             "refid":refid,
                             "type":"3"]
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=school"

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
                            let hud = MBProgressHUD.showHUDAddedTo(self.tableView, animated: true)
                            hud.mode = MBProgressHUDMode.Text
                            hud.labelText = status.errorData
                            hud.margin = 10.0
                            hud.removeFromSuperViewOnHide = true
                            hud.hide(true, afterDelay: 1)
                        }
                        if(status.status == "success"){
                            self.dataSource = QCCommentInfo(status.data!)
                            self.tableView.reloadData()
                        }
                    }
                }
        
            }
            // MARK: - 删除评论的列表
    func deleteComment(){

            }
            // MARK: - tableView 的三个代理方法
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
                //  自定义 (需要进行计算(主要是内容的高度))
        let model = self.dataSource.objectList[indexPath.row]
        let titleHeight:CGFloat = calculateHeight(model.content!, size: 17, width: 0.8 * self.contentView.frame.size.width - 15)
            if self.block != nil{
                self.block(self.contentView.frame.size.width * 0.2 + titleHeight - 20)
        }
        return self.contentView.frame.size.width * 0.2 + titleHeight - 20
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(QCCommentCell.QCCommentCell()) as! QCCommentCell
                //  取数据
        let model = self.dataSource.objectList[indexPath.row]
            
                //  进行填充cell
        cell.fillCellWithModel(model)
        return cell
    }

//    func fillCellWithModel(selfGrownInfo:SelfGrownInfo){
//        contentLbl.text = selfGrownInfo.content!
//        print("contentLbl.text")
//        print(contentLbl.text)
//        print("contentLbl.text")
//        timeLbl.text = selfGrownInfo.write_time!
//        senderLbl.text = selfGrownInfo.name!
//        //  对视图cell进行处理
//        //  图片尺寸，图片大小
////        bigImageView.sd_setImageWithURL(NSURL.init(string: (microblogImageUrl+selfGrownInfo.cover_photo!)))
//        
//        //  对write_time  进行拆分，进行填充数据
//        //  
//        
//    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
