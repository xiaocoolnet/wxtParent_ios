//
//  NoticeList.swift
//  WXT_Parents
//
//  Created by Mac on 16/3/13.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//


import Foundation
class NoticeList: JSONJoy {
    //  初始化一个元组（相当于一个数据源）
    var objectlist: [NoticeInfo]
    var count: Int{
        
        return self.objectlist.count
    }
    //  看不懂
    init(){
        objectlist = Array<NoticeInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        //  看不懂
        objectlist = Array<NoticeInfo>()
        for useids: JSONDecoder in decoder.array!{
            objectlist.append(NoticeInfo(useids))
        }
    }
    //  看不懂
    func append(list: [NoticeInfo]){
        self.objectlist = list + self.objectlist
    }
}
//  定义要得到的东西（数组类型）
class NoticeInfo: JSONJoy{
    var avatar:String?
    var allreader:Int?
    var content:String?
    var create_time:String?
    var id:String?
    var photo:String?
    var readcount = Int()
    var title:String?
    var type:String?
    var readtag:Int?
    var userid:String?
    var username:String?
    //  绝对是数组
    var dianzanlist:JSONDecoder?
    var comment:JSONDecoder?
    init() {
        
    }
    //  解析赋值操作
    required init(_ decoder: JSONDecoder){
        avatar = decoder["avatar"].string
        allreader = decoder["allreader"].integer
        content = decoder["content"].string
        create_time = decoder["create_time"].string
        id = decoder["id"].string
        photo = decoder["photo"].string
        readcount = decoder["readcount"].integer!
        title = decoder["title"].string
        type = decoder["type"].string
        readtag = decoder["readtag"].integer
        userid = decoder["userid"].string
        username = decoder["username"].string
        dianzanlist = decoder["like"]
        comment = decoder["comment"]
    }
    
}

