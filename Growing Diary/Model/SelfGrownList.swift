//
//  SelfGrownList.swift
//  WXT_Parents
//
//  Created by JQ on 16/6/28.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation

class SelfGrownModel: JSONJoy {
    var status :String?
    var data :JSONDecoder?
    var errorData :String?
    var array: Array<JSONDecoder>?

    required init(_ decoder: JSONDecoder) {
        status = decoder["status"].string
        if status == "success"{
            //  得到数据
            data = decoder["data"]
            print("data")
            print(data)
        }else{
            //  得到错误提示
            errorData = decoder["data"].string
            print(errorData)
        }
    }
}
//  用过这里的数据来进行数据源的获得

class SelfGrownList: JSONJoy{
    
    var status: String?
    var objectList:[SelfGrownInfo]
    var count: Int{
        return self.objectList.count
    }
    //  初始化数组
    init(){
        objectList = Array<SelfGrownInfo>()
    }
    
    required init(_ decoder: JSONDecoder) {
        objectList = Array<SelfGrownInfo>()
        for model:JSONDecoder in decoder.array!{
            objectList.append(SelfGrownInfo(model))
        }
    }
    func append (list :[SelfGrownInfo]){
        self.objectList = list + self.objectList
    }
}
//  初始化属性并赋值
class SelfGrownInfo: JSONJoy {
//    var mid :String?
//    var type :String?
//    var schoolid :String?
//    var classid :String?
//    var userid :String?
//    var content :String?
//    var status :String?
//    var write_time :String?
//    var name :String?
//    var photo :String?
    
    //  绝对是数组
    var like = Array<selfLikeInfo>()
    var comment = Array<selfCommentInfo>()
//    var pic = Array<selfPicInfo>()
    init() {
        
    }
    required init(_ decoder: JSONDecoder) {
//        babyid = decoder["babyid"].string
//        content = decoder["content"].string
//        cover_photo = decoder["cover_photo"].string
//        grow_id = decoder["grow_id"].string
//        name = decoder["name"].string
//        title = decoder["title"].string
//        userid = decoder["userid"].string
//        write_time = decoder["write_time"].string
//        like = decoder["like"]
//        comment = decoder["comment"]
        if decoder["like"].array != nil {
            for childs: JSONDecoder in decoder["like"].array!{
                self.like.append(selfLikeInfo(childs))
            }
        }
        if decoder["comment"].array != nil {
            for childs: JSONDecoder in decoder["comment"].array!{
                self.comment.append(selfCommentInfo(childs))
            }
        }
    }
    func addpend(list: [selfLikeInfo]){
        self.like = list + self.like
    }
    func addpend(list: [selfCommentInfo]){
        self.comment = list + self.comment
    }

}



class selfLikeList: JSONJoy {
    var status:String?
    var objectlist: [selfLikeInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<selfLikeInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<selfLikeInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(selfLikeInfo(childs))
        }
    }
    
    func append(list: [selfLikeInfo]){
        self.objectlist = list + self.objectlist
    }
}

class selfLikeInfo: JSONJoy {
    
    var userid:String
    var name:String
    
    required init(_ decoder: JSONDecoder){
        name = decoder["name"].string ?? ""
        userid = decoder["userid"].string ?? ""
        
    }
}


class selfCommentList: JSONJoy {
    var status:String?
    var objectlist: [selfCommentInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<selfCommentInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<selfCommentInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(selfCommentInfo(childs))
        }
    }
    
    func append(list: [selfCommentInfo]){
        self.objectlist = list + self.objectlist
    }
}

class selfCommentInfo: JSONJoy {
    
    var avatar :String?
    var comment_time :String?
    var content :String?
    var name :String?
    var photo :String?
    var userid :String?

    required init(_ decoder: JSONDecoder) {
        avatar = decoder["avatar"].string
        comment_time = decoder["comment_time"].string
        content = decoder["content"].string
        name = decoder["name"].string
        photo = decoder["photo"].string
        userid = decoder["userid"].string
    }

    
}

