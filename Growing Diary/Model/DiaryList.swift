//
//  DiaryList.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/1/29.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation

class DiaryList: JSONJoy {
    var objectlist: [DiaryInfo]
    var count: Int{
        return self.objectlist.count
    }
    
    init(){
        objectlist = Array<DiaryInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<DiaryInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(DiaryInfo(childs))
        }
    }
    
    func append(list: [DiaryInfo]){
        self.objectlist = list + self.objectlist
    }
}
class DiaryInfo: JSONJoy{
    var cover_photo:String?
    var title:String?
    var content:String?
    var write_time:String?
    init() {
        
    }
    required init(_ decoder: JSONDecoder){
        cover_photo = decoder["cover_photo"].string
        title = decoder["title"].string
        content = decoder["content"].string
        write_time = decoder["write_time"].string
    }
    
}
