//
//  BabyPhotoModel.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/29.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation

class BabyPhotoModel: JSONJoy{
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

class BabyPhotoList: JSONJoy {
    var status:String?
    var objectlist: [BabyPhotoInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<BabyPhotoInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<BabyPhotoInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(BabyPhotoInfo(childs))
        }
    }
    
    func append(list: [BabyPhotoInfo]){
        self.objectlist = list + self.objectlist
    }
    
}

class BabyPhotoInfo: JSONJoy{
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
    var pic = Array<BabyPicInfo>()
    var like = Array<BabyLikeInfo>()
    var comment = Array<BabyCommentInfo>()
    
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
                self.pic.append(BabyPicInfo(childs))
            }
        }
        if decoder["like"].array != nil {
            for childs: JSONDecoder in decoder["like"].array!{
                self.like.append(BabyLikeInfo(childs))
            }
        }
        if decoder["comment"].array != nil {
            for childs: JSONDecoder in decoder["comment"].array!{
                self.comment.append(BabyCommentInfo(childs))
            }
        }
    }
    func addpend(list: [BabyPicInfo]){
        self.pic = list + self.pic
    }
    func addpend(list: [BabyLikeInfo]){
        self.like = list + self.like
    }
    func addpend(list: [BabyCommentInfo]){
        self.comment = list + self.comment
    }
    
}

class BabyPicList: JSONJoy {
    var status:String?
    var objectlist: [BabyPicInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<BabyPicInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<BabyPicInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(BabyPicInfo(childs))
        }
    }
    
    func append(list: [BabyPicInfo]){
        self.objectlist = list + self.objectlist
    }
}

class BabyPicInfo: JSONJoy {
    
    var pictureurl:String?
    init() {
        
    }
    required init(_ decoder: JSONDecoder){
        pictureurl = decoder["pictureurl"].string

    }
    
}


class BabyLikeList: JSONJoy {
    var status:String?
    var objectlist: [BabyLikeInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<BabyLikeInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<BabyLikeInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(BabyLikeInfo(childs))
        }
    }
    
    func append(list: [BabyLikeInfo]){
        self.objectlist = list + self.objectlist
    }
}

class BabyLikeInfo: JSONJoy {
    
    var userid:String
    var name:String
    var avatar:String
    required init(_ decoder: JSONDecoder){
        name = decoder["name"].string ?? ""
        userid = decoder["userid"].string ?? ""
        avatar = decoder["avatar"].string ?? ""
    }
    
}

class BabyCommentList: JSONJoy {
    var status:String?
    var objectlist: [BabyCommentInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<BabyCommentInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<BabyCommentInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(BabyCommentInfo(childs))
        }
    }
    
    func append(list: [BabyCommentInfo]){
        self.objectlist = list + self.objectlist
    }
}

class BabyCommentInfo: JSONJoy {
    
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

