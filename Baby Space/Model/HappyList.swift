//
//  HappyList.swift
//  WXT_Parents
//
//  Created by 牛尧 on 16/3/19.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//
import Foundation
class HappyList: JSONJoy {
    var objectlist: [HappyInfo]
    var count: Int{
        return self.objectlist.count
    }
    
    init(){
        objectlist = Array<HappyInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<HappyInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(HappyInfo(childs))
        }
    }
    
    func append(list: [HappyInfo]){
        self.objectlist = list + self.objectlist
    }
}

class HappyInfo: JSONJoy{
    var happy_title:String?
    var happy_content:String?
    var happy_time:String?
    var happy_pic:String?
    var releasename:String?
    init() {
        
    }
    required init(_ decoder: JSONDecoder){
        happy_content = decoder["happy_content"].string
        happy_title = decoder["happy_title"].string
        happy_time = decoder["happy_time"].string
        happy_pic = decoder["happy_pic"].string
        releasename = decoder["releasename"].string
    }
    
}
