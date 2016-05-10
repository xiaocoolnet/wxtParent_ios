//
//  WriteQJViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/5/5.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class WriteQJViewController: UIViewController,HZQDatePickerViewDelegate{

    var studentid:String?
    var teacherid:String?
    var teacherName:String?
    var studentName:String?
    let btn = UIButton()//开始时间按钮
    let btn1 = UIButton()//截止时间按钮
    
    let contentTextView = BRPlaceholderTextView()
    var pikerView = HZQDatePickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        XKeyBoard.registerKeyBoardHide(self)
        XKeyBoard.registerKeyBoardShow(self)
        self.title = "在线请假"
        self.view.backgroundColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1)
        let rightItem = UIBarButtonItem(title: "发送", style: .Done, target: self, action: #selector(WriteQJViewController.sendQJ))
        self.navigationItem.rightBarButtonItem = rightItem
        self.createUI()
    }
    //    发送
    func sendQJ(){
        self.writeQJ()
        
    }
    //    创建UI
    func createUI(){
        let v1 = UIView()
        v1.frame = CGRectMake(0, 0, self.view.frame.size.width, 121)
        v1.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(v1)
        
        let lbl1 = UILabel()
        lbl1.frame = CGRectMake(10, 20, 60, 20)
        lbl1.text = "请假者"
        lbl1.font = UIFont.systemFontOfSize(15)
        lbl1.textColor = UIColor(red: 171/255.0, green: 171/255.0, blue: 171/255.0, alpha: 1)
        v1.addSubview(lbl1)
        
        let lbl2 = UILabel()
        lbl2.frame = CGRectMake(80, 20, 100, 20)
        lbl2.text = studentName!
        v1.addSubview(lbl2)
        
        let lineView = UIView()
        lineView.frame = CGRectMake(0, 61, self.view.frame.size.width, 1)
        lineView.backgroundColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1)
        v1.addSubview(lineView)
        
        let lbl3 = UILabel()
        lbl3.frame = CGRectMake(10, 81, 60, 20)
        lbl3.text = "接收人"
        lbl3.font = UIFont.systemFontOfSize(15)
        lbl3.textColor = UIColor(red: 171/255.0, green: 171/255.0, blue: 171/255.0, alpha: 1)
        v1.addSubview(lbl3)
        
        let lbl4 = UILabel()
        lbl4.frame = CGRectMake(80, 81, 100, 20)
        lbl4.text = teacherName!
        v1.addSubview(lbl4)
        
        let v2 = UIView()
        v2.frame = CGRectMake(0, 131, self.view.frame.size.width, 121)
        v2.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(v2)
        
        let lbl5 = UILabel()
        lbl5.frame = CGRectMake(10, 20, 60, 20)
        lbl5.text = "开始时间"
        lbl5.font = UIFont.systemFontOfSize(15)
        lbl5.textColor = UIColor.blackColor()
        v2.addSubview(lbl5)
        
        
        btn.frame = CGRectMake(WIDTH-150, 20, 120, 20)
        btn.setTitle("选择时间", forState: .Normal)
        btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        btn.addTarget(self, action: #selector(WriteQJViewController.selectTime(_:)), forControlEvents: .TouchUpInside)
        btn.tag = 99
        v2.addSubview(btn)
        
        let imageView1 = UIImageView()
        imageView1.frame = CGRectMake(WIDTH-20, 20, 10, 20)
        imageView1.image = UIImage(named: "右边剪头.png")
        v2.addSubview(imageView1)
        
        let lineView1 = UIView()
        lineView1.frame = CGRectMake(0, 61, self.view.frame.size.width, 1)
        lineView1.backgroundColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1)
        v2.addSubview(lineView1)
        
        let lbl6 = UILabel()
        lbl6.frame = CGRectMake(10, 81, 60, 20)
        lbl6.text = "截止时间"
        lbl6.font = UIFont.systemFontOfSize(15)
        lbl6.textColor = UIColor.blackColor()
        v2.addSubview(lbl6)
        
        btn1.frame = CGRectMake(WIDTH-150, 81, 120, 20)
        btn1.setTitle("选择时间", forState: .Normal)
        btn1.setTitleColor(UIColor.blackColor(), forState: .Normal)
        btn1.addTarget(self, action: #selector(WriteQJViewController.selectTime(_:)), forControlEvents: .TouchUpInside)
        btn1.tag = 100
        v2.addSubview(btn1)
        
        let imageView2 = UIImageView()
        imageView2.frame = CGRectMake(WIDTH-20, 81, 10, 20)
        imageView2.image = UIImage(named: "右边剪头.png")
        v2.addSubview(imageView2)
        
        self.contentTextView.frame = CGRectMake(0, 262, self.view.bounds.width, 200)
        self.contentTextView.font = UIFont.systemFontOfSize(15)
        self.contentTextView.placeholder = "请输入请假事由"
        self.view.addSubview(self.contentTextView)
    }
//    写请假条
    func writeQJ(){
        //http://wxt.xiaocool.net/index.php?g=apps&m=student&a=addleave&teacherid=1&parentid=122&studentid=12&begintime=2016-05-01&endtime=2016-05-06&reason=生病了
//     将字符串转换成时间戳
        let dateformate = NSDateFormatter()
        dateformate.dateFormat = "yyyy-MM-dd"
        let date = dateformate.dateFromString((btn.titleLabel?.text!)!)
        let begintime:NSTimeInterval = (date?.timeIntervalSince1970)!
        let date1 = dateformate.dateFromString((btn1.titleLabel?.text!)!)
        let endtime:NSTimeInterval = (date1?.timeIntervalSince1970)!
        
        //下面两句代码是从缓存中取出userid（入参）值
        let defalutid = NSUserDefaults.standardUserDefaults()
        let uid = defalutid.stringForKey("userid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=student&a=addleave"
        let param = [
            "teacherid":teacherid!,
            "studentid":studentid!,
            "parentid":uid!,
            "begintime":begintime,
            "endtime":endtime,
            "reason":self.contentTextView.text
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
                    hud.mode = MBProgressHUDMode.Text
                    hud.labelText = status.errorData
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                if(status.status == "success"){
                    print("请假条发送成功")
                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.mode = MBProgressHUDMode.Text
                    hud.labelText = "请假条发送成功"
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                    self.view.endEditing(true)
                    let vc = LeaveViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
//    选择时间
    func selectTime(sender:UIButton){
        let btn:UIButton = sender
        self.pikerView = HZQDatePickerView.instanceDatePickerView()
        self.pikerView.frame = CGRectMake(0, 0, WIDTH, HEIGHT)
        self.pikerView.backgroundColor = UIColor.clearColor()
        self.pikerView.delegate = self
        if btn.tag == 99 {
            self.pikerView.type = DateTypeOfStart
        }
        else if btn.tag == 100{
           self.pikerView.type = DateTypeOfEnd
        }
        self.pikerView.datePickerView.minimumDate = NSDate()
        self.view.addSubview(self.pikerView)
    }
    func getSelectDate(date: String!, type: DateType) {
        if type == DateTypeOfStart{
            btn.setTitle(date, forState: .Normal)
            btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        }
        else if type == DateTypeOfEnd{
            btn1.setTitle(date, forState: .Normal)
            btn1.setTitleColor(UIColor.blackColor(), forState: .Normal)
        }
        
        
    }
    //    收键盘
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    //        键盘消失的通知方法
    func keyboardWillHideNotification(notification:NSNotification){
        UIView.animateWithDuration(0.3) { () -> Void in
            self.view.frame.origin.y = self.view.frame.origin.y + 100
            self.view.layoutIfNeeded()
        }
        
    }
    //     键盘出现的通知方法
    func keyboardWillShowNotification(notification:NSNotification){
        UIView.animateWithDuration(0.3) { () -> Void in
            self.view.frame.origin.y = self.view.frame.origin.y - 100
            self.view.layoutIfNeeded()
        }
    }
}
