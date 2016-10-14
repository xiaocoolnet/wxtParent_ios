//
//  PersonModel.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/8/10.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation


class personModel: JSONJoy{
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

class personList: JSONJoy {
    var status:String?
    var objectlist: [personInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<personInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<personInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(personInfo(childs))
        }
    }
    
    func append(list: [personInfo]){
        self.objectlist = list + self.objectlist
    }
    
}

class personInfo: JSONJoy{
    var name:String?
    var sex:String?
    var birthday:String?
    var avatar:String?
    var hobby:String?
    var address:String?
    var delivery:String?
    var photo:String?
    var motherpro:String?
    var withmother:String?
    var fatherpro:String?
    var withfather:String?
    var classid:String?
    var classname:String?

    var parentinfo = Array<parentinfoInfo>()
    
    
    required init(_ decoder: JSONDecoder){
        name = decoder["name"].string
        sex = decoder["sex"].string
        birthday = decoder["birthday"].string
        avatar = decoder["avatar"].string
        hobby = decoder["hobby"].string
        address = decoder["address"].string
        delivery = decoder["delivery"].string
        photo = decoder["photo"].string
        motherpro = decoder["motherpro"].string
        withmother = decoder["withmother"].string
        fatherpro = decoder["fatherpro"].string
        withfather = decoder["withfather"].string
        classid = decoder["classid"].string
        classname = decoder["classname"].string
        if decoder["parentinfo"].array != nil {
            for childs: JSONDecoder in decoder["parentinfo"].array!{
                self.parentinfo.append(parentinfoInfo(childs))
            }
        }
    }
    func addpend(list: [parentinfoInfo]){
        self.parentinfo = list + self.parentinfo
    }
    
}

class parentinfoList: JSONJoy {
    var status:String?
    var objectlist: [parentinfoInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<parentinfoInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<parentinfoInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(parentinfoInfo(childs))
        }
    }
    
    func append(list: [parentinfoInfo]){
        self.objectlist = list + self.objectlist
    }
}

class parentinfoInfo: JSONJoy {
    
    var parentid:String
    var parent_name:String
    var parent_photo:String
    var parent_phone:String
    var parent_sex:String
    
    required init(_ decoder: JSONDecoder){
        parentid = decoder["parentid"].string ?? ""
        parent_name = decoder["parent_name"].string ?? ""
        parent_photo = decoder["parent_photo"].string ?? ""
        parent_phone = decoder["parent_phone"].string ?? ""
        parent_sex = decoder["parent_sex"].string ?? ""
        
    }
    
}

