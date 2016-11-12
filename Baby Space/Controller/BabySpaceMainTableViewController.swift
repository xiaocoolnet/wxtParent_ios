//
//  BabySpaceMainTableViewController.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/1/18.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import XWSwiftRefresh
import Alamofire
import MBProgressHUD

class BabySpaceMainTableViewController: UITableViewController, IChatManagerDelegate, UIAlertViewDelegate {

    
    @IBOutlet var tableSource: UITableView!
    @IBOutlet weak var childrenAvator: UIImageView!
    @IBOutlet weak var childrenClass: UILabel!
    @IBOutlet weak var childrenName: UILabel!
    @IBOutlet weak var childrenSex: UIImageView!
    @IBOutlet weak var childrenAge: UILabel!
    @IBOutlet weak var childrenSchoole: UILabel!
    //  时间  温度
    @IBOutlet weak var arriveTimeLabel: UILabel!
    @IBOutlet weak var leaveTimeLabel: UILabel!
    @IBOutlet weak var arriveTemperatureLabel: UILabel!
    @IBOutlet weak var leavearriveTemperatureLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var noticeBtn: UIButton!
    @IBOutlet weak var activityBtn: UIButton!
    @IBOutlet weak var trustBtn: UIButton!
    @IBOutlet weak var leaveBtn: UIButton!
    @IBOutlet weak var daijieBtn: UIButton!
    @IBOutlet weak var messageBtn: UIButton!
    @IBOutlet weak var photoBtn: UIButton!
    var dataSource = InviteList()
    var array = NSMutableArray()
    var personDate = personList()
    
    
    var weightSource = sta_weiInfomationList()
    
    
    var blog=BlogMainTableTableViewController()
    
    var oneBtn = UIButton()
    var twoBtn = UIButton()
    var threeBtn = UIButton()
    var fourBtn = UIButton()
    var fiveBtn = UIButton()
    var lable = UILabel()
    var lab = UILabel()
    var messageLab = UILabel()
    var daijieLab = UILabel()
    var leaveLab = UILabel()
    var trustLab = UILabel()
    var activityLab = UILabel()
    var noticeLab = UILabel()
    var commentLab = UILabel()
    var cou = Int()
    var coun = Int()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//      self.navigationController?.tabBarItem.badgeValue = "3"
//        createButton()
        self.GetData()
        childrenClass.layer.cornerRadius = 8
        childrenClass.layer.masksToBounds = true
        
        messageLab.frame = CGRectMake(45, 0, 18, 18)
        messageLab.backgroundColor = UIColor.redColor()
        messageLab.textColor = UIColor.whiteColor()
        messageLab.layer.cornerRadius = 9
        messageLab.layer.masksToBounds = true
        messageLab.font = UIFont.systemFontOfSize(12)
        messageLab.textAlignment = NSTextAlignment.Center
        
        daijieLab.frame = CGRectMake(45, 0, 18, 18)
        daijieLab.backgroundColor = UIColor.redColor()
        daijieLab.textColor = UIColor.whiteColor()
        daijieLab.layer.cornerRadius = 9
        daijieLab.layer.masksToBounds = true
        daijieLab.font = UIFont.systemFontOfSize(12)
        daijieLab.textAlignment = NSTextAlignment.Center
        
        leaveLab.frame = CGRectMake(45, 0, 18, 18)
        leaveLab.backgroundColor = UIColor.redColor()
        leaveLab.textColor = UIColor.whiteColor()
        leaveLab.layer.cornerRadius = 9
        leaveLab.layer.masksToBounds = true
        leaveLab.font = UIFont.systemFontOfSize(12)
        leaveLab.textAlignment = NSTextAlignment.Center
        
        
        trustLab.frame = CGRectMake(45, 0, 18, 18)
        trustLab.backgroundColor = UIColor.redColor()
        trustLab.textColor = UIColor.whiteColor()
        trustLab.layer.cornerRadius = 9
        trustLab.layer.masksToBounds = true
        trustLab.font = UIFont.systemFontOfSize(12)
        trustLab.textAlignment = NSTextAlignment.Center
        
        
        activityLab.frame = CGRectMake(45, 0, 18, 18)
        activityLab.backgroundColor = UIColor.redColor()
        activityLab.textColor = UIColor.whiteColor()
        activityLab.layer.cornerRadius = 9
        activityLab.layer.masksToBounds = true
        activityLab.font = UIFont.systemFontOfSize(12)
        activityLab.textAlignment = NSTextAlignment.Center
        
        noticeLab.frame = CGRectMake(45, 0, 18, 18)
        noticeLab.backgroundColor = UIColor.redColor()
        noticeLab.textColor = UIColor.whiteColor()
        noticeLab.layer.cornerRadius = 9
        noticeLab.layer.masksToBounds = true
        noticeLab.font = UIFont.systemFontOfSize(12)
        noticeLab.textAlignment = NSTextAlignment.Center
        
        commentLab.frame = CGRectMake(45, 0, 18, 18)
        commentLab.backgroundColor = UIColor.redColor()
        commentLab.textColor = UIColor.whiteColor()
        commentLab.layer.cornerRadius = 9
        commentLab.layer.masksToBounds = true
        commentLab.font = UIFont.systemFontOfSize(12)
        commentLab.textAlignment = NSTextAlignment.Center

        
        DropDownUpdate()
        
        
        EaseMob.sharedInstance().chatManager.removeDelegate(self)
        EaseMob.sharedInstance().chatManager.addDelegate(self, delegateQueue: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.gameOver(_:)), name: "push", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.game(_:)), name: "count", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.trust(_:)), name: "trustArr", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.notice(_:)), name: "noticeArr", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.daijie(_:)), name: "deliArr", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.leave(_:)), name: "leaveArr", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.activity(_:)), name: "activityArr", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.comment(_:)), name: "commentArr", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.homework(_:)), name: "homeworkArr", object: nil)
        
    }
    
    
    func game(count:NSNotification){
//        let arr = count.object as! NSArray
        print((count.object as! NSArray).count)
        lab.text = String((count.object as! NSArray).count)
        if (count.object as! NSArray).count != 0 {
            messageBtn.addSubview(messageLab)
        }
        cou = (count.object as! NSArray).count
        conect()

        print("lable =", messageLab.text)
    }
    func homework(count:NSNotification){
        //        let arr = count.object as! NSArray
        print((count.object as! NSArray).count)
        lab.text = String((count.object as! NSArray).count)
        if (count.object as! NSArray).count != 0 {
            messageBtn.addSubview(messageLab)
        }
        coun = (count.object as! NSArray).count
        conect()
        print("lable =", messageLab.text)
    }
    
    func conect(){
        messageLab.text = String(cou + coun)
    }
    
    func daijie(count:NSNotification){
//        let arr = count.object as! NSArray
        daijieLab.text = String((count.object as! NSArray).count)
        print("labl =", count.object as? String)
        if (count.object as! NSArray).count != 0 {
            daijieBtn.addSubview(daijieLab)
        }

    }
    func leave(count:NSNotification){
//        let arr = count.object as! NSArray
        leaveLab.text = String((count.object as! NSArray).count)
        if (count.object as! NSArray).count != 0 {
            leaveBtn.addSubview(leaveLab)
        }
        print("lab =", (count.object as? NSArray)?.count)
    }
    func trust(count:NSNotification){
//        let arr = count.object as! NSArray
        trustLab.text = String((count.object as! NSArray).count)
        if (count.object as! NSArray).count != 0 {
            trustBtn.addSubview(trustLab)
        }

        print("la =", count.object as? String)
    }
    func activity(count:NSNotification){
//        let arr = count.object as! NSArray
        activityLab.text = String((count.object as! NSArray).count)
        print("l =", count.object as? String)
        if (count.object as! NSArray).count != 0 {
            activityBtn.addSubview(activityLab)
        }

    }
    func notice(count:NSNotification){
//        let arr = count.object as! NSArray
        noticeLab.text = String((count.object as! NSArray).count)
        print("lable =", count.object as? String)
        if (count.object as! NSArray).count != 0 {
            noticeBtn.addSubview(noticeLab)
        }

    }
    func comment(count:NSNotification){
//        let arr = count.object as! NSArray
        commentLab.text = String((count.object as! NSArray).count)
        print(" =", count.object as? String)
        if (count.object as! NSArray).count != 0 {
            commentBtn.addSubview(commentLab)
        }

    }
    
    func gameOver(title:NSNotification){
        if title.object as! String == "message"{
            let vc = FSendNewsViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if title.object as! String == "trust"{
            let vc = ParentsExhortViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if title.object as! String == "notice"{
            let vc = NoticeTableViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if title.object as! String == "delivery"{
            let vc = QCTokenCompleteVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if title.object as! String == "homework"{
            let vc = TabViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if title.object as! String == "leave"{
            let vc = LeaveViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if title.object as! String == "activity"{
            let vc = ClassActivitiesTableViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if title.object as! String == "comment"{
            let vc = TeacherCommentsTableViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if title.object as! String == "newMessage"{
            let vc = ChetViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
            
    }
    
    
    
    
    func createButton() {
        oneBtn = UIButton()
        oneBtn.frame = CGRectMake((childrenAvator.frame.maxX)+50, 80, 35, 35)
        oneBtn.layer.cornerRadius = 17.5
        oneBtn.clipsToBounds = true
        oneBtn.tag = 1
        
        twoBtn = UIButton()
        twoBtn.frame = CGRectMake((childrenAvator.frame.maxX)+10, 116, 35, 35)
        twoBtn.layer.cornerRadius = 17.5
        twoBtn.clipsToBounds = true
        
        threeBtn = UIButton()
        threeBtn.frame = CGRectMake((childrenAvator.frame.maxX)-52, 134, 35, 35)
//        threeBtn.backgroundColor = UIColor.lightGrayColor()
        threeBtn.layer.cornerRadius = 17.5
        threeBtn.clipsToBounds = true
        
        fourBtn = UIButton()
        fourBtn.frame = CGRectMake((childrenAvator.frame.maxX)-118, 116, 35, 35)
        fourBtn.layer.cornerRadius = 17.5
        fourBtn.clipsToBounds = true
        
        fiveBtn = UIButton()
        fiveBtn.frame = CGRectMake((childrenAvator.frame.maxX)-154, 80, 35, 35)
        fiveBtn.layer.cornerRadius = 17.5
        fiveBtn.clipsToBounds = true
        
        let model = self.dataSource.objectlist
        
        if model.count == 1 {
            let pic = model[0].parent_info[0].photo
            let imgUrl = microblogImageUrl + pic!
            let photourl = NSURL(string: imgUrl)
            oneBtn.setBackgroundImageForState(.Normal, withURL: photourl!, placeholderImage: UIImage(named: "默认头像"))
            oneBtn.tag = 0
            oneBtn.addTarget(self, action: #selector(self.clickBun), forControlEvents: .TouchUpInside)
            self.tableSource.addSubview(oneBtn)
            
            twoBtn.setImage(UIImage(named: "add2"), forState: .Normal)
            self.tableSource.addSubview(twoBtn)
            twoBtn.addTarget(self, action: #selector(self.clickAddBun), forControlEvents: .TouchUpInside)

        }else if model.count == 2{
            let pic = model[0].parent_info[0].photo
            let imgUrl = microblogImageUrl + pic!
            let photourl = NSURL(string: imgUrl)
            oneBtn.setBackgroundImageForState(.Normal, withURL: photourl!, placeholderImage: UIImage(named: "默认头像"))
            oneBtn.tag = 0
            oneBtn.addTarget(self, action: #selector(self.clickBun), forControlEvents: .TouchUpInside)
            self.tableSource.addSubview(oneBtn)
            
            let pic2 = model[1].parent_info[0].photo
            let imgUrl2 = microblogImageUrl + pic2!
            let photourl2 = NSURL(string: imgUrl2)
            twoBtn.setBackgroundImageForState(.Normal, withURL: photourl2!, placeholderImage: UIImage(named: "默认头像"))
            twoBtn.tag = 1
            twoBtn.addTarget(self, action: #selector(self.clickBun), forControlEvents: .TouchUpInside)
            self.tableSource.addSubview(twoBtn)
            
            threeBtn.setImage(UIImage(named: "add2"), forState: .Normal)
            self.tableSource.addSubview(threeBtn)
            threeBtn.addTarget(self, action: #selector(self.clickAddBun), forControlEvents: .TouchUpInside)
        
            
        }else if model.count == 3{
            let pic = model[0].parent_info[0].photo
            let imgUrl = microblogImageUrl + pic!
            let photourl = NSURL(string: imgUrl)
            oneBtn.setBackgroundImageForState(.Normal, withURL: photourl!, placeholderImage: UIImage(named: "默认头像"))
            oneBtn.tag = 0
            oneBtn.addTarget(self, action: #selector(self.clickBun), forControlEvents: .TouchUpInside)
            self.tableSource.addSubview(oneBtn)
            
            let pic2 = model[1].parent_info[0].photo
            let imgUrl2 = microblogImageUrl + pic2!
            let photourl2 = NSURL(string: imgUrl2)
            twoBtn.setBackgroundImageForState(.Normal, withURL: photourl2!, placeholderImage: UIImage(named: "默认头像"))
            twoBtn.tag = 1
            twoBtn.addTarget(self, action: #selector(self.clickBun), forControlEvents: .TouchUpInside)
            self.tableSource.addSubview(twoBtn)
            
            let pic3 = model[2].parent_info[0].photo
            let imgUrl3 = microblogImageUrl + pic3!
            let photourl3 = NSURL(string: imgUrl3)
            threeBtn.setBackgroundImageForState(.Normal, withURL: photourl3!, placeholderImage: UIImage(named: "默认头像"))
            threeBtn.tag = 2
            threeBtn.addTarget(self, action: #selector(self.clickBun), forControlEvents: .TouchUpInside)
            self.tableSource.addSubview(threeBtn)
            
            fourBtn.setImage(UIImage(named: "add2"), forState: .Normal)
            self.tableSource.addSubview(fourBtn)
            fourBtn.addTarget(self, action: #selector(self.clickAddBun), forControlEvents: .TouchUpInside)

        }else if model.count >= 4 {
            let pic = model[0].parent_info[0].photo
            let imgUrl = microblogImageUrl + pic!
            let photourl = NSURL(string: imgUrl)
            oneBtn.setBackgroundImageForState(.Normal, withURL: photourl!, placeholderImage: UIImage(named: "默认头像"))
            oneBtn.tag = 0
            oneBtn.addTarget(self, action: #selector(self.clickBun), forControlEvents: .TouchUpInside)
            self.tableSource.addSubview(oneBtn)
            
            let pic2 = model[1].parent_info[0].photo
            let imgUrl2 = microblogImageUrl + pic2!
            let photourl2 = NSURL(string: imgUrl2)
            twoBtn.setBackgroundImageForState(.Normal, withURL: photourl2!, placeholderImage: UIImage(named: "默认头像"))
            twoBtn.tag = 1
            twoBtn.addTarget(self, action: #selector(self.clickBun), forControlEvents: .TouchUpInside)
            self.tableSource.addSubview(twoBtn)
            
            let pic3 = model[2].parent_info[0].photo
            let imgUrl3 = microblogImageUrl + pic3!
            let photourl3 = NSURL(string: imgUrl3)
            threeBtn.setBackgroundImageForState(.Normal, withURL: photourl3!, placeholderImage: UIImage(named: "默认头像"))
            threeBtn.tag = 2
            threeBtn.addTarget(self, action: #selector(self.clickBun), forControlEvents: .TouchUpInside)
            self.tableSource.addSubview(threeBtn)
            
            let pic4 = model[3].parent_info[0].photo
            let imgUrl4 = microblogImageUrl + pic4!
            let photourl4 = NSURL(string: imgUrl4)
            fourBtn.setBackgroundImageForState(.Normal, withURL: photourl4!, placeholderImage: UIImage(named: "默认头像"))
            fourBtn.tag = 3
            fourBtn.addTarget(self, action: #selector(self.clickBun), forControlEvents: .TouchUpInside)
            self.tableSource.addSubview(fourBtn)
            if model.count == 4 {
                fiveBtn.setImage(UIImage(named: "add2"), forState: .Normal)
                self.tableSource.addSubview(fiveBtn)
                
                fiveBtn.addTarget(self, action: #selector(self.clickAddBun), forControlEvents: .TouchUpInside)
            }else{
                let pic5 = model[4].parent_info[0].photo
                let imgUrl5 = microblogImageUrl + pic5!
                let photourl5 = NSURL(string: imgUrl5)
                fiveBtn.setBackgroundImageForState(.Normal, withURL: photourl5!, placeholderImage: UIImage(named: "默认头像"))
                fiveBtn.tag = 4
                fiveBtn.addTarget(self, action: #selector(self.clickBun), forControlEvents: .TouchUpInside)
                self.tableSource.addSubview(fiveBtn)
            }

        }
        

    }
    
    func clickBun(sender:UIButton){
        let vc = XinxiViewController()
        vc.dataSource = self.dataSource.objectlist[sender.tag]
    
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //    加载数据
    func GetData(){
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=GetInviteFamily"
        //       http://wxt.xiaocool.net/index.php?g=apps&m=student&a=GetInviteFamily&studentid=597
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let studentid = userDefaults.stringForKey("chid")
        
        let param = [
            "studentid":studentid
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
                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.mode = MBProgressHUDMode.Text;
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                
                if(status.status == "success"){
                    self.dataSource = InviteList(status.data!)
                    self.oneBtn.removeFromSuperview()
                    self.twoBtn.removeFromSuperview()
                    self.threeBtn.removeFromSuperview()
                    self.fourBtn.removeFromSuperview()
                    self.fiveBtn.removeFromSuperview()
                    self.createButton()
                    self.tableSource.reloadData()
                }
            }
            
        }
    }

    func clickAddBun(){
        print("邀请家人")
        let invitationVC = QCInvitationVC()
        self.navigationController?.pushViewController(invitationVC, animated: true)
    }
    
    
    //  MARK: - 代接确认
    @IBAction func toTakeAction(sender: AnyObject) {
        let vc = QCKindTakeVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func GetDate(){
        tableSource.reloadData()
        tableSource.headerView?.endRefreshing()
        self.getPerson()
        self.GetChange_sta_wei()
        self.GetData()
        self.GetHeight()
        
    }
//    刷新
    func DropDownUpdate(){
        tableSource.headerView = XWRefreshNormalHeader(target: self, action: #selector(BabySpaceMainTableViewController.GetDate))
        self.GetData()
        tableSource.headerView?.beginRefreshing()
    }
    
    override func viewWillAppear(animated: Bool) {
//        DropDownUpdate()
        GetDate()
        GetData()
        self.getPerson()
        self.tabBarController?.tabBar.hidden = false
        //        设置宝宝名字
        let chid = NSUserDefaults.standardUserDefaults()
        let chidname = chid.stringForKey("chidname")
        let schoolname = chid.stringForKey("school_name")
        self.childrenName.text = chidname
        self.childrenSchoole.text = schoolname
        if chid.valueForKey("count") != nil || chid.valueForKey("homework") != nil {
            
            let arr = chid.valueForKey("count") as! NSArray
//            let arra = chid.valueForKey("homework") as! NSArray
            messageLab.text = String(arr.count + array.count)
        }else{
            messageLab.removeFromSuperview()
        }
        if messageLab.text == "0" {
            messageLab.removeFromSuperview()
        }
        if chid.valueForKey("trustArr") != nil {
            
            let arr = chid.valueForKey("trustArr") as! NSArray
            trustLab.text = String(arr.count)
        }else{
            trustLab.removeFromSuperview()
        }
        if trustLab.text == "0" {
            trustLab.removeFromSuperview()
        }
        if chid.valueForKey("noticeArr") != nil {
            
            let arr = chid.valueForKey("noticeArr") as! NSArray
            noticeLab.text = String(arr.count)
        }else{
            noticeLab.removeFromSuperview()
        }
        if noticeLab.text == "0" {
            noticeLab.removeFromSuperview()
        }
        if chid.valueForKey("deliArr") != nil {
            
            let arr = chid.valueForKey("deliArr") as! NSArray
            daijieLab.text = String(arr.count)
        }else{
            daijieLab.removeFromSuperview()
        }
        if daijieLab.text == "0" {
            daijieLab.removeFromSuperview()
        }
        if chid.valueForKey("leaveArr") != nil {
            
            let arr = chid.valueForKey("leaveArr") as! NSArray
            leaveLab.text = String(arr.count)
        }else{
            leaveLab.removeFromSuperview()
        }
        if leaveLab.text == "0" {
            leaveLab.removeFromSuperview()
        }
        if chid.valueForKey("activityArr") != nil {
            
            let arr = chid.valueForKey("activityArr") as! NSArray
            activityLab.text = String(arr.count)
        }else{
            activityLab.removeFromSuperview()
        }
        if activityLab.text == "0" {
            activityLab.removeFromSuperview()
        }
        if chid.valueForKey("commentArr") != nil {
            
            let arr = chid.valueForKey("commentArr") as! NSArray
            commentLab.text = String(arr.count)
        }else{
            commentLab.removeFromSuperview()
        }
        if commentLab.text == "0" {
            commentLab.removeFromSuperview()
        }
        
       
    }
    
    
//    获取体重信息
    func GetChange_sta_wei(){
//       http://wxt.xiaocool.net/index.php?g=apps&m=index&a=GetChange_weight&stuid=599
        let chid = NSUserDefaults.standardUserDefaults()
        let stuid = chid.stringForKey("chid")
        let url = apiUrl+"GetChange_weight"
        let param = [
            "stuid":stuid!
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
                    //  获取数据成功
                    //  得到数据源
                    //   sta_weiInfomation(status.data!)  对里面的数据进行转型
                    self.weightSource = sta_weiInfomationList(status.data!)
                    print(self.dataSource)
                    let nowDate = NSDate()
                    let formatter = NSDateFormatter()
                    formatter.dateFormat = "yyyy.MM.dd"
                    let dateString = formatter.stringFromDate(nowDate)
                    if self.weightSource.objectlist.count != 0{
                    if dateString == self.weightSource.objectlist[0].log_date {
                        self.weightLabel.text = self.weightSource.objectlist[0].weight
                    }else{
                        self.weightLabel.text = " "
                        }
                    }else{
                        self.weightLabel.text = " "
                    }
                    self.tableSource.reloadData()
                }
                
            }
            
        }

    }
    
    func GetHeight(){
        //       http://wxt.xiaocool.net/index.php?g=apps&m=index&a=GetChange_weight&stuid=599
        let chid = NSUserDefaults.standardUserDefaults()
        let stuid = chid.stringForKey("chid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=index&a=GetChange_stature"
        let param = [
            "stuid":stuid!
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
                    //  获取数据成功
                    //  得到数据源
                    //   sta_weiInfomation(status.data!)  对里面的数据进行转型
                    self.weightSource = sta_weiInfomationList(status.data!)
                    print(self.dataSource)
                    let nowDate = NSDate()
                    let formatter = NSDateFormatter()
                    formatter.dateFormat = "yyyy.MM.dd"
                    let dateString = formatter.stringFromDate(nowDate)
                    if self.weightSource.objectlist.count != 0{
                        
                        if dateString == self.weightSource.objectlist[0].log_date {
                            self.heightLabel.text = self.weightSource.objectlist[0].stature
                        }else{
                            self.heightLabel.text = " "
                        }
                    }else{
                        self.heightLabel.text = " "
                    }
                    self.tableSource.reloadData()
                }
                
            }
            
        }
        
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 0.01
    }
    
    func getPerson(){
        //  http://wxt.xiaocool.net/index.php?g=apps&m=student&a=GetBabyInfo&studentid=661
        //下面两句代码是从缓存中取出userid（入参）值
        let defalutid = NSUserDefaults.standardUserDefaults()
        let sid = defalutid.stringForKey("chid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=GetBabyInfo"
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
                    self.personDate = personList(status.data!)
                    self.tableSource.reloadData()
                    self.tableSource.headerView?.endRefreshing()
                    self.create()
                }
            }
        }

    }
    // 宝宝空间顶部的个人信息
    func create(){
        let model = self.personDate.objectlist[0]
        childrenName.text = model.name
        childrenClass.text = model.classname
        let pic = model.avatar
        let imgUrl = microblogImageUrl + pic!
        let photourl = NSURL(string: imgUrl)
        childrenAvator.sd_setImageWithURL(photourl, placeholderImage: UIImage(named: "默认头像"))
        childrenAvator.layer.cornerRadius = 34.5
        childrenAvator.clipsToBounds = true
    }
    
    
   
  
}
