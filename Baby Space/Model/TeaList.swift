//
//  TeaList.swift
//  WXT_Parents
//
//  Created by 牛尧 on 16/3/15.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//


import Foundation

class TeaList: JSONJoy {
    var objectlist: [TeaInfo]
    var count: Int{
        return self.objectlist.count
    }
    
    init(){
        objectlist = Array<TeaInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<TeaInfo>()
        for useids: JSONDecoder in decoder.array!{
            objectlist.append(TeaInfo(useids))
        }
    }
    
    func append(list: [TeaInfo]){
        self.objectlist = list + self.objectlist
    }
}

class TeaInfo: JSONJoy{
    var name:String?
    var phone:String?
    
    
    init() {
        
    }
    required init(_ decoder: JSONDecoder){
        name = decoder["name"].string
        phone = decoder["phone"].string
        
    }
    
}
