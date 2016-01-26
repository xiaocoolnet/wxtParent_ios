//
//  File.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/1/23.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation

class BlogList: JSONJoy {
    var objectlist: [BlogInfo]
    var count: Int{
        return self.objectlist.count
    }
    
    init(){
        objectlist = Array<BlogInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        //        status = decoder["status"].string
        objectlist = Array<BlogInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(BlogInfo(childs))
        }
    }
    
    func append(list: [BlogInfo]){
        self.objectlist = list + self.objectlist
    }
}
class BlogInfo: JSONJoy{
    var content:String?
    var name: String?
    var write_time:String?
    var photo:String?
    var piclist:JSONDecoder?
    init() {
        
    }
    required init(_ decoder: JSONDecoder){
        content = decoder["content"].string
        piclist = decoder["pic"]
        name = decoder["name"].string
        write_time = decoder["write_time"].string
        photo = decoder["photo"].string
        
    }
    
}

