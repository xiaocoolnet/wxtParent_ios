//
//  AddressList.swift
//  WXT_Parents
//
//  Created by 牛尧 on 16/3/9.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation

class AddList: JSONJoy {
    var objectlist: [AddInfo]
    var count: Int{
        return self.objectlist.count
    }
    
    init(){
        objectlist = Array<AddInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<AddInfo>()
        for useids: JSONDecoder in decoder.array!{
            objectlist.append(AddInfo(useids))
        }
    }
    
    func append(list: [AddInfo]){
        self.objectlist = list + self.objectlist
    }
}

class AddInfo: JSONJoy{
    var teacherinfo:JSONDecoder?
    var classname:String?
    var classid:String?
    var schoolid:String?
    var schoolname:String?
    init() {
        
    }
    required init(_ decoder: JSONDecoder){
        teacherinfo = decoder["teacherinfo"]
        classname = decoder["classname"].string
        classid = decoder["classid"].string
        schoolid = decoder["schoolid"].string
        schoolname = decoder["schoolname"].string
    }
    
}
