//
//  SchoolList.swift
//  WXT_Parents
//
//  Created by zhang on 16/6/12.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation

import Foundation

class SchoolList: JSONJoy{
    var status:String?
    var data:SchoolInfo?
    var errorData:String?
    var datastring:String?
    //var uid:String?
    init(){
    }
    required init(_ decoder:JSONDecoder){
        status = decoder["status"].string
        if status == "success"{
            data = SchoolInfo(decoder["data"])
        }else{
            errorData = decoder["data"].string
        }
        
    }
}
class SchoolInfo: JSONJoy {
    var detail:String?
    var phone:String?
    var photo:String?
    var school_address:String?
    var school_name:String?
    var school_user:String?
    var schoolid:String?
    init(){
    }
    required init(_ decoder:JSONDecoder){
        detail = decoder["detail"].string
        phone = decoder["phone"].string
        photo = decoder["photo"].string
        school_address = decoder["school_address"].string
        school_name = decoder["school_name"].string
        school_user = decoder["school_user"].string
        schoolid = decoder["schoolid"].string
    }
}



