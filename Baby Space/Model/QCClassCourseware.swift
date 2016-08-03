//
//  QCClassCourseware.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/20.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation
class CoursewareList: JSONJoy {
    var objectlist: [CoursewareInfo]
    var count: Int{
        return self.objectlist.count
    }
    
    init(){
        objectlist = Array<CoursewareInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<CoursewareInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(CoursewareInfo(childs))
        }
    }
    
    func append(list: [CoursewareInfo]){
        self.objectlist = list + self.objectlist
    }
}

class CoursewareInfo: JSONJoy{
    
    
    var count:String?
    var id:String?
    var subject = String()

    
    
    init() {
        
    }
    required init(_ decoder: JSONDecoder){
        
        
        count = decoder["count"].string
        id = decoder["id"].string
        subject = decoder["subject"].string!

    }
    
}