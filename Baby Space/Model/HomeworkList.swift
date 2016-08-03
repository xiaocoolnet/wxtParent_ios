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
    var homework_id:String?
    var id:String?
    var read_time:String?
    var receiverid:String?

    var homework_info:JSONDecoder?
    var picture:JSONDecoder?
    
    init() {
        
    }
    required init(_ decoder: JSONDecoder){
        homework_id = decoder["homework_id"].string
        id = decoder["id"].string
        read_time = decoder["read_time"].string
        receiverid = decoder["receiverid"].string
        homework_info = decoder["homework_info"]
        picture = decoder["picture"]
    }
    
}