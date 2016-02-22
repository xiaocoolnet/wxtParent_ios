//
//  ClassList.swift
//  WXT_Parents
//
//  Created by Mac on 16/2/21.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation

class ClassList: JSONJoy {
    var objectlist: [ClassInfo]
    var count: Int{
        return self.objectlist.count
    }
    
    init(){
        objectlist = Array<ClassInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<ClassInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(ClassInfo(childs))
        }
    }
    
    func append(list: [ClassInfo]){
        self.objectlist = list + self.objectlist
    }
}

class ClassInfo: JSONJoy{
    var cover_photo:String?
    var title:String?
    
    init() {
        
    }
    required init(_ decoder: JSONDecoder){
        cover_photo = decoder["cover_photo"].string
        title = decoder["title"].string
            }
    
}
