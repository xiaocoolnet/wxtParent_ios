//
//  ParentsExhortList.swift
//  WXT_Parents
//
//  Created by zhang on 16/4/29.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation

class ParentsExhortModel: JSONJoy{
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

class ParentsExhortList: JSONJoy {
    var status:String?
    var objectlist: [ExhortInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<ExhortInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<ExhortInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(ExhortInfo(childs))
        }
    }
    
    func append(list: [ExhortInfo]){
        self.objectlist = list + self.objectlist
    }
    
}

class ExhortInfo: JSONJoy{
    var content:String?
    var create_time:String?
    var studentid:String?
    var id:String?
    var teacherid:String?
    var userid:String?
    var studentname:String?
    var teachername:String?
    var username:String?
    var feed_time:String?
    var feedback:String?
    var studentavatar:String?
    var teacheravatar:String?
    var comment = Array<ExhortCommentInfo>()
    var pic = Array<ExhortPicInfo>()
    
    init() {
        
    }
    required init(_ decoder: JSONDecoder){
        studentid = decoder["studentid"].string
        content = decoder["content"].string
        create_time = decoder["create_time"].string
        id = decoder["id"].string
        teacherid = decoder["teacherid"].string
        userid = decoder["userid"].string
        studentname = decoder["studentname"].string
        teachername = decoder["teachername"].string
        username = decoder["username"].string
        feed_time = decoder["feed_time"].string
        feedback = decoder["feedback"].string
        studentavatar = decoder["studentavatar"].string
        teacheravatar = decoder["teacheravatar"].string

        if decoder["pic"].array != nil {
            for childs: JSONDecoder in decoder["pic"].array!{
                self.pic.append(ExhortPicInfo(childs))
            }
        }
        if decoder["comment"].array != nil {
            for childs: JSONDecoder in decoder["comment"].array!{
                self.comment.append(ExhortCommentInfo(childs))
            }
        }
    }
    func addpend(list: [ExhortPicInfo]){
        self.pic = list + self.pic
    }
    func addpend(list: [ExhortCommentInfo]){
        self.comment = list + self.comment
    }
}

class ExhortCommentList: JSONJoy {
    var status:String?
    var objectlist: [ExhortCommentInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<ExhortCommentInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<ExhortCommentInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(ExhortCommentInfo(childs))
        }
    }
    
    func append(list: [ExhortCommentInfo]){
        self.objectlist = list + self.objectlist
    }
}

class ExhortCommentInfo: JSONJoy {
    
    var userid:String?
    var avatar:String?
    var name:String?
    var content:String?
    var photo:String?
    var comment_time:String?
    
    
    init() {
        
    }
    required init(_ decoder: JSONDecoder){
        userid = decoder["userid"].string
        avatar = decoder["avatar"].string
        name = decoder["name"].string
        content = decoder["content"].string
        photo = decoder["photo"].string
        comment_time = decoder["comment_time"].string
        
    }
    
}


class ExhortPicList: JSONJoy {
    var status:String?
    var objectlist: [ExhortPicInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<ExhortPicInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<ExhortPicInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(ExhortPicInfo(childs))
        }
    }
    
    func append(list: [ExhortPicInfo]){
        self.objectlist = list + self.objectlist
    }
}

class ExhortPicInfo: JSONJoy {
    
    var picture_url:String?
    init() {
        
    }
    required init(_ decoder: JSONDecoder){
        picture_url = decoder["picture_url"].string
        
    }
    
}




