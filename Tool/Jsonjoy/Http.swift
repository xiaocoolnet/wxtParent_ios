//
//  Httpresult.swift
//  yunzhuyangche_shop
//
//  Created by LCB on 15/8/21.
//  Copyright (c) 2015年 lcb. All rights reserved.
//

import Foundation

class Http: JSONJoy{
    var status:String?
    var data:JSONDecoder?
    var datastring:String?
    var uid:String?
    init(){
    }
    required init(_ decoder:JSONDecoder){
        status = decoder["status"].string
        data = decoder["data"]
        uid = decoder["uid"].string
        //        println("ddd")
        //        var d = Partner(data!)
        //        println(d.username)
        //        println("end")
    }
}
