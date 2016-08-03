//
//  QCCommentModel.swift
//  WXT_Parents
//
//  Created by JQ on 16/6/29.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation

class QCCommentList: JSONJoy{
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
class QCCommentInfo: JSONJoy{
//    var status :String?
    var objectList:[QCCommentModel]
    var count: Int{
        return self.objectList.count
    }
    //  需要这一步
    init (){
        objectList = Array<QCCommentModel>()
    }
    required init(_ decoder: JSONDecoder) {
        objectList = Array<QCCommentModel>()
        for model: JSONDecoder in decoder.array!{
            objectList.append(QCCommentModel(model))
        }
    }
    //
    func append (list :[QCCommentModel]){
        self.objectList = list + self.objectList
    }
}

    // 这里是 Model 里面的内容列表，并不是所谓的 model
class QCCommentModel: JSONJoy {
    var avatar :String?
    var comment_time :String?
    var content :String?
    var name :String?
    var photo :String?
    var userid :String?
    
    var height :CGFloat?
    required init(_ decoder: JSONDecoder) {
        avatar = decoder["avatar"].string
        comment_time = decoder["comment_time"].string
        content = decoder["content"].string
        name = decoder["name"].string
        photo = decoder["photo"].string
        userid = decoder["userid"].string
        
        height = calculateHeight(content!, size: 17, width: WIDTH * 2 / 3.0 - 23)
    }
}