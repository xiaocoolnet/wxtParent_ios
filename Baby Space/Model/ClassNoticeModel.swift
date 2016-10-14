//
//  ClassNoticeModel.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/8/1.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation

class ClassNoticeModel: JSONJoy{
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

class ClassNoticeList: JSONJoy {
    var status:String?
    var objectlist: [ClassNoticeInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<ClassNoticeInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<ClassNoticeInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(ClassNoticeInfo(childs))
        }
    }
    
    func append(list: [ClassNoticeInfo]){
        self.objectlist = list + self.objectlist
    }
    
}

class ClassNoticeInfo: JSONJoy{
    var noticeid:String?
    var id:String?
    var receiverid:String?
    var receivertype:String?
    var create_time:String?
    var receive_list = Array<ClassReceive_listInfo>()
    var pic = Array<ClassPicInfo>()
    var receiv_list = Array<receivlistInfo>()
    
    required init(_ decoder: JSONDecoder){
        receiverid = decoder["receiverid"].string
        id = decoder["id"].string
        noticeid = decoder["noticeid"].string
        receivertype = decoder["receivertype"].string
        create_time = decoder["create_time"].string
        if decoder["notice_info"].array != nil {
            for childs: JSONDecoder in decoder["notice_info"].array!{
                self.receive_list.append(ClassReceive_listInfo(childs))
            }
        }
        if decoder["pic"].array != nil {
            for childs: JSONDecoder in decoder["pic"].array!{
                self.pic.append(ClassPicInfo(childs))
            }
        }
        if decoder["receiv_list"].array != nil {
            for childs: JSONDecoder in decoder["receiv_list"].array!{
                self.receiv_list.append(receivlistInfo(childs))
            }
        }
    }
    func addpend(list: [ClassReceive_listInfo]){
        self.receive_list = list + self.receive_list
    }
    func addpend(list: [ClassPicInfo]){
        self.pic = list + self.pic
    }
    func addpend(list: [receivlistInfo]){
        self.receiv_list = list + self.receiv_list
    }
    
}

class ClassReceive_listList: JSONJoy {
    var status:String?
    var objectlist: [ClassReceive_listInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<ClassReceive_listInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<ClassReceive_listInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(ClassReceive_listInfo(childs))
        }
    }
    
    func append(list: [ClassReceive_listInfo]){
        self.objectlist = list + self.objectlist
    }
}

class ClassReceive_listInfo: JSONJoy {
    
    var name:String
    var photo:String
    var id:String
    var userid:String
    var title:String
    var type:String
    var content:String
    var create_time:String
    
    
    required init(_ decoder: JSONDecoder){
        name = decoder["name"].string ?? ""
        photo = decoder["photo"].string ?? ""
        id = decoder["id"].string ?? ""
        userid = decoder["userid"].string ?? ""
        title = decoder["title"].string ?? ""
        type = decoder["type"].string ?? ""
        content = decoder["content"].string ?? ""
        create_time = decoder["create_time"].string ?? ""
        
    }
    
}


class ClassPicList: JSONJoy {
    var status:String?
    var objectlist: [ClassPicInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<ClassPicInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<ClassPicInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(ClassPicInfo(childs))
        }
    }
    
    func append(list: [ClassPicInfo]){
        self.objectlist = list + self.objectlist
    }
}

class ClassPicInfo: JSONJoy {
    
    var photo:String
    
    required init(_ decoder: JSONDecoder){
        photo = decoder["photo"].string ?? ""
        
        
    }
    
}

class receivlistInfoList: JSONJoy {
    var status:String?
    var objectlist: [receivlistInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<receivlistInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<receivlistInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(receivlistInfo(childs))
        }
    }
    
    func append(list: [receivlistInfo]){
        self.objectlist = list + self.objectlist
    }
}

class receivlistInfo: JSONJoy {
    
    var receiverid:String
    var create_time:String
    var noticeid:String
    var receivertype:String
    
    required init(_ decoder: JSONDecoder){
        receiverid = decoder["receiverid"].string ?? ""
        noticeid = decoder["noticeid"].string ?? ""
        create_time = decoder["create_time"].string ?? ""
        receivertype = decoder["receivertype"].string ?? ""
    }
    
}

