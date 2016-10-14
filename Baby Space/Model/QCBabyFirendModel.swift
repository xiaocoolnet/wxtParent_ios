//
//  QCBabyFirendModel.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/20.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation


class BabyFirendModel: JSONJoy{
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

class BabyFirendList: JSONJoy {
    var status:String?
    var objectlist: [BabyFirendInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<BabyFirendInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<BabyFirendInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(BabyFirendInfo(childs))
        }
    }
    
    func append(list: [BabyFirendInfo]){
        self.objectlist = list + self.objectlist
    }
    
}

class BabyFirendInfo: JSONJoy{
    var id:String?
    var name:String?
    var photo:String?
    var blog_coutn:String?
    var sex:String?
    
    required init(_ decoder: JSONDecoder){
        id = decoder["id"].string
        name = decoder["name"].string
        photo = decoder["photo"].string
        blog_coutn = decoder["blog_coutn"].string
        sex = decoder["sex"].string

    }
}