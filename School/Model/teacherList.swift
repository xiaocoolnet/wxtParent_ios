//
//  teacherList.swift
//  WXT_Parents
//
//  Created by JQ on 16/6/21.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation

//  得到数据模型
class TeacherModel:JSONJoy {
    //  得到请求状态
    var status: String?
    var data: JSONDecoder?
    //  数据源（data）是一个数组类型，所以需要进行进一步的取
    var array: Array<JSONDecoder>?
    var errorData: String?
    init(){
        
    }
    required init(_ decoder: JSONDecoder) {
        //  进行解析
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
class teacherList: JSONJoy{

        var status: String?
        var objectList:[teacherInfo]
        var count: Int{
            return self.objectList.count
    }
        //  初始化数组
        init(){
            objectList = Array<teacherInfo>()
        }
    
    required init(_ decoder: JSONDecoder) {
        objectList = Array<teacherInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectList.append(teacherInfo(childs))
        }
    }
    func append (list :[teacherInfo]){
        self.objectList = list + self.objectList
    }
}


//  在视图里面进行的操作
class teacherInfo: JSONJoy {
    //  需要的属性
    var id:String?
    var post_dateL:String?
    var post_excerpt:String?
    var post_keywords:String?
    var post_title:String?
    var schoolid:String?
    var smeta:String?
    var thumb:String?
    init(){
        
    }
   
    required init(_ decoder: JSONDecoder){
        //  属性初始化方法
        id = decoder["id"].string
        print("id")
        print(id)
        post_dateL = decoder["post_date"].string
        post_excerpt = decoder["post_excerpt"].string
        post_keywords = decoder["post_keywords"].string
        post_title = decoder["post_title"].string
        schoolid = decoder["schoolid"].string
        smeta = decoder["smeta"].string
        thumb = decoder["thumb"].string
        
    }
}


