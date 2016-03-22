
//
//  TeacherList.swift
//  WXT_Parents
//
//  Created by zhang on 16/4/29.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation
class TeacherList: JSONJoy {
    var teacherList: [TeacherListInfo]
    var count: Int{
        return self.teacherList.count
    }
    
    init(){
        teacherList = Array<TeacherListInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        teacherList = Array<TeacherListInfo>()
        for childs: JSONDecoder in decoder.array!{
            teacherList.append(TeacherListInfo(childs))
        }
    }
    
    func append(list: [TeacherListInfo]){
        self.teacherList = list + self.teacherList
    }
}

class TeacherListInfo: JSONJoy{
    var id:String?
    var name:String?
    var phone:String?
    
    init() {
        
    }
    required init(_ decoder: JSONDecoder){
        id = decoder["id"].string
        name = decoder["name"].string
        phone = decoder["phone"].string
        
    }
    
}