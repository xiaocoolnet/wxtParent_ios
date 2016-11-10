//
//  MessageListModel.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/11/10.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation

class MessageListModel: JSONJoy{
    var status:String?
    var data: JSONDecoder?
    var array : Array<JSONDecoder>?
    var errorData:String?
    init(){
    }
    required init(_ decoder:JSONDecoder){
        
        status = decoder["status"].string
        if status == "success" {
            data = decoder["data"]
        }
        else{
            errorData = decoder["data"].string
        }
    }
}

class MessageList: JSONJoy {
    var status:String?
    var objectlist: [MessageListInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<MessageListInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<MessageListInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(MessageListInfo(childs))
        }
    }
    
    func append(list: [MessageListInfo]){
        self.objectlist = list + self.objectlist
    }
    
}

class MessageListInfo: JSONJoy{
    var uid:String
    var id:String
    var chat_uid:String
    var last_content:String
    var status:String
    var last_chat_id:String
    var send_type:String
    var receive_type:String
    var create_time:String
    var my_face:String
    var my_nickname:String
    var other_face:String
    var other_nickname:String
    
    required init(_ decoder: JSONDecoder){
        uid = decoder["uid"].string ?? ""
        id = decoder["id"].string ?? ""
        chat_uid = decoder["chat_uid"].string ?? ""
        last_content = decoder["last_content"].string ?? ""
        create_time = decoder["create_time"].string ?? ""
        
        status = decoder["status"].string ?? ""
        last_chat_id = decoder["last_chat_id"].string ?? ""
        send_type = decoder["send_type"].string ?? ""
        receive_type = decoder["receive_type"].string ?? ""
        
        my_face = decoder["my_face"].string ?? ""
        my_nickname = decoder["my_nickname"].string ?? ""
        other_face = decoder["other_face"].string ?? ""
        other_nickname = decoder["other_nickname"].string ?? ""
    }
    
}