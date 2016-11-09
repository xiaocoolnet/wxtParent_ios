//
//  ConversationListViewController.swift
//  Demo
//
//  Created by zhang on 16/4/28.
//  Copyright © 2016年 xiaocool. All rights reserved.
//

import UIKit

class ConversationListViewController: EaseConversationListViewController,EaseConversationListViewControllerDelegate, EaseConversationListViewControllerDataSource{

    let conversationsArray = NSMutableArray()
    let networkStateView = UIView()
    var lable = UILabel()
    var homework = UILabel()
    

    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
        self.tabBarController?.tabBar.hidden = false
        refreshDataSource()
        let chid = NSUserDefaults.standardUserDefaults()
        
        if chid.valueForKey("homeworkArr") != nil {
            
            let arr = chid.valueForKey("homeworkArr") as! NSArray
            homework.text = String(arr.count)
        }else{
            homework.removeFromSuperview()
        }
        if homework.text == "0" {
            homework.removeFromSuperview()
        }
        if chid.valueForKey("messageArr") != nil {
            
            let arr = chid.valueForKey("messageArr") as! NSArray
            lable.text = String(arr.count)
        }else{
            lable.removeFromSuperview()
        }
        if lable.text == "0" {
            lable.removeFromSuperview()
        }
       
    }
    
    func game(count:NSNotification){
//        let arr = count.object as! NSArray
        lable.text = String((count.object as! NSArray).count)
        print("lable =", count.object as? String)
    }
    func daijie(count:NSNotification){
//        let arr = count.object as! NSArray
        homework.text = String((count.object as! NSArray).count)
        print("lable =", count.object as? String)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.daijie(_:)), name: "homeworkArr", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.game(_:)), name: "messageArr", object: nil)
        
        self.title = "聊天列表"
        self.showRefreshHeader = true
        self.delegate = self
        self.dataSource = self
        
        self.tableViewDidTriggerHeaderRefresh()
        self.createUI()
        //  改变了tableView 的高度
        self.tableView.frame = CGRectMake(0, 281, WIDTH, HEIGHT-281 + 64)
//        网络出现故障时
        self.NetworkStateView()

    }
//    创建界面
    func createUI(){
        let v = UIView(frame:CGRectMake(0,0,self.view.frame.size.width,281))
        v.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(v)
        
        let imageView1 = UIImageView(frame:CGRectMake(10,10,50,50))
        imageView1.layer.cornerRadius = 25
        imageView1.image = UIImage(named: "最新消息")
//        v.addSubview(imageView1)
        
        let lbl1 = UILabel(frame:CGRectMake(70,10,100,20))
        lbl1.text = "系统消息"
//        v.addSubview(lbl1)
        
        let lbl11 = UILabel(frame:CGRectMake(70,40,100,20))
        lbl11.text = "最新系统消息"
        lbl11.font = UIFont.systemFontOfSize(14)
        lbl11.textColor = UIColor.lightGrayColor()

        
        let lineview = UIView(frame:CGRectMake(0,70,self.view.frame.size.width,1))
        lineview.backgroundColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1)
//        v.addSubview(lineview)
        
        let imageView2 = UIImageView(frame:CGRectMake(10,10,50,50))
        imageView2.layer.cornerRadius = 25
        imageView2.image = UIImage(named: "最新消息")
        v.addSubview(imageView2)
        
        let lbl2 = UILabel(frame:CGRectMake(70,10,100,20))
        lbl2.text = "群发消息"
        v.addSubview(lbl2)
        let user = NSUserDefaults.standardUserDefaults()
        
        let lbl21 = UILabel(frame:CGRectMake(70,40,100,20))
        let qunfa = user.valueForKey("qunfa") as? String
        if qunfa=="" || qunfa==nil {
            lbl21.text = "暂无消息"
        }else{
        lbl21.text = qunfa
        }
        lbl21.font = UIFont.systemFontOfSize(14)
        lbl21.textColor = UIColor.lightGrayColor()
        v.addSubview(lbl21)
        
        let lineview1 = UIView(frame:CGRectMake(0,70,self.view.frame.size.width,1))
        lineview1.backgroundColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1)
        v.addSubview(lineview1)
        
        let imageView3 = UIImageView(frame:CGRectMake(10,80,50,50))
        imageView3.layer.cornerRadius = 25
        imageView3.image = UIImage(named: "ic_wodezuoye.png")
        v.addSubview(imageView3)
        
        
        lable.frame = CGRectMake(38, 0, 18, 18)
        lable.backgroundColor = UIColor.redColor()
        lable.textColor = UIColor.whiteColor()
        lable.layer.cornerRadius = 9
        lable.layer.masksToBounds = true
        lable.font = UIFont.systemFontOfSize(12)
        lable.textAlignment = NSTextAlignment.Center
        imageView2.addSubview(lable)
        
    
        homework.frame = CGRectMake(38, 0, 18, 18)
        homework.backgroundColor = UIColor.redColor()
        homework.textColor = UIColor.whiteColor()
        homework.layer.cornerRadius = 9
        homework.layer.masksToBounds = true
        homework.font = UIFont.systemFontOfSize(12)
        homework.textAlignment = NSTextAlignment.Center
        imageView3.addSubview(homework)
        
        let lbl3 = UILabel(frame:CGRectMake(70,80,100,20))
        lbl3.text = "我的作业"
        let zuoye = user.valueForKey("zuoye") as? String
        
        v.addSubview(lbl3)
        
        let lbl31 = UILabel(frame:CGRectMake(70,110,100,20))
        if zuoye=="" || zuoye==nil {
            lbl31.text = "暂无消息"
        }else{
        lbl31.text = zuoye
        }
        lbl31.font = UIFont.systemFontOfSize(14)
        lbl31.textColor = UIColor.lightGrayColor()
        v.addSubview(lbl31)
        
        let lineview2 = UIView(frame:CGRectMake(0,140,self.view.frame.size.width,1))
        lineview2.backgroundColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1)
        v.addSubview(lineview2)
        
        let imageView4 = UIImageView(frame:CGRectMake(10,150,50,50))
        imageView4.layer.cornerRadius = 25
        imageView4.image = UIImage(named: "Logo")
        v.addSubview(imageView4)
        
        let lbl4 = UILabel(frame:CGRectMake(70,150,100,20))
        lbl4.text = "通讯录"
        v.addSubview(lbl4)
        
        let lbl41 = UILabel(frame:CGRectMake(70,180,100,20))
        lbl41.text = "老师通讯录"
        lbl41.font = UIFont.systemFontOfSize(14)
        lbl41.textColor = UIColor.lightGrayColor()
        v.addSubview(lbl41)
        
        let lineview3 = UIView(frame:CGRectMake(0,210,self.view.frame.size.width,1))
        lineview3.backgroundColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1)
        v.addSubview(lineview3)
        
        let btn = UIButton(frame: CGRectMake(0,0,WIDTH,70))
        btn.backgroundColor = UIColor.clearColor()
//        btn.addTarget(self, action: #selector(ConversationListViewController.systemNewsBtn), forControlEvents: .TouchUpInside)
//        v.addSubview(btn)
        
        let btn1 = UIButton(frame: CGRectMake(0,0,WIDTH,70))
        btn1.backgroundColor = UIColor.clearColor()
        btn1.addTarget(self, action: #selector(ConversationListViewController.groupNewsBtn), forControlEvents: .TouchUpInside)
        v.addSubview(btn1)
        
        let btn2 = UIButton(frame: CGRectMake(0,70,WIDTH,70))
        btn2.backgroundColor = UIColor.clearColor()
        btn2.addTarget(self, action: #selector(ConversationListViewController.homeworkBtn), forControlEvents: .TouchUpInside)
        v.addSubview(btn2)
        
        let btn3 = UIButton(frame: CGRectMake(0,140,WIDTH,70))
        btn3.backgroundColor = UIColor.clearColor()
        btn3.addTarget(self, action: #selector(ConversationListViewController.addressBtn), forControlEvents: .TouchUpInside)
        v.addSubview(btn3)
        

    }
//    我的作业
    func homeworkBtn(){
//        let vc = HomeworkViewController()
        let vc = TabViewController()
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
//    通讯录
    func addressBtn(){
        let vc = AddressViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
//    系统消息
//    func systemNewsBtn(){
//        let vc = SystemNewsViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//    群发消息
    func groupNewsBtn(){
//        let vc = GroupNewsViewController()
        let vc = FSendNewsViewController()
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
//    网络判断
    func NetworkStateView()->UIView{
        if self.networkStateView.isKindOfClass(NSNull) {
           self.networkStateView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 44)
            self.networkStateView.backgroundColor = UIColor(red: 255 / 255.0, green: 199 / 255.0, blue: 199 / 255.0, alpha: 0.5)
            
            let imageView = UIImageView(frame: CGRectMake(10, (self.networkStateView.frame.size.height - 20) / 2, 20, 20))
            imageView.image = UIImage(named: "messageSendFail.png")
            self.networkStateView.addSubview(imageView)
            
            let label = UILabel(frame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 0, self.networkStateView.frame.size.width - (CGRectGetMaxX(imageView.frame) + 15), self.networkStateView.frame.size.height))
            label.font = UIFont.systemFontOfSize(15.0)
            label.textColor = UIColor.grayColor()
            label.backgroundColor = UIColor.clearColor()
            label.text = NSLocalizedString("网络连接中", comment: "网络未连接")
            self.networkStateView.addSubview(label)
        }
        return self.networkStateView
    }
    
//    Delegate方法
    func conversationListViewController(conversationListViewController: EaseConversationListViewController!, didSelectConversationModel conversationModel: IConversationModel!) {
        
        if conversationModel != nil {
            let conversation:EMConversation = conversationModel.conversation
            let chatView = ChatViewController(conversationChatter: conversation.chatter, conversationType: EMConversationType.eConversationTypeChat)
            chatView.title = conversationModel.title
            self.navigationController?.pushViewController(chatView, animated: true)
        }
    }
//    DataSource方法
    func conversationListViewController(conversationListViewController: EaseConversationListViewController!, modelForConversation conversation: EMConversation!) -> IConversationModel! {
        let model = EaseConversationModel(conversation: conversation)
        return model
    }
    
    func refreshDataSource(){
       self.tableViewDidTriggerHeaderRefresh()
    }
    func isConnect(isConnect:Bool){
        if !isConnect{
            self.tableView.tableHeaderView = self.networkStateView
        }else{
            self.tableView.tableHeaderView = nil
        }
    }
    
}
