//
//  InviteModel.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/8/4.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation

class InviteModel: JSONJoy{
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

class InviteList: JSONJoy {
    var status:String?
    var objectlist: [InviteInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<InviteInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<InviteInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(InviteInfo(childs))
        }
    }
    
    func append(list: [InviteInfo]){
        self.objectlist = list + self.objectlist
    }
    
}

class InviteInfo: JSONJoy{
    var appellation:String?
    var userid:String?
    var type:String?
    var parent_info = Array<InviteParent_infoInfo>()
    
    required init(_ decoder: JSONDecoder){
        appellation = decoder["appellation"].string
        type = decoder["type"].string
        userid = decoder["userid"].string
       
        if decoder["parent_info"].array != nil {
            for childs: JSONDecoder in decoder["parent_info"].array!{
                self.parent_info.append(InviteParent_infoInfo(childs))
            }
        }
    }
    func addpend(list: [InviteParent_infoInfo]){
        self.parent_info = list + self.parent_info
    }
    
}

class InviteParent_infoList: JSONJoy {
    var status:String?
    var objectlist: [InviteParent_infoInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<InviteParent_infoInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<InviteParent_infoInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(InviteParent_infoInfo(childs))
        }
    }
    
    func append(list: [InviteParent_infoInfo]){
        self.objectlist = list + self.objectlist
    }
}

class InviteParent_infoInfo: JSONJoy {
    
    var name:String?
    var phone:String?
    var photo:String?
    init() {
        
    }
    required init(_ decoder: JSONDecoder){
        name = decoder["name"].string
        phone = decoder["phone"].string
        photo = decoder["photo"].string
        
    }
    
}

