//
//  QCSecondMessagesModel.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/21.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation

class sendMessagesList: JSONJoy {
    var homeworkList: [sendMessagesInfo]
    var count: Int{
        return self.homeworkList.count
    }
    
    init(){
        homeworkList = Array<sendMessagesInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        homeworkList = Array<sendMessagesInfo>()
        for childs: JSONDecoder in decoder.array!{
            homeworkList.append(sendMessagesInfo(childs))
        }
    }
    
    func append(list: [sendMessagesInfo]){
        self.homeworkList = list + self.homeworkList
    }
}

class sendMessagesInfo: JSONJoy{
    var id:String?
    var message_content:String?
    var message_time:String?
    var schoolid:String?
    var send_user_id:String?
    var send_user_name:String?
    

    
    
    init() {
        
    }
    required init(_ decoder: JSONDecoder){
        
        
        id = decoder["id"].string
        message_content = decoder["message_content"].string
        message_time = decoder["message_time"].string
        schoolid = decoder["schoolid"].string
        send_user_id = decoder["send_user_id"].string
        send_user_name = decoder["send_user_name"].string
        

        
    }
    
}