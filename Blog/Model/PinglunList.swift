//
//  PinglunList.swift
//  WXT_Parents
//
//  Created by zhang on 16/5/13.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation
class PingLunList: JSONJoy {
    var pinglunlist: [PingLunInfo]
    var count: Int{
        return self.pinglunlist.count
    }
    
    init(){
        pinglunlist = Array<PingLunInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        //        status = decoder["status"].string
        pinglunlist = Array<PingLunInfo>()
        for childs: JSONDecoder in decoder.array!{
            pinglunlist.append(PingLunInfo(childs))
        }
    }
    
    func append(list: [PingLunInfo]){
        self.pinglunlist = list + self.pinglunlist
    }
}
class PingLunInfo: JSONJoy{
    var avatar:String?
    var content:String?
    var userid:String?
    var name:String?
    var comment_time:String?
    var photo:String?
    
    init() {
        
    }
    required init(_ decoder: JSONDecoder){
        avatar = decoder["avatar"].string
        content = decoder["content"].string
        userid = decoder["userid"].string
        name = decoder["name"].string
        comment_time = decoder["comment_time"].string
        photo = decoder["photo"].string
    }
    
}