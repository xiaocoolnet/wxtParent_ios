//
//  QCBabyFirendModel.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/20.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation


class BabyFirendList:JSONJoy{
    var objectlist:[BabyFirendInfo]
    var count:Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<BabyFirendInfo>()
    }
    required init(_ decoder:JSONDecoder)
    {
        objectlist = Array<BabyFirendInfo>()
        for useids: JSONDecoder in decoder.array!{
            objectlist.append(BabyFirendInfo(useids))
            
        }
    }
    func append(list:[BabyFirendInfo]){
        self.objectlist = list + self.objectlist
    }
}
class BabyFirendInfo: JSONJoy{
    var id:String?
    var name:String?
    var photo:String?
    init(){
    }
    required init(_ decoder: JSONDecoder) {
        id = decoder["id"].string
        name = decoder["name"].string
        photo = decoder["photo"].string
    }
}
