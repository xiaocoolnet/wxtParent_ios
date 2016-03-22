//
//  SendList.swift
//  WXT_Parents
//
//  Created by 牛尧 on 16/3/14.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation
class SendList: JSONJoy {
    var objectlist: [SendInfo]
    var count: Int{
        return self.objectlist.count
    }
    
    init(){
        objectlist = Array<SendInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<SendInfo>()
        for useids: JSONDecoder in decoder.array!{
            objectlist.append(SendInfo(useids))
        }
    }
    
    func append(list: [SendInfo]){
        self.objectlist = list + self.objectlist
    }
}

class SendInfo: JSONJoy{
    var send_user_name:String?
    var message_content:String?
    var message_time:String?
    init() {
        
    }
    required init(_ decoder: JSONDecoder){
        send_user_name = decoder["send_user_name"].string
        message_content = decoder["message_content"].string
        message_time = decoder["message_time"].string
  
    }
    
}

