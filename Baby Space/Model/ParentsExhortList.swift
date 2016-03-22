//
//  ParentsExhortList.swift
//  WXT_Parents
//
//  Created by zhang on 16/4/29.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation

class ParentsExhortList: JSONJoy {
    var parentsExhortList: [ExhortInfo]
    var count: Int{
        return self.parentsExhortList.count
    }
    
    init(){
        parentsExhortList = Array<ExhortInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        parentsExhortList = Array<ExhortInfo>()
        for childs: JSONDecoder in decoder.array!{
            parentsExhortList.append(ExhortInfo(childs))
        }
    }
    
    func append(list: [ExhortInfo]){
        self.parentsExhortList = list + self.parentsExhortList
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
    }
    
}