//
//  ChatViewController.swift
//  Demo
//
//  Created by zhang on 16/3/29.
//  Copyright © 2016年 xiaocool. All rights reserved.
//

import UIKit

class ChatViewController: EaseMessageViewController, EaseMessageViewControllerDelegate, EaseMessageViewControllerDataSource{

    var _copyMenuItem = UIMenuItem()
    var _deleteMenuItem = UIMenuItem()
    var _transpondMenuItem = UIMenuItem()
    let isPlayingAudio = Bool()
    let emotionDic = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showRefreshHeader = true
        self.delegate = self
        self.dataSource = self
//        发送信息背景图
        EaseBaseMessageCell.appearance().sendBubbleBackgroundImage = UIImage(named: "chat_sender_bg")!.stretchableImageWithLeftCapWidth(5, topCapHeight: 35)
//        收到信息背景图
        EaseBaseMessageCell.appearance().recvBubbleBackgroundImage = UIImage(named: "chat_receiver_bg")!.stretchableImageWithLeftCapWidth(35, topCapHeight: 35)
//        发送语音背景图
        EaseBaseMessageCell.appearance().sendMessageVoiceAnimationImages = [(UIImage)(named: "chat_sender_audio_playing_full")!,(UIImage)(named: "chat_sender_audio_playing_000")!,(UIImage)(named: "chat_sender_audio_playing_001")!,(UIImage)(named: "chat_sender_audio_playing_002")!,(UIImage)(named: "chat_sender_audio_playing_003")!]
//       收到语音背景图
        EaseBaseMessageCell.appearance().recvMessageVoiceAnimationImages = [(UIImage)(named: "chat_receiver_audio_playing_full")!,(UIImage)(named: "chat_receiver_audio_playing000")!,(UIImage)(named: "chat_receiver_audio_playing001")!,(UIImage)(named: "chat_receiver_audio_playing002")!,(UIImage)(named: "chat_receiver_audio_playing003")!]
//        头像设置
        EaseBaseMessageCell.appearance().avatarSize = 40
        EaseBaseMessageCell.appearance().avatarCornerRadius = 20
//        每条信息的背景色，有背景图的时候不显示
        EaseBaseMessageCell.appearance().backgroundColor = UIColor(red: 240 / 255.0, green: 242 / 255.0, blue: 247 / 255.0, alpha: 1)
//      设置返回按钮
       self._setupBarButtonItem()
        
//        删除聊天记录
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatViewController.deleteAllMessages(_:)), name: "RemoveAllMessages", object: nil)
//        插入聊天记录
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatViewController.insertCallMessage(_:)), name: "insertCallMessage", object: nil)
        
    //通过会话管理者获取已收发消息
        self.tableViewDidTriggerHeaderRefresh()
    }
//    返回按钮
    func _setupBarButtonItem(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back.png"), style: .Plain
            , target: self, action: #selector(ChatViewController.backAction))
//      单聊
        if(self.conversation.conversationType == EMConversationType.eConversationTypeChat){
            let clearButton = UIButton()
            clearButton.frame = CGRectMake(0, 0, 30, 30)
            clearButton.setImage((UIImage(named: "delete.png")), forState: .Normal)
            clearButton.addTarget(self, action: #selector(ChatViewController.deleteAllMessages(_:)), forControlEvents: .TouchUpInside)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: clearButton)
            
        }
    }
//    按着消息长按
    func messageViewController(viewController: EaseMessageViewController!, canLongPressRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
//    表情
    func emotionFormessageViewController(viewController: EaseMessageViewController!) -> [AnyObject]! {
        let emotions = NSMutableArray()
        for name in EaseEmoji.allEmoji(){
            let  emotion = EaseEmotion(name: "", emotionId: name as! String, emotionThumbnail: name as! String, emotionOriginal: name as! String, emotionOriginalURL: "", emotionType:EMEmotionType.Default)
            emotions.addObject(emotion)
        }
        let temp:EaseEmotion = emotions.objectAtIndex(0) as! EaseEmotion
        let managerDefault = EaseEmotionManager(type: .Default, emotionRow: 3, emotionCol: 7, emotions: emotions as [AnyObject], tagImage: UIImage(named: temp.emotionId))
        let emotionGifs = NSMutableArray()
        let names:[String] = ["icon_002","icon_007","icon_010","icon_012","icon_013","icon_018","icon_019","icon_020","icon_021","icon_022","icon_024","icon_027","icon_029","icon_030","icon_035","icon_040"]
        
        var index = 0
        for name in names {
            index += 1
            let emotion = EaseEmotion(name: "示例\(String(index))", emotionId: "em\(String(1000+index))", emotionThumbnail: "\(name)_cover", emotionOriginal: name, emotionOriginalURL: "", emotionType: .Gif)
            emotionGifs.addObject(emotion)
            emotionDic.setObject(emotion, forKey: "em\(String(1000+index))")
        }
        let managerGif = EaseEmotionManager(type: .Gif, emotionRow: 2, emotionCol: 4, emotions: emotionGifs as [AnyObject], tagImage: UIImage(named: "icon_002_cover"))
        return [managerDefault,managerGif]
    }
//    表情
    func isEmotionMessageFormessageViewController(viewController: EaseMessageViewController!, messageModel: IMessageModel!) -> Bool {
        let flag:Bool = false
        return flag
    }
//   表情
    func emotionURLFormessageViewController(viewController: EaseMessageViewController!, messageModel: IMessageModel!) -> EaseEmotion! {
        let emotionId:String = messageModel.message.ext["em_expression_id"] as! String
        var emotion:EaseEmotion = emotionDic.objectForKey(emotionId) as! EaseEmotion
        if (emotion.isEqual(nil)) {
            emotion = EaseEmotion(name: "", emotionId: "", emotionThumbnail: "", emotionOriginal: "", emotionOriginalURL: "", emotionType: .Gif)
        }
        return emotion
    }
//    表情
    func emotionExtFormessageViewController(viewController: EaseMessageViewController!, easeEmotion: EaseEmotion!) -> [NSObject : AnyObject]! {
        return ["em_expression_id":easeEmotion.emotionId,"em_is_big_expression":(true)]
    }
//    返回事件
    func backAction(){
        self.navigationController?.popViewControllerAnimated(true)
    }
//    删除全部聊天记录
    func deleteAllMessages(sender:AnyObject){
        if self.dataArray.count == 0 {
            self.showHint(NSLocalizedString("没有聊天记录", comment: "no messages"))
            return
        }
        if sender.isKindOfClass(NSNotification) {
            let groupId:String = sender.object as! String
            var isDelete = Bool()
            if groupId == self.conversation.chatter {
                isDelete = true
            }else{
                isDelete = false
            }
            
            if self.conversation.conversationType != EMConversationType.eConversationTypeChat && isDelete {
                  self.messageTimeIntervalTag = -1
                self.conversation.removeAllMessages()
                self.messsagesSource.removeAllObjects()
                self.dataArray.removeAllObjects()
                
                self.tableView.reloadData()
                self.showHint(NSLocalizedString("没有聊天记录", comment: "no messages"))
            }
            
        }else if sender.isKindOfClass(UIButton) {
             let alertView = UIAlertController(title: NSLocalizedString("提示",  comment:"提示"), message: NSLocalizedString("确定删除全部聊天记录？",  comment:"please make sure to delete"), preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: NSLocalizedString("取消", comment:"取消"), style: .Default, handler: nil))

            alertView.addAction(UIAlertAction(title: NSLocalizedString("确定", comment:"确定"), style: .Default, handler: { (UIAlertAction) -> Void in
                self.messageCountOfPage = -1
                self.conversation.removeAllMessages()
                self.dataArray.removeAllObjects()
                self.messsagesSource .removeAllObjects()
                self.tableView.reloadData()
            }))
            self.presentViewController(alertView, animated: true, completion: nil)

        }
    }
//    获取所有聊天记录
    func insertCallMessage(notification:NSNotification){
        let object:AnyObject = notification.object!
        if object.isEqual(nil) {
            let message = EMMessage(coder: object as! NSCoder)
            self.addMessageToDataSource(message, progress: nil)
            EaseMob.sharedInstance().chatManager.importDataToNewDatabase()
        }
    }

}
