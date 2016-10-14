//
//  GetChange_sta_weiModel.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/2/15.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation

class sta_weiInfomationModel: JSONJoy{
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

class sta_weiInfomationList: JSONJoy {
    var status:String?
    var objectlist: [sta_weiInfomation]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<sta_weiInfomation>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<sta_weiInfomation>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(sta_weiInfomation(childs))
        }
    }
    
    func append(list: [sta_weiInfomation]){
        self.objectlist = list + self.objectlist
    }
    
}

class sta_weiInfomation: JSONJoy {
    var id:String?
    var old_stature:String?
    var new_stature:String?
    var old_weight:String?
    var new_weight:String?
    var log_date:String?
    var weight:String?
    var stature:String?
    init(){
    }
    required init(_ decoder:JSONDecoder){
        id = decoder["id"].string
        old_stature = decoder["old_stature"].string
        new_stature = decoder["new_stature"].string
        old_weight = decoder["old_weight"].string
        new_weight = decoder["new_weight"].string
        log_date = decoder["log_date"].string
        weight = decoder["weight"].string
        stature = decoder["stature"].string
        
    }
}
