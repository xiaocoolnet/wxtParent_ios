//
//  HomeWorkModel.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/25.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation

class NewsMod: JSONJoy{
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

class NewsLi: JSONJoy {
    var status:String?
    var objectlist: [NewsIn]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<NewsIn>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<NewsIn>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(NewsIn(childs))
        }
    }
    
    func append(list: [NewsIn]){
        self.objectlist = list + self.objectlist
    }
    
}

class NewsIn: JSONJoy{
    var homework_id:String?
    var id:String?
    var read_time:String?
    var receiverid:String?
    
//    var homework_info:JSONDecoder?
//    var pictur:JSONDecoder?
    var homework_inf = Array<LikeInfo>()
    var pictur = Array<PiInfo>()
    var receive_list = Array<HomeInfo>()
    
    required init(_ decoder: JSONDecoder){
        homework_id = decoder["homework_id"].string
        id = decoder["id"].string
        read_time = decoder["read_time"].string
        receiverid = decoder["receiverid"].string
//        homework_info = decoder["homework_info"]
//        picture = decoder["picture"]
        if decoder["homework_info"].array != nil {
            for childs: JSONDecoder in decoder["homework_info"].array!{
                self.homework_inf.append(LikeInfo(childs))
            }
        }
        if decoder["picture"].array != nil {
            for childs: JSONDecoder in decoder["picture"].array!{
                self.pictur.append(PiInfo(childs))
            }
        }
        if decoder["receive_list"].array != nil {
            for childs: JSONDecoder in decoder["receive_list"].array!{
                self.receive_list.append(HomeInfo(childs))
            }
        }
    }
    func addpend(list: [LikeInfo]){
        self.homework_inf = list + self.homework_inf
    }
    func addpend(list: [PiInfo]){
        self.pictur = list + self.pictur
    }
    func addpend(list: [HomeInfo]){
        self.receive_list = list + self.receive_list
    }

    
}

class LikeList: JSONJoy {
    var status:String?
    var objectlist: [LikeInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<LikeInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<LikeInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(LikeInfo(childs))
        }
    }
    
    func append(list: [LikeInfo]){
        self.objectlist = list + self.objectlist
    }
}

class LikeInfo: JSONJoy {
    
    var content:String
    var create_time:String
    var id:String
    var name:String
    var photo:String
    var subject:String
    var title:String
    var userid:String
    
    
    required init(_ decoder: JSONDecoder){
        content = decoder["content"].string ?? ""
        id = decoder["id"].string ?? ""
        create_time = decoder["create_time"].string ?? ""
        subject = decoder["subject"].string ?? ""
        name = decoder["name"].string ?? ""
        photo = decoder["photo"].string ?? ""
        title = decoder["title"].string ?? ""
        userid = decoder["userid"].string ?? ""
        
    }

}


class PiList: JSONJoy {
    var status:String?
    var objectlist: [PiInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<PiInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<PiInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(PiInfo(childs))
        }
    }
    
    func append(list: [PiInfo]){
        self.objectlist = list + self.objectlist
    }
}

class PiInfo: JSONJoy {
    
    var picture_url:String
    
    
//    init() {
//        
//    }
    required init(_ decoder: JSONDecoder){
        picture_url = decoder["picture_url"].string ?? ""
        
    }
    
}

class HomeList: JSONJoy {
    var status:String?
    var objectlist: [HomeInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<HomeInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<HomeInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(HomeInfo(childs))
        }
    }
    
    func append(list: [HomeInfo]){
        self.objectlist = list + self.objectlist
    }
}

class HomeInfo: JSONJoy {
    
    var read_time:String
    

    required init(_ decoder: JSONDecoder){
        read_time = decoder["read_time"].string ?? ""
        
    }
    
}



