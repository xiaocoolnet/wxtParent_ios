//
//  ScheduleList.swift
//  WXT_Parents
//
//  Created by 牛尧 on 16/3/26.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation


class ScheduleList: JSONJoy {
    var objectlist: [SchInfo]
    var count: Int{
        return self.objectlist.count
    }
    
    init(){
        objectlist = Array<SchInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<SchInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(SchInfo(childs))
        }
    }
    
    func append(list: [SchInfo]){
        self.objectlist = list + self.objectlist
    }
}

class SchInfo: JSONJoy{
    var syllabus_name:String?
    
    init() {
        
    }
    required init(_ decoder: JSONDecoder){
        syllabus_name = decoder["syllabus_name"].string
    }
    
}
