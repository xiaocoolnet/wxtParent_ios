//
//  QCFirendCell.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/3.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class QCFirendCell: UITableViewCell,UITableViewDelegate,UITableViewDataSource {
    
    var indexPath = NSIndexPath()
    var a:Int!
    var b:CGFloat!
    var c = CGFloat()
    
    //  创建控件
    var weekLabel:UILabel!
    var dataLabel:UILabel!
    var lineView:UIView!
    
    var listView: UIView!
    
    var contentLabel:UILabel!
    var photoImageView:UIImageView!
    var headerImageView:UIImageView!
    var usernameLabel:UILabel!
    var create_timeLabel:UILabel!
    //  点赞btn
    var priseButton:UIButton!
    var commentButton:UIButton!
    //  点赞图片
    var priseImageView:UIImageView!
    var priseLabel:UILabel!
    //  可以得到
    var viewHight = CGFloat()
    //  已知
    var listViewWidth = CGFloat()
    var titleHight = CGFloat()
    var tableView = UITableView()
    var dataSource = QCCommentInfo()
    
    var array = NSMutableArray()
    
    var id = String()
    
    
    //  控件的初始化 (重写init的方法)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //   初始化
        weekLabel = UILabel(frame:CGRectMake(10, 10, WIDTH / 6.0, 20))
        weekLabel.textColor = UIColor.grayColor()
        weekLabel.font = UIFont.systemFontOfSize(14)
        dataLabel = UILabel(frame:CGRectMake(10, 40, WIDTH / 6.0 - 20, 20))
        dataLabel.textColor = UIColor.whiteColor()
        dataLabel.font = UIFont.systemFontOfSize(12)
        //  设置倒角
        dataLabel.layer.cornerRadius = 12
        dataLabel.backgroundColor = RGBA(155, g: 240, b: 180, a: 1)
        //  创建视图
        createUI()

        //  需要设置tableview的高度
        addTableView()
        //  添加一个tableview
        createTableView()

        //  添加到cell中
        self.contentView.addSubview(weekLabel)
        self.contentView.addSubview(dataLabel)
        self.contentView.addSubview(lineView)
        

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")

    }
    func addTableView(){
        tableView.frame = CGRectMake(WIDTH / 6.0, viewHight + 60, WIDTH / 6.0 * 5.0 - 10,self.contentView.frame.size.height - viewHight - 60)
//        tableView.frame = CGRectMake(WIDTH / 6.0, viewHight + 60, WIDTH / 6.0 * 5.0 - 10,CGFloat (self.dataSource.count) * 44)

        self.tableView.backgroundColor = UIColor.whiteColor()
        self.contentView.addSubview(tableView)

    }
    func createUI(){
        //  获取 viewHight 的高度
        viewHight = (WIDTH / 6.0 * 5.0 - 10 - 20) * 0.6 + titleHight + 75
        lineView = UIView(frame:CGRectMake(WIDTH / 12.0 - 0.5, 60, 1, viewHight))
        lineView.backgroundColor = RGBA(155, g: 240, b: 180, a: 1)
        listView = UIView(frame:CGRectMake(WIDTH / 6.0, 10, WIDTH / 6.0 * 5.0 - 10, viewHight + 45))
        listView.backgroundColor = UIColor.whiteColor()
        self.contentView.addSubview(listView)

        //    在listView上面添加控件
        //  自动计算高度
        listViewWidth = listView.frame.size.width

        let contentHight:CGFloat = titleHight
        contentLabel = UILabel(frame:CGRectMake(10, 10, listViewWidth - 20, contentHight))
        
        photoImageView = UIImageView(frame:CGRectMake(10, contentHight + 15, listViewWidth - 20, (listViewWidth - 20) * 0.6))
        headerImageView = UIImageView(frame:CGRectMake(10, (listViewWidth - 20) * 0.6 + contentHight + 25, 20, 20))

        usernameLabel = UILabel(frame:CGRectMake(40, (listViewWidth - 20) * 0.6 + contentHight + 25, 100, 20))
        usernameLabel.textColor = UIColor.lightGrayColor()
        usernameLabel.font = UIFont.systemFontOfSize(14)
        create_timeLabel = UILabel(frame:CGRectMake(10, (listViewWidth - 20) * 0.6 + contentHight + 50, 100, 20))
        create_timeLabel.textColor = UIColor.lightGrayColor()
        create_timeLabel.font = UIFont.systemFontOfSize(14)
        commentButton = UIButton(frame:CGRectMake(listViewWidth - 50, (listViewWidth - 20) * 0.6 + contentHight + 45, 20, 20))
        //  评论button
        commentButton.setBackgroundImage(UIImage(named: "评论"), forState: .Normal)
        //  点赞button
        priseButton = UIButton(frame:CGRectMake(listViewWidth - 90, (listViewWidth - 20) * 0.6 + contentHight + 45, 20, 20))
        priseImageView = UIImageView(frame:CGRectMake(10, (listViewWidth - 20) * 0.6 + contentHight + 75, 20, 20))
        priseLabel = UILabel(frame:CGRectMake(40, (listViewWidth - 20) * 0.6 + contentHight + 75, 100, 20))
        priseLabel.textColor = RGBA(155, g: 240, b: 180, a: 1)
        priseLabel.font = UIFont.systemFontOfSize(14)
        priseButton.setBackgroundImage(UIImage(named: "评论"), forState: .Normal)
        
        
        //  list视图的总高度
//        viewHight = (listViewWidth - 20) * 0.6 + contentHight + 95

        listView.addSubview(contentLabel)
        listView.addSubview(photoImageView)
        listView.addSubview(headerImageView)
        listView.addSubview(usernameLabel)
        listView.addSubview(create_timeLabel)
        listView.addSubview(priseButton)
        listView.addSubview(commentButton)
        listView.addSubview(priseImageView)
        listView.addSubview(priseLabel)

        
    }
    func createTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.scrollEnabled = false
        //   注册cell
        tableView .registerClass(QCCommentCell.self, forCellReuseIdentifier: "cell")
    }

    //             MARK: - 得到评论的数据请求
    func GETComment(){
        //  http://wxt.xiaocool.net/index.php?g=apps&m=school&a=GetCommentlist&userid=597&refid=150&type=3
        //  需要通过沙盒进行取值
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let userid = userDefaults.stringForKey("userid")
        print(userid)
        //  这个是进行传值
        let refid = self.id
        //   这个事对应发表的内容进行加载的
        print(refid)
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


    //  cell的填充
    func fillCellWithModel(model:QCFirendModel,indexPath: NSIndexPath){
        
        self.indexPath = indexPath
        self.weekLabel.text = "星期一"
        self.dataLabel.text = "4月30日"
        //  设置 内容 的高度
        titleHight = calculateHeight(model.content!, size: 17, width: listViewWidth)
        self.contentLabel.frame.size.height = titleHight

        //  使用通知中心进行传递高度
        let center = NSNotificationCenter.defaultCenter()
        center.postNotificationName("得到的高度", object: (WIDTH / 6.0 * 5.0 - 10 - 20) * 0.6 + titleHight + 120)
        //  移除
        center.removeObserver(self, name: "得到的高度", object: nil)
        let views = listView.subviews
        for view in views{
            view.removeFromSuperview()
        }
        listView.removeFromSuperview()
        tableView.removeFromSuperview()
        createUI()
        addTableView()
        self.tableView.reloadData()
        //  移除所有的控件 重走创建控件的方法
        self.contentLabel.numberOfLines = 0
        self.contentLabel.text = model.content
        let imageURL = imageUrl + model.photo!
        photoImageView.sd_setImageWithURL(NSURL.init(string: imageURL), placeholderImage: UIImage(named: "1.png"))
//        photoImageView.image = UIImage(named: "wxt_3.png")
        
        self.headerImageView.image = UIImage(named: "ic_fasong")
        self.usernameLabel.text = model.username
        self.create_timeLabel.text = model.create_time
        self.priseImageView.image = UIImage(named: "点赞")
        self.priseLabel.text = "0人点赞"
        self.id = model.id!
        self.GETComment()

    }
    
    //  MARK: - tableView 的代理方法
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if self.indexPath.length != 0 {
            for _ in 0...self.indexPath.row{
//                let c = arc4random() % 4
//                a = Int (c)
                //  count  为 0
                //  评论的条数 直接解析得到了所有评论的数据 
                a = self.dataSource.count
            }
            return a
        }else{
            return 0
        }    }
    //  没有走这个方法
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //  认证cell

        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! QCCommentCell
        cell.selectionStyle = .None
        let model = self.dataSource.objectList[indexPath.row]
        cell.fillCellWithModel(model)
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //  把上个界面的  row  传过来 通过上个界面row的到这个界面的评论的个数和评论的所有高度

        if self.indexPath.length != 0 {

            for _ in 0...self.indexPath.row{
                let model = self.dataSource.objectList[indexPath.row]

                let height = calculateHeight(model.content!, size: 17, width: WIDTH / 6.0 * 5.0 - 30)
//                let c = arc4random() % 4 * 50
                if b != 0 {
                b = height + 60
                }


            }

            


            //  保存一下
                
            //  动态计算的到的高度

            //  使用通知中心进行传递高度

            return b
        }else{
            return 0
        }
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
