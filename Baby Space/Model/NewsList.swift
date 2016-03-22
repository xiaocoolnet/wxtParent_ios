//
//  NewsList.swift
//  WXT_Parents
//  Created by 牛尧 on 16/3/5.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation
class NewsList: JSONJoy {
    var objectlist: [NewsInfo]
    var count: Int{
        return self.objectlist.count
    }
    
    init(){
        objectlist = Array<NewsInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<NewsInfo>()
        for useids: JSONDecoder in decoder.array!{
            objectlist.append(NewsInfo(useids))
        }
    }
    
    func append(list: [NewsInfo]){
        self.objectlist = list + self.objectlist
    }
}

class NewsInfo: JSONJoy{
    var receive_user_name:String?
    var message_content:String?
    var message_time:String?
    var send_user_id:String?
    init() {
        
    }
    required init(_ decoder: JSONDecoder){
        receive_user_name = decoder["receive_user_name"].string
        message_content = decoder["message_content"].string
        message_time = decoder["message_time"].string
        send_user_id = decoder["send_user_id"].string
    }
    
}

