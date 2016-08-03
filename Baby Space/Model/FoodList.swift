//
//  FoodList.swift
//  WXT_Parents
//
//  Created by 牛尧 on 16/3/11.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation

class FoodList: JSONJoy {
    var objectlist: [FoodInfo]
    var count: Int{
        return self.objectlist.count
    }
    
    init(){
        objectlist = Array<FoodInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<FoodInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(FoodInfo(childs))
        }
    }
    
    func append(list: [FoodInfo]){
        self.objectlist = list + self.objectlist
    }
}

class FoodInfo: JSONJoy{

    
    var content:String?
    var create_time:String?
    var date:String?
    var id:String?
    var photo:String?
    var title:String?
    
    
    init() {
        
    }
    required init(_ decoder: JSONDecoder){

        
        content = decoder["content"].string
        create_time = decoder["create_time"].string
        date = decoder["date"].string
        id = decoder["id"].string
        photo = decoder["photo"].string
        title = decoder["title"].string
    }
    
}
