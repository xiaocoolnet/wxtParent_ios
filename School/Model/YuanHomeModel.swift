//
//  YuanHomeModel.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/27.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation

class YuanHomeModel: JSONJoy{
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

class YuanHomeList: JSONJoy {
    var status:String?
    var objectlist: [YuanHomeInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<YuanHomeInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<YuanHomeInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(YuanHomeInfo(childs))
        }
    }
    
    func append(list: [YuanHomeInfo]){
        self.objectlist = list + self.objectlist
    }
    
}

class YuanHomeInfo: JSONJoy{
    var schoolid:String?
    var id:String?
    var post_title:String?
    var post_excerpt:String?
    var post_date:String?
    var smeta:String?
    var thumb:String?
    
    
    required init(_ decoder: JSONDecoder){
        schoolid = decoder["schoolid"].string
        id = decoder["id"].string
        post_title = decoder["post_title"].string
        post_excerpt = decoder["post_excerpt"].string
        post_date = decoder["post_date"].string
        smeta = decoder["smeta"].string
        thumb = decoder["thumb"].string
    }
    
}

