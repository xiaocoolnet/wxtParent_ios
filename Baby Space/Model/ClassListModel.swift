//
//  ClassListModel.swift
//  WXT_Parents
//
//  Created by zhang on 16/5/3.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation

class ClassListModel: JSONJoy {
    var classList: [ClassListInfo]
    var count: Int{
        return self.classList.count
    }
    
    init(){
        classList = Array<ClassListInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        classList = Array<ClassListInfo>()
        for childs: JSONDecoder in decoder.array!{
            classList.append(ClassListInfo(childs))
        }
    }
    
    func append(list: [ClassListInfo]){
        self.classList = list + self.classList
    }
}

class ClassListInfo: JSONJoy{
    var classid:String?
    var classname:String?
    var create_time:String?
    var userid:String?
    
    init() {
        
    }
    required init(_ decoder: JSONDecoder){
        classid = decoder["classid"].string
        classname = decoder["classname"].string
        create_time = decoder["create_time"].string
        userid = decoder["userid"].string
        
    }
    
}