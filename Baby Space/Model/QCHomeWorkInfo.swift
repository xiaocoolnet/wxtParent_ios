//
//  QCHomeWorkInfo.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/22.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation

class QCHomeWorkList: JSONJoy {
    var homeworkList: [QCHomeWorkInfo]
    var count: Int{
        return self.homeworkList.count
    }
    
    init(){
        homeworkList = Array<QCHomeWorkInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        homeworkList = Array<QCHomeWorkInfo>()
        for childs: JSONDecoder in decoder.array!{
            homeworkList.append(QCHomeWorkInfo(childs))
        }
    }
    
    func append(list: [QCHomeWorkInfo]){
        self.homeworkList = list + self.homeworkList
    }
}

class QCHomeWorkInfo: JSONJoy{
    var content:String?
    var create_time:String?
    var id:String?
    var name:String?
    var photo:String?
    var subject:String?
    var title:String?
    var userid:String?
    
    
    init() {
        
    }
    required init(_ decoder: JSONDecoder){
        content = decoder["content"].string
        id = decoder["id"].string
        create_time = decoder["create_time"].string
        subject = decoder["subject"].string
        name = decoder["name"].string
        photo = decoder["photo"].string
        title = decoder["title"].string
        userid = decoder["userid"].string

    }
    
}