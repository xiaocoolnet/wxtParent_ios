//
//  QCFirendModel.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/3.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation



class QCFirendList: JSONJoy{
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
        }else{
            //  得到错误提示
            errorData = decoder["data"].string
        }
    }
}




// 得到 Model (通过解析后得到的内容才是 model )
class QCFirendInfo: JSONJoy{
    //    var status :String?
    var objectList:[QCFirendModel]
    var count: Int{
        return self.objectList.count
    }
    //  需要这一步
    init (){
        objectList = Array<QCFirendModel>()
    }
    required init(_ decoder: JSONDecoder) {
        objectList = Array<QCFirendModel>()
        for model: JSONDecoder in decoder.array!{
            objectList.append(QCFirendModel(model))
        }
    }
    //
    func append (list :[QCFirendModel]){
        self.objectList = list + self.objectList
    }
}


// 这里是 Model 里面的内容列表，并不是所谓的 model
class QCFirendModel: JSONJoy {
    var allreader :String?
    var avatar :String?
    //  数组
    var comment :JSONDecoder?
    var content :String?
    var create_time :String?
    var id :String?
    
    var like :JSONDecoder?
    var photo :String?
    var pic :String?
    var readcount :String?
    var readtag :String?
    var title :String?
    var type :String?
    var userid :String?
    var username :String?
    
    
    
    required init(_ decoder: JSONDecoder) {
        allreader = decoder["allreader"].string
        avatar = decoder["avatar"].string
        content = decoder["content"].string
        create_time = decoder["create_time"].string
        id = decoder["id"].string
        photo = decoder["photo"].string
        pic = decoder["pic"].string
        readcount = decoder["readcount"].string
        readtag = decoder["readtag"].string
        title = decoder["title"].string
        type = decoder["type"].string
        userid = decoder["userid"].string
        username = decoder["username"].string
        
        
        //   数组的定义
        comment = decoder["comment"]
        like = decoder["like"]
        
        

    }
}