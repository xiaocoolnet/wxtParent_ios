//
//  SelfGrownList.swift
//  WXT_Parents
//
//  Created by JQ on 16/6/28.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation

class SelfGrownModel: JSONJoy {
    var status :String?
    var data :JSONDecoder?
    var errorData :String?
    var array: Array<JSONDecoder>?

    required init(_ decoder: JSONDecoder) {
        status = decoder["status"].string
        if status == "success"{
            //  得到数据
            data = decoder["data"]
            print("data")
            print(data)
        }else{
            //  得到错误提示
            errorData = decoder["data"].string
            print(errorData)
        }
    }
}
//  用过这里的数据来进行数据源的获得

class SelfGrownList: JSONJoy{
    
    var status: String?
    var objectList:[SelfGrownInfo]
    var count: Int{
        return self.objectList.count
    }
    //  初始化数组
    init(){
        objectList = Array<SelfGrownInfo>()
    }
    
    required init(_ decoder: JSONDecoder) {
        objectList = Array<SelfGrownInfo>()
        for model:JSONDecoder in decoder.array!{
            objectList.append(SelfGrownInfo(model))
        }
    }
    func append (list :[SelfGrownInfo]){
        self.objectList = list + self.objectList
    }
}
//  初始化属性并赋值
class SelfGrownInfo: JSONJoy {
    var babyid :String?
    var content :String?
    var cover_photo :String?
    var grow_id :String?
    var name :String?
    var title :String?
    var userid :String?
    var write_time :String?
    
    //  绝对是数组
    var like:JSONDecoder?
    var comment:JSONDecoder?
    init() {
        
    }
    required init(_ decoder: JSONDecoder) {
        babyid = decoder["babyid"].string
        content = decoder["content"].string
        cover_photo = decoder["cover_photo"].string
        grow_id = decoder["grow_id"].string
        name = decoder["name"].string
        title = decoder["title"].string
        userid = decoder["userid"].string
        write_time = decoder["write_time"].string
        like = decoder["like"]
        comment = decoder["comment"]
        
    }
}