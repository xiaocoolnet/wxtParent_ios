//
//  BabyTeacherList.swift
//  WXT_Parents
//
//  Created by Mac on 16/3/13.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation
class BabyTeacherList:JSONJoy{
    var objectlist:[TeacherInfo]
    var count:Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<TeacherInfo>()
    }
    required init(_ decoder:JSONDecoder)
    {
        objectlist = Array<TeacherInfo>()
        for useids: JSONDecoder in decoder.array!{
          objectlist.append(TeacherInfo(useids))

        }
    }
    func append(list:[TeacherInfo]){
        self.objectlist = list + self.objectlist
    }
}
class TeacherInfo: JSONJoy{
    var teachername:String?
    var teacherphone:String?
    init(){
    }
    required init(_ decoder: JSONDecoder) {
        teachername = decoder["teachername"].string
        teacherphone = decoder["teacherphone"].string
    }
}