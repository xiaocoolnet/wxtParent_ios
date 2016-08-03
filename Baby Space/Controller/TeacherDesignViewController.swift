////
////  TeacherDesignViewController.swift
////  WXT_Parents
////
////  Created by 沈晓龙 on 16/8/2.
////  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
////
//
//import UIKit
//import Alamofire
//import MBProgressHUD
//import XWSwiftRefresh
//
//class TeacherDesignViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    
//    let tableView = UITableView()
//    var startday = Int()
//    //  结束时间戳
//    var endday = Int()
//    
//    var nowDate: NSDate = NSDate()  //当前日期
//    var getOneweek=0    //获取到年月的1号是周几
//    var daycount=0        //获取到年月的总天数
//    var dataArray = NSMutableArray()
//    var dataSourse = TeacherCommentModel()
//    
//    //类似于OC中的typedef
//    typealias CallbackSelectedValue=(value:[String])->Void
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        initUI()
//        self.createView()
//        createTableView()
//        self.GET(endday, begindate: startday)
//        
//    }
//    
//    
//    func initUI(){
//        self.title = NSUserDefaults.standardUserDefaults().valueForKey("chidname") as? String
//        self.tabBarController?.tabBar.hidden = true
//    }
//    
//    func createView(){
//        let view = UIView()
//        view.frame = CGRectMake(0, 60, WIDTH, 60)
//        view.backgroundColor = UIColor.whiteColor()
//        self.view.addSubview(view)
//        //  添加button
//        let leftBtn = UIButton()
//        leftBtn.frame  = CGRectMake((WIDTH - 200) / 2, 10, 50, 30)
//        leftBtn.setImage(UIImage(named: "右侧箭头"), forState: .Normal)
//        leftBtn.addTarget(self, action: #selector(self.leftClickBtn), forControlEvents: .TouchUpInside)
//        view.addSubview(leftBtn)
//        
//        let rightBtn = UIButton()
//        rightBtn.frame  = CGRectMake(WIDTH / 2 + 50, 10, 50, 30)
//        rightBtn.setImage(UIImage(named: "右侧箭头"), forState: .Normal)
//        rightBtn.addTarget(self, action: #selector(self.rightClickBtn), forControlEvents: .TouchUpInside)
//        view.addSubview(rightBtn)
//        
//        let nowDate = NSDate()
//        let formatter = NSDateFormatter()
//        formatter.dateFormat = "yyyy-MM"
//        let dateString = formatter.stringFromDate(nowDate)
//        
//        let timeLabel = UILabel()
//        timeLabel.frame = CGRectMake(WIDTH / 2 - 50, 10, 100, 30)
//        timeLabel.textAlignment = NSTextAlignment.Center
//        //      需要得到数据
//        timeLabel.text = dateString
//        view.addSubview(timeLabel)
//        
//        //  获取当月的开始时间和最终时间
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        //得到年月的1号
//        let date = dateFormatter.dateFromString("\(nowDate.currentYear)-\(nowDate.currentMonth)-01 23:59:59")
//        getOneweek = date!.toMonthOneDayWeek(date!)
//        daycount = date!.TotaldaysInThisMonth(date!)
//        //  获取当月开始时间戳
//        let timeInterval:NSTimeInterval = date!.timeIntervalSince1970
//        let timeStamp = Int(timeInterval)
//        print("当前时间的时间戳：\(timeStamp)")
//        daycount = date!.TotaldaysInThisMonth(date!)   //更新当前年月天数
//        print("99999999999999999999999")
//        print(daycount)
//        endday = timeStamp  + (daycount - 1) * 86400
//        print("最后一天：\(endday)")
//        startday = timeStamp
//    }
//    
//    func createTableView(){
//        tableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT - 60)
//        tableView.separatorStyle = .None
//        tableView.dataSource = self
//        tableView.delegate = self
//        self.view.addSubview(tableView)
//        tableView.registerClass(QCTeacherCommentCell.self, forCellReuseIdentifier: "cell")
//        
//    }
//
//    func leftClickBtn() {
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        var date = NSDate()
//        //得到年月的1号
//        if((nowDate.currentMonth-1)==0){
//            let str:String="\(nowDate.currentYear-1)-\(12)-01 23:59:59"
//            date = dateFormatter.dateFromString(str)!
//            print("++++++++++")
//            print(date)
//        }
//        else{
//            let str:String="\(nowDate.currentYear)-\(nowDate.currentMonth-1)-01 23:59:59"
//            date = dateFormatter.dateFromString(str)!
//            print("***************")
//            print(date)
//            
//        }
//        //  获取当前时间戳
//        let timeInterval:NSTimeInterval = date.timeIntervalSince1970
//        let timeStamp = Int(timeInterval)
//        print("当前时间的时间戳：\(timeStamp)")
//        nowDate=date    //更新当前的年月
//        daycount = date.TotaldaysInThisMonth(date)  //更新当前年月天数
//        print("99999999999999999999999")
//        print(daycount)
//        endday = timeStamp  + (daycount - 1) * 86400
//        print("最后一天：\(endday)")
//        startday = timeStamp
//        GET(endday, begindate: startday)
//        
//    }
//    
//    func rightClickBtn() {
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        var date = NSDate()
//        
//        //得到年月的1号
//        if((nowDate.currentMonth+1)==13){
//            date = dateFormatter.dateFromString("\(nowDate.currentYear+1)-\(01)-01 23:59:59")!
//            print("#############")
//            print(date)
//        }
//        else{
//            date = dateFormatter.dateFromString("\(nowDate.currentYear)-\(nowDate.currentMonth+1)-01 23:59:59")!
//            print("$$$$$$$$$$")
//            print(date)
//            
//        }
//        //  获取当前时间戳
//        let timeInterval:NSTimeInterval = date.timeIntervalSince1970
//        let timeStamp = Int(timeInterval)
//        print("当前时间的时间戳：\(timeStamp)")
//        nowDate=date    //更新当前的年月
//        getOneweek = date.toMonthOneDayWeek(date)    //更新当前年月周
//        daycount = date.TotaldaysInThisMonth(date)   //更新当前年月天数
//        print("99999999999999999999999")
//        print(daycount)
//        endday = timeStamp  + (daycount - 1) * 86400
//        print("最后一天：\(endday)")
//        startday = timeStamp
//        GET(endday, begindate: startday)
//        
//    }
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.dataArray.count
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        if indexPath.section == 0 {
//            
//            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? QCTeacherCommentCell
//            cell!.selectionStyle = .None
//            
//            let info = (dataArray.objectAtIndex(indexPath.row) as? TeacherCommentInfo)!
//            
//            cell?.teacherLabel.text = "点评人:\(info.teacher_name)"
//            //  活动时间
//            let dateformate = NSDateFormatter()
//            dateformate.dateFormat = "yyyy-MM-dd HH:mm"
//            let date = NSDate(timeIntervalSince1970: NSTimeInterval(info.comment_time!)!)
//            let str:String = dateformate.stringFromDate(date)
//            cell?.timeLable.text = str
//            
//            
//            let pict = info.teacher_photo
//            let imgUrl = microblogImageUrl + pict!
//            let photourl = NSURL(string: imgUrl)
//            cell?.headerImageView.sd_setImageWithURL(photourl, placeholderImage: UIImage(named: "1"))
//            
//
//            
//            if info.learn == "1" {
//                cell?.studyButtonRHua.setImage(UIImage(named: "ic_hong"), forState: .Normal)
//            }else if info.learn == "2"{
//                cell?.studyButtonGHua.setImage(UIImage(named: "ic_ju"), forState: .Normal)
//            }else{
//                cell?.studyButtonZan.setImage(UIImage(named: "ic_huang"), forState: .Normal)
//            }
//            
//            if info.work == "1" {
//                cell?.actionButtonRHua.setImage(UIImage(named: "ic_hong"), forState: .Normal)
//            }else if info.learn == "2"{
//                cell?.actionButtonGHua.setImage(UIImage(named: "ic_ju"), forState: .Normal)
//            }else{
//                cell?.actionButtonZan.setImage(UIImage(named: "ic_huang"), forState: .Normal)
//            }
//            
//            if info.sing == "1" {
//                cell?.singButtonRHua.setImage(UIImage(named: "ic_hong"), forState: .Normal)
//            }else if info.learn == "2"{
//                cell?.singButtonGHua.setImage(UIImage(named: "ic_ju"), forState: .Normal)
//            }else{
//                cell?.singButtonZan.setImage(UIImage(named: "ic_huang"), forState: .Normal)
//            }
//            
//            if info.labour == "1" {
//                cell?.laborButtonRHua.setImage(UIImage(named: "ic_hong"), forState: .Normal)
//            }else if info.learn == "2"{
//                cell?.laborButtonGHua.setImage(UIImage(named: "ic_ju"), forState: .Normal)
//            }else{
//                cell?.laborButtonZan.setImage(UIImage(named: "ic_huang"), forState: .Normal)
//            }
//            
//            if info.strain == "1" {
//                cell?.skillButtonRHua.setImage(UIImage(named: "ic_hong"), forState: .Normal)
//            }else if info.learn == "2"{
//                cell?.skillButtonGHua.setImage(UIImage(named: "ic_ju"), forState: .Normal)
//            }else{
//                cell?.skillButtonZan.setImage(UIImage(named: "ic_huang"), forState: .Normal)
//            }
//            
//            if info.comment_status == "1" {
//                cell?.relationButtonRHua.setImage(UIImage(named: "ic_hong"), forState: .Normal)
//            }else if info.learn == "2"{
//                cell?.relationButtonGHua.setImage(UIImage(named: "ic_ju"), forState: .Normal)
//            }else{
//                cell?.relationButtonZan.setImage(UIImage(named: "ic_huang"), forState: .Normal)
//            }
//            
//            cell?.contentLable.text = info.comment_content
//            
//            
//            
//            return cell!
//        }else{
//            
//            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? QCTeacherCommentCell
//            cell!.selectionStyle = .None
//            
//            
//            return cell!
//        }
//    }
//    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return  480
//    }
//
//
//    //    创建表
//    func GET(enddate:Int,begindate:Int){
//        //        http://wxt.xiaocool.net/index.php?g=apps&m=student&a=GetTeacherComment&studentid=661&begintime=0&endtime=1469863987
//        //  得到url
//        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=GetTeacherComment"
//        let student = NSUserDefaults.standardUserDefaults()
//        let studentid = student.stringForKey("studentid")
//        //  得到请求体
//        let param = [
//            
//            "begintime":enddate,
//            "endtime":begindate,
//            "studentid":studentid!
//        ]
//        
//        Alamofire.request(.GET, url, parameters: param as? [String : AnyObject]).response
//            {   request,  response, json, error in
//                if(error != nil){
//                    print(error)
//                }
//                else{
//                    print("request是")
//                    print(request!)
//                    print("====================")
//                    let status = Http(JSONDecoder(json!))
//                    print("状态是")
//                    print(status.status)
//                    if(status.status == "error"){
//                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//                        hud.mode = MBProgressHUDMode.Text
//                        hud.labelText = status.errorData
//                        hud.margin = 10.0
//                        hud.removeFromSuperViewOnHide = true
//                        hud.hide(true, afterDelay: 1)
//                    }
//                    if(status.status == "success"){
//                        print("请求成功")
//                        self.dataArray.removeAllObjects()
//                        self.dataSourse = TeacherCommentModel(status.data!)
//                        print(self.dataSourse.count)
//
//                        if self.dataSourse.count != 0{
//                            for item in 0...self.dataSourse.count-1{
//                                let comment=self.dataSourse.objectlist[item]
//                                self.dataArray.addObject(comment)
//                            }}
//                        self.tableView.reloadData()
//                    }
//                }
//        }
//        
//        
//    }
//
//
//}
//// MARK: - 拓展日期类
//extension NSDate {
//    /**
//     这个月有几天
//     
//     - parameter date: nsdate
//     
//     - returns: 天数
//     */
//    func TotaldaysInThisMonth(date : NSDate ) -> Int {
//        let totaldaysInMonth: NSRange = NSCalendar.currentCalendar().rangeOfUnit(.Day, inUnit: .Month, forDate: date)
//        print("&&&&&&&&&&&&")
//        print(totaldaysInMonth.length)
//        
//        return totaldaysInMonth.length
//    }
//    
//    /**
//     得到本月的第一天的是第几周
//     
//     - parameter date: nsdate
//     
//     - returns: 第几周
//     */
//    func toMonthOneDayWeek (date:NSDate) ->Int {
//        let Week: NSInteger = NSCalendar.currentCalendar().ordinalityOfUnit(.Day, inUnit: NSCalendarUnit.WeekOfMonth, forDate: date)
//        return Week-1
//    }
//    
//    
//    /// 返回当前日期 年份
//    var currentYear:Int{
//        
//        get{
//            
//            return GetFormatDate("yyyy")
//        }
//        
//    }
//    /// 返回当前日期 月份
//    var currentMonth:Int{
//        
//        get{
//            
//            return GetFormatDate("MM")
//        }
//        
//    }
//    /// 返回当前日期 天
//    var currentDay:Int{
//        
//        get{
//            
//            return GetFormatDate("dd")
//        }
//        
//    }
//    /// 返回当前日期 小时
//    var currentHour:Int{
//        
//        get{
//            
//            return GetFormatDate("HH")
//        }
//        
//    }
//    /// 返回当前日期 分钟
//    var currentMinute:Int{
//        
//        get{
//            
//            return GetFormatDate("mm")
//        }
//        
//    }
//    /// 返回当前日期 秒数
//    var currentSecond:Int{
//        
//        get{
//            
//            return GetFormatDate("ss")
//        }
//        
//    }
//    
//    /**
//     获取yyyy  MM  dd  HH mm ss
//     
//     - parameter format: 比如 GetFormatDate(yyyy) 返回当前日期年份
//     
//     - returns: 返回值
//     */
//    func GetFormatDate(format:String)->Int{
//        let dateFormatter:NSDateFormatter = NSDateFormatter();
//        dateFormatter.dateFormat = format;
//        let dateString:String = dateFormatter.stringFromDate(self);
//        var dates:[String] = dateString.componentsSeparatedByString("")
//        let Value  = dates[0]
//        if(Value==""){
//            return 0
//        }
//        return Int(Value)!
//    }
//}
