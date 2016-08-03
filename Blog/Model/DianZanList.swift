//
//  DianZanList.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/1/26.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.

import Foundation
class DianZanList: JSONJoy {
    var dianzanlist: [DianZan]
    var count: Int{
        return self.dianzanlist.count
    }
    
    init(){
        dianzanlist = Array<DianZan>()
    }
    required init(_ decoder: JSONDecoder) {
        dianzanlist = Array<DianZan>()
        for childs: JSONDecoder in decoder.array!{
            dianzanlist.append(DianZan(childs))
        }
    }
    
    func append(list: [DianZan]){
        self.dianzanlist = list + self.dianzanlist
    }
}
class DianZan: JSONJoy{
    var avatar:String?
    var dianZanId:String?
    var dianZanName:String?
    init() {
        
    }
    required init(_ decoder: JSONDecoder){
        dianZanId = decoder["userid"].string
        dianZanName = decoder["name"].string
    }
    
}
