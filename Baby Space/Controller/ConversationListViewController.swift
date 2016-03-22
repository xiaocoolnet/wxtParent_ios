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

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tabBarController?.tabBar.hidden = true
        self.title = "聊天列表"
        
        self.showRefreshHeader = true
        self.delegate = self
        self.dataSource = self
        
        self.tableViewDidTriggerHeaderRefresh()
        self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
//        网络出现故障时
        self.NetworkStateView()

    }
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
//    最后一条的时间
    func conversationListViewController(conversationListViewController: EaseConversationListViewController!, latestMessageTimeForConversationModel conversationModel: IConversationModel!) -> String! {
        var latestMessageTime = ""
        let lastMessage:EMMessage = conversationModel.conversation.latestMessage()
        if lastMessage != "" {
           latestMessageTime = NSDate.formattedTimeFromTimeInterval(lastMessage.timestamp)
        }
        return latestMessageTime
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
