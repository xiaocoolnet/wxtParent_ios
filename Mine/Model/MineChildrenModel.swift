//
//  MineChildrenModel.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/8/23.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation

class MineChildrenModel: JSONJoy{
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

class MineChildrenList: JSONJoy {
    var status:String?
    var objectlist: [MineChildrenInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<MineChildrenInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<MineChildrenInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(MineChildrenInfo(childs))
        }
    }
    
    func append(list: [MineChildrenInfo]){
        self.objectlist = list + self.objectlist
    }
    
}

class MineChildrenInfo: JSONJoy{
    var userid:String?
    var id:String?
    var studentid:String?
    var appellation:String?
    var relation_rank:String?
    var preferred:String?
    var type:String?
    var time:String?
    var school_name:String?
    var studentname:String?
    var studentavatar:String?
    var sex:String?
    
    var classlist = Array<ChildClassInfo>()
    
    required init(_ decoder: JSONDecoder){
        userid = decoder["userid"].string
        id = decoder["id"].string
        studentid = decoder["studentid"].string
        appellation = decoder["appellation"].string
        relation_rank = decoder["relation_rank"].string
        preferred = decoder["preferred"].string
        type = decoder["type"].string
        time = decoder["time"].string
        school_name = decoder["school_name"].string
        studentname = decoder["studentname"].string
        studentavatar = decoder["studentavatar"].string
        sex = decoder["sex"].string
        if decoder["classlist"].array != nil {
            for childs: JSONDecoder in decoder["classlist"].array!{
                self.classlist.append(ChildClassInfo(childs))
            }
        }
        
    }
    func addpend(list: [ChildClassInfo]){
        self.classlist = list + self.classlist
    }
    
}

class ChildClassList: JSONJoy {
    var status:String?
    var objectlist: [ChildClassInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<ChildClassInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<ChildClassInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(ChildClassInfo(childs))
        }
    }
    
    func append(list: [ChildClassInfo]){
        self.objectlist = list + self.objectlist
    }
}

class ChildClassInfo: JSONJoy {
    
    var classid:String
    var schoolid:String
    var classname:String
    
    required init(_ decoder: JSONDecoder){
        classid = decoder["classid"].string ?? ""
        schoolid = decoder["schoolid"].string ?? ""
        classname = decoder["classname"].string ?? ""
        
        
    }
    
}


