//
//  BabyInfoModel.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/2/15.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation
class BabyTodayInfoModel: JSONJoy{
    var status:String?
    var data:BabyInfomation?
    var errorData:String?
    var datastring:String?
    init(){
    }
    required init(_ decoder:JSONDecoder){
        status = decoder["status"].string
        if status == "success"{
            data = BabyInfomation(decoder["data"])
        }else{
            errorData = decoder["data"].string
        }
        
    }
}
class BabyInfomation: JSONJoy {
    var id:String?
    var arrivetime:String?
    var leavetime:String?
    var arrivetemperature:String?
    var learntemperature:String?
    init(){
    }
    required init(_ decoder:JSONDecoder){
        id = decoder["id"].string
        arrivetime = decoder["arrivetime"].string
        leavetime = decoder["leavetime"].string
        arrivetemperature = decoder["arrivetemperature"].string
        learntemperature = decoder["learntemperature"].string
        
    }
}