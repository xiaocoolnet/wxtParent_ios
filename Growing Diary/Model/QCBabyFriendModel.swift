//
//  QCBabyFriendModel.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/8/8.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation

class QCBabyFriendModel: JSONJoy{
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

class QCBabyFriendList: JSONJoy {
    var status:String?
    var objectlist: [QCBabyFriendInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<QCBabyFriendInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<QCBabyFriendInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(QCBabyFriendInfo(childs))
        }
    }
    
    func append(list: [QCBabyFriendInfo]){
        self.objectlist = list + self.objectlist
    }
    
}

class QCBabyFriendInfo: JSONJoy{
    var friendid:String
    var name:String
    var photo:String
    var phone:String
    var microblog_info = Array<QCmicroblog_infoInfo>()
    
    required init(_ decoder: JSONDecoder){
        friendid = decoder["friendid"].string ?? ""
        name = decoder["name"].string ?? ""
        photo = decoder["photo"].string ?? ""
        phone = decoder["phone"].string ?? ""

        if decoder["microblog_info"].array != nil {
            for childs: JSONDecoder in decoder["microblog_info"].array!{
                self.microblog_info.append(QCmicroblog_infoInfo(childs))
            }
        }
    
    }
    func addpend(list: [QCmicroblog_infoInfo]){
        self.microblog_info = list + self.microblog_info
    }
    
}

class QCmicroblog_infoList: JSONJoy {
    var status:String?
    var objectlist: [QCmicroblog_infoInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<QCmicroblog_infoInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<QCmicroblog_infoInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(QCmicroblog_infoInfo(childs))
        }
    }
    
    func append(list: [QCmicroblog_infoInfo]){
        self.objectlist = list + self.objectlist
    }
}

class QCmicroblog_infoInfo: JSONJoy {
    var mid:String
    var type:String
    var schoolid:String
    var classid:String
    var userid:String
    var name:String
    var content:String
    var write_time:String
    var photo:String
    var status:String
    var pic = Array<BabyFriendPicInfo>()
    var like = Array<BabyFriendLikeInfo>()
    var comment = Array<BabyFriendCommentInfo>()

required init(_ decoder: JSONDecoder){
    mid = decoder["mid"].string ?? ""
    type = decoder["type"].string ?? ""
    schoolid = decoder["schoolid"].string ?? ""
    classid = decoder["classid"].string ?? ""
    userid = decoder["userid"].string ?? ""
    name = decoder["name"].string ?? ""
    content = decoder["content"].string ?? ""
    write_time = decoder["write_time"].string ?? ""
    photo = decoder["photo"].string ?? ""
    status = decoder["status"].string ?? ""
    if decoder["pic"].array != nil {
        for childs: JSONDecoder in decoder["pic"].array!{
            self.pic.append(BabyFriendPicInfo(childs))
        }
    }
    if decoder["like"].array != nil {
        for childs: JSONDecoder in decoder["like"].array!{
            self.like.append(BabyFriendLikeInfo(childs))
        }
    }
    if decoder["comment"].array != nil {
        for childs: JSONDecoder in decoder["comment"].array!{
            self.comment.append(BabyFriendCommentInfo(childs))
        }
    }
}
func addpend(list: [BabyFriendPicInfo]){
    self.pic = list + self.pic
}
func addpend(list: [BabyFriendLikeInfo]){
    self.like = list + self.like
}
func addpend(list: [BabyFriendCommentInfo]){
    self.comment = list + self.comment
}

}

class BabyFriendPicList: JSONJoy {
    var status:String?
    var objectlist: [BabyFriendPicInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<BabyFriendPicInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<BabyFriendPicInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(BabyFriendPicInfo(childs))
        }
    }
    
    func append(list: [BabyFriendPicInfo]){
        self.objectlist = list + self.objectlist
    }
}

class BabyFriendPicInfo: JSONJoy {
    
    var pictureurl:String
//    init() {
//        
//    }
    required init(_ decoder: JSONDecoder){
        pictureurl = decoder["pictureurl"].string ?? ""
        
    }
    
}


class BabyFriendLikeList: JSONJoy {
    var status:String?
    var objectlist: [BabyFriendLikeInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<BabyFriendLikeInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<BabyFriendLikeInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(BabyFriendLikeInfo(childs))
        }
    }
    
    func append(list: [BabyFriendLikeInfo]){
        self.objectlist = list + self.objectlist
    }
}

class BabyFriendLikeInfo: JSONJoy {
    
    var userid:String
    var name:String
    var avatar:String
    required init(_ decoder: JSONDecoder){
        name = decoder["name"].string ?? ""
        userid = decoder["userid"].string ?? ""
        avatar = decoder["avatar"].string ?? ""
    }
    
}

class BabyFriendCommentList: JSONJoy {
    var status:String?
    var objectlist: [BabyFriendCommentInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<BabyFriendCommentInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<BabyFriendCommentInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(BabyFriendCommentInfo(childs))
        }
    }
    
    func append(list: [BabyFriendCommentInfo]){
        self.objectlist = list + self.objectlist
    }
}

class BabyFriendCommentInfo: JSONJoy {
    
    var userid:String
    var name:String
    var content:String
    var avatar:String
    var comment_time:String
    var photo:String
    required init(_ decoder: JSONDecoder){
        name = decoder["name"].string ?? ""
        userid = decoder["userid"].string ?? ""
        content = decoder["content"].string ?? ""
        avatar = decoder["avatar"].string ?? ""
        comment_time = decoder["comment_time"].string ?? ""
        photo = decoder["photo"].string ?? ""
    }
    
}

