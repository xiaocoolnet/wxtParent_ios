//
//  TeaList.swift
//  WXT_Parents
//
//  Created by 牛尧 on 16/3/15.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//


import Foundation

class TeaModel: JSONJoy{
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

class TeaList: JSONJoy {
    var status:String?
    var objectlist: [TeaInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<TeaInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<TeaInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(TeaInfo(childs))
        }
    }
    
    func append(list: [TeaInfo]){
        self.objectlist = list + self.objectlist
    }
    
}

class TeaInfo: JSONJoy{
    var classid:String?
    var classname:String?
    var teacherlist = Array<TealistInfo>()
    
    required init(_ decoder: JSONDecoder){
        classid = decoder["classid"].string
        classname = decoder["classid"].string

        if decoder["teacherlist"].array != nil {
            for childs: JSONDecoder in decoder["teacherlist"].array!{
                self.teacherlist.append(TealistInfo(childs))
            }
        }
    }
    func addpend(list: [TealistInfo]){
        self.teacherlist = list + self.teacherlist
    }
}

class tealistList: JSONJoy {
    var status:String?
    var objectlist: [TealistInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<TealistInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<TealistInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(TealistInfo(childs))
        }
    }
    
    func append(list: [TealistInfo]){
        self.objectlist = list + self.objectlist
    }
}

class TealistInfo: JSONJoy {
    
    var id:String
    var name:String
    var sex:String
    var phone:String
    var photo:String
    
    required init(_ decoder: JSONDecoder){
        id = decoder["id"].string ?? ""
        name = decoder["name"].string ?? ""
        photo = decoder["photo"].string ?? ""
        sex = decoder["sex"].string ?? ""
        phone = decoder["phone"].string ?? ""
        
    }
    
}

