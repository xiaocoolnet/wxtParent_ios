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
    var recipe_pic:String?
    var recipe_title:String?
    var recipe_info:String?

    
    init() {
        
    }
    required init(_ decoder: JSONDecoder){
        recipe_pic = decoder["recipe_pic"].string
        recipe_title = decoder["recipe_title"].string
        recipe_info = decoder["recipe_info"].string
    }
    
}
