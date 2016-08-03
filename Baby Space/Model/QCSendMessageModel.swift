//
//  File.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/21.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation

class sendMessageList: JSONJoy {
    var homeworkList: [sendMessageInfo]
    var count: Int{
        return self.homeworkList.count
    }
    
    init(){
        homeworkList = Array<sendMessageInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        homeworkList = Array<sendMessageInfo>()
        for childs: JSONDecoder in decoder.array!{
            homeworkList.append(sendMessageInfo(childs))
        }
    }
    
    func append(list: [sendMessageInfo]){
        self.homeworkList = list + self.homeworkList
    }
}

class sendMessageInfo: JSONJoy{
    var id:String?
    var message_id:String?
    var message_type:String?
    var read_time:String?
    var receiver_user_id:String?
    var receiver_user_name:String?
    
    var picture:JSONDecoder?
    var send_message:JSONDecoder?
    
    var send_num:Int?

    
    
    init() {
        
    }
    required init(_ decoder: JSONDecoder){

        
        id = decoder["id"].string
        message_id = decoder["message_id"].string
        message_type = decoder["message_type"].string
        receiver_user_id = decoder["receiver_user_id"].string
        read_time = decoder["read_time"].string
        receiver_user_name = decoder["receiver_user_name"].string
        
        picture = decoder["picture"]
        send_message = decoder["send_message"]
        
        send_num = decoder["send_num"].integer
        
    }
    
}