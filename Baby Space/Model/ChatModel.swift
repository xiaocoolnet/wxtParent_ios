//
//  ChatModel.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/11/10.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation


class chatModel: JSONJoy {
    var status:String?
    var data: JSONDecoder?
    var datas = Array<chatInfo>()
    var errorData:String?
    init(){
    }
    required init(_ decoder:JSONDecoder){
        
        status = decoder["status"].string
        if status == "success" {
            for childs: JSONDecoder in decoder["data"].array!{
                print(childs)
                datas.append(chatInfo(childs))
                print(datas)
                //                    array.append(SkillModel(childs))
            }
        }else{
            errorData = decoder["data"].string
        }
        
    }
    
}
class chatList: JSONJoy {
    var status:String?
    var objectlist: [chatInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<chatInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<chatInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(chatInfo(childs))
        }
    }
    
    func append(list: [chatInfo]){
        self.objectlist = list + self.objectlist
    }
    
}

class chatInfo: JSONJoy {
    
    var id:String?
    var send_uid:String?
    var receive_uid:String?
    var content:String?
    var status:String?
    var create_time:String?
    var send_face:String?
    var send_nickname:String?
    var receive_face:String?
    var receive_nickname:String?
    
    init(){
        
    }
    
    required init(_ decoder: JSONDecoder){
        
        id = decoder["id"].string
        send_uid = decoder["send_uid"].string
        receive_uid = decoder["receive_uid"].string
        content = decoder["content"].string
        status = decoder["status"].string
        create_time = decoder["create_time"].string
        send_face = decoder["send_face"].string
        send_nickname = decoder["send_nickname"].string
        receive_face = decoder["receive_face"].string
        receive_nickname = decoder["receive_nickname"].string
        
        
    }
    
}