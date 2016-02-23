//
//  GetChange_sta_weiModel.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/2/15.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation
class GetChange_sta_weiModel: JSONJoy{
    var status:String?
    var data:sta_weiInfomation?
    var errorData:String?
    var datastring:String?
    init(){
    }
    required init(_ decoder:JSONDecoder){
        status = decoder["status"].string
        if status == "success"{
            data = sta_weiInfomation(decoder["data"])
        }else{
            errorData = decoder["data"].string
        }
        
    }
}
class sta_weiInfomation: JSONJoy {
    var id:String?
    var old_stature:String?
    var new_stature:String?
    var old_weight:String?
    var new_weight:String?
    init(){
    }
    required init(_ decoder:JSONDecoder){
        id = decoder["id"].string
        old_stature = decoder["old_stature"].string
        new_stature = decoder["new_stature"].string
        old_weight = decoder["old_weight"].string
        new_weight = decoder["new_weight"].string
        
    }
}
