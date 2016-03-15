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
    var notice_title:String?
    var notice_content:String?
    var releasename:String?
    var notice_time:String?
    
    init() {
        
    }
    required init(_ decoder: JSONDecoder){
        notice_title = decoder["notice_title"].string
        notice_content = decoder["notice_content"].string
        releasename = decoder["releasename"].string
        notice_time = decoder["notice_time"].string
    }
    
}

