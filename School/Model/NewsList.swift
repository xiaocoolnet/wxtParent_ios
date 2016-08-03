//
//  NewsList.swift
//  WXT_Parents
//
//  Created by JQ on 16/6/25.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation
//  得到url里面所有的内容(是一个模型)
class NewsModel:JSONJoy{
    // 定义模型内的属性
    var status: String?
    var data: JSONDecoder?
    var array: Array<JSONDecoder>?
    var errorData: String?
    
    required init(_ decoder: JSONDecoder) {
        //  初始化模型内的属性（赋值）
        status = decoder["status"].string
        //  进行判断来初始化其余的数据
        if status == "success"{
            //  现在取到了数组数据
            data = decoder["data"]
        
        }else{
            errorData = decoder["data"].string
        }
    }
}
//
class  NewsList: JSONJoy{
    //  定义属性
    var objectList: [NewsInfo]
    var count: Int{
        print(self.objectList.count)
        return self.objectList.count
    }
    //  初始化数组
    init(){
        objectList = Array<NewsInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        //  初始化属性(数组的初始化)
        objectList = Array<NewsInfo>()
        
        for childs: JSONDecoder in decoder.array!{
            objectList.append(NewsInfo(childs))
        }
    }
    //  写一个方法
    func append (list: [NewsInfo]){
        self.objectList = list + self.objectList
    }
    
}

//  定义需要得到的属性
class NewsInfo:JSONJoy{
    var id:String?
    var post_date:String?
    var post_excerpt:String?
    var post_title:String?
    var schoolid:String?
    var smeta:String?
    var thumb:String?
    required init(_ decoder: JSONDecoder) {
        //  给得到的属性进行赋值(初始化)
        id = decoder["id"].string
        post_date = decoder["post_date"].string
        post_excerpt = decoder["post_excerpt"].string
        post_title = decoder["post_title"].string
        schoolid = decoder["schoolid"].string
        smeta = decoder["smeta"].string
        thumb = decoder["thumb"].string
    }
}




