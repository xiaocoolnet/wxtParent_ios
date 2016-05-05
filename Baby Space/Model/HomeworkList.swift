//
//  HomeworkList.swift
//  WXT_Parents
//
//  Created by zhang on 16/4/27.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation

class HomeworkList: JSONJoy {
    var homeworkList: [HomeworkInfo]
    var count: Int{
        return self.homeworkList.count
    }
    
    init(){
        homeworkList = Array<HomeworkInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        homeworkList = Array<HomeworkInfo>()
        for childs: JSONDecoder in decoder.array!{
            homeworkList.append(HomeworkInfo(childs))
        }
    }
    
    func append(list: [HomeworkInfo]){
        self.homeworkList = list + self.homeworkList
    }
}

class HomeworkInfo: JSONJoy{
    var allreader:Int?
    var content:String?
    var create_time:String?
    var id:String?
    var photo:String?
    var readcount:Int?
    var readtag:Int?
    var userid:String?
    var username:String?
    var title:String?
    init() {
        
    }
    required init(_ decoder: JSONDecoder){
        allreader = decoder["allreader"].integer
        content = decoder["content"].string
        create_time = decoder["create_time"].string
        id = decoder["id"].string
        photo = decoder["photo"].string
        readcount = decoder["readcount"].integer
        readtag = decoder["readtag"].integer
        userid = decoder["userid"].string
        username = decoder["username"].string
        title = decoder["title"].string
    }
    
}