//
//  ChildrenInfo.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/1/21.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation
class ChildrenModel: JSONJoy{
    var status:String?
    var data: JSONDecoder?
    var array : Array<JSONDecoder>?
    var errorData:String?
    init(){
    }
    required init(_ decoder:JSONDecoder){
        
        status = decoder["status"].string
        if status == "success" {
            data = decoder["data"]
        }
        else{
            errorData = decoder["data"].string
        }
    }
}
class ChildrenList: JSONJoy {
    var status:String?
    var objectlist: [ChildrenInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<ChildrenInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<ChildrenInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(ChildrenInfo(childs))
        }
    }
    
    func append(list: [ChildrenInfo]){
        self.objectlist = list + self.objectlist
    }
    
}

// MARK: -Partner
class ChildrenInfo: JSONJoy{
    var time: String?
    var appellation:String?
    var userid:String?
    var preferred:String?
    var id:String?
    var relation_rank:String?
    var studentid:String?
    var studentname:String?
    var studentavatar:String?
    var classlist = Array<ChildrenClassInfo>()
    
    init() {
    }
    required init(_ decoder: JSONDecoder){
        time = decoder["time"].string
        appellation = decoder["appellation"].string
        userid = decoder["userid"].string
        preferred = decoder["preferred"].string
        id = decoder["id"].string
        relation_rank = decoder["relation_rank"].string
        studentid = decoder["studentid"].string
        studentname = decoder["studentname"].string
        studentavatar = decoder["studentavatar"].string
        if decoder["classlist"].array != nil {
            for childs: JSONDecoder in decoder["classlist"].array!{
                self.classlist.append(ChildrenClassInfo(childs))
            }
        }
    }
    func addpend(list: [ChildrenClassInfo]){
        self.classlist = list + self.classlist
    }
    
}

class ChildrenClassList: JSONJoy {
    var status:String?
    var objectlist: [ChildrenClassInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<ChildrenClassInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<ChildrenClassInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(ChildrenClassInfo(childs))
        }
    }
    
    func append(list: [ChildrenClassInfo]){
        self.objectlist = list + self.objectlist
    }
}

class ChildrenClassInfo: JSONJoy {
    
    var classid:String?
    var schoolid:String?
    var classname:String?
    
    
    init() {
        
    }
    required init(_ decoder: JSONDecoder){
        classid = decoder["classid"].string
        schoolid = decoder["schoolid"].string
        classname = decoder["classname"].string
        
    }
    
}
