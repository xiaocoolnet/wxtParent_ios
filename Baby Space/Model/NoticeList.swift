//
//  NoticeList.swift
//  WXT_Parents
//
//  Created by Mac on 16/3/13.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//


import Foundation
class NoticeList: JSONJoy {
    var objectlist: [NoticeInfo]
    var count: Int{
        return self.objectlist.count
    }
    
    init(){
        objectlist = Array<NoticeInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<NoticeInfo>()
        for useids: JSONDecoder in decoder.array!{
            objectlist.append(NoticeInfo(useids))
        }
    }
    
    func append(list: [NoticeInfo]){
        self.objectlist = list + self.objectlist
    }
}

class NoticeInfo: JSONJoy{
    var allreader:Int?
    var content:String?
    var create_time:String?
    var id:String?
    var photo:String?
    var readcount:Int?
    var title:String?
    var type:String?
    var readtag:Int?
    var userid:String?
    var username:String?
    init() {
        
    }
    required init(_ decoder: JSONDecoder){
        allreader = decoder["allreader"].integer
        content = decoder["content"].string
        create_time = decoder["create_time"].string
        id = decoder["id"].string
        photo = decoder["photo"].string
        readcount = decoder["readcount"].integer
        title = decoder["title"].string
        type = decoder["type"].string
        readtag = decoder["readtag"].integer
        userid = decoder["userid"].string
        username = decoder["username"].string
    }
    
}

