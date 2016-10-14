//
//  QCChildrenClass.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/19.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation
class ClassList: JSONJoy {
    var objectlist: [ClassInfo]
    var count: Int{
        return self.objectlist.count
    }
    
    init(){
        objectlist = Array<ClassInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        objectlist = Array<ClassInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(ClassInfo(childs))
        }
    }
    
    func append(list: [ClassInfo]){
        self.objectlist = list + self.objectlist
    }
}
// MARK: -Partner
class ClassInfo: JSONJoy{
//    var time: String?
//    var appellation:String?
//    var userid:String?
//    var preferred:String?
//    var id:String?
//    var relation_rank:String?
//    var studentid:String?
//    var studentname:String?
//    var studentavatar:String?
    var classid:String?
    var classname:String?
    var schoolid:String?
    
    init() {
    }
    required init(_ decoder: JSONDecoder){
//        time = decoder["time"].string
//        appellation = decoder["appellation"].string
//        userid = decoder["userid"].string
//        preferred = decoder["preferred"].string
//        id = decoder["id"].string
//        relation_rank = decoder["relation_rank"].string
//        studentid = decoder["studentid"].string
//        studentname = decoder["studentname"].string
//        studentavatar = decoder["studentavatar"].string
        classid = decoder["classid"].string
        schoolid = decoder["schoolid"].string
        classname = decoder["classname"].string
    }
    
}
