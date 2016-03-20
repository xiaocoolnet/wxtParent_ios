//
//  ActivitiesList.swift
//  WXT_Parents
//
//  Created by 牛尧 on 16/3/19.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation
class ActList: JSONJoy {
    var objectlist: [ActInfo]
    var count: Int{
        return self.objectlist.count
    }
    
    init(){
        objectlist = Array<ActInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<ActInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(ActInfo(childs))
        }
    }
    
    func append(list: [ActInfo]){
        self.objectlist = list + self.objectlist
    }
}

class ActInfo: JSONJoy{
    var activity_title:String?
    var activity_content:String?
    var activity_time:String?
    var activity_pic:String?
    init() {
        
    }
    required init(_ decoder: JSONDecoder){
        activity_content = decoder["activity_content"].string
        activity_title = decoder["activity_title"].string
        activity_time = decoder["activity_time"].string
        activity_pic = decoder["activity_pic"].string
    }
    
}
