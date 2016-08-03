//
//  QCYuerModel.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/22.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation

class YuErList: JSONJoy{
    
    var status: String?
    var objectList:[yuErInfo]
    var count: Int{
        return self.objectList.count
    }
    //  初始化数组
    init(){
        objectList = Array<yuErInfo>()
    }
    
    required init(_ decoder: JSONDecoder) {
        objectList = Array<yuErInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectList.append(yuErInfo(childs))
        }
    }
    func append (list :[yuErInfo]){
        self.objectList = list + self.objectList
    }
}





//  在视图里面进行的操作
class yuErInfo: JSONJoy {
    //  需要的属性
    var happy_content:String?
    var happy_pic:String?
    var happy_time:String?
    var happy_title:String?
    var releasename:String?
    
    init(){
        
    }
    
    required init(_ decoder: JSONDecoder){
        happy_content = decoder["happy_content"].string
        happy_pic = decoder["happy_pic"].string
        happy_time = decoder["happy_time"].string
        happy_title = decoder["happy_title"].string
        releasename = decoder["releasename"].string
        
    }
}