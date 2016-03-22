//
//  ErweimaList.swift
//  WXT_Parents
//
//  Created by 牛尧 on 16/3/20.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//
import Foundation
class CodeResult: JSONJoy{
    var status:String?
    var data:codeInfo?
    var errorData:String?
    var datastring:String?
    //var uid:String?
    init(){
    }
    required init(_ decoder:JSONDecoder){
        status = decoder["status"].string
        if status == "success"{
            data = codeInfo(decoder["data"])
        }else{
            errorData = decoder["data"].string
        }
        
    }
}
class codeInfo: JSONJoy {
    var codename:String?
   
    init(){
    }
    required init(_ decoder:JSONDecoder){
        codename = decoder["codename"].string
  
    }
}

