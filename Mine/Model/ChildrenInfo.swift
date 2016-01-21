//
//  ChildrenInfo.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/1/21.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation
import Foundation
class ChildrenList: JSONJoy {
//    var status:String?
//    var errorData:String?
    var objectlist: [ChildrenInfo]
    var count: Int{
        return self.objectlist.count
    }
    
    init(){
        objectlist = Array<ChildrenInfo>()
    }
    required init(_ decoder: JSONDecoder) {
//        status = decoder["status"].string
        objectlist = Array<ChildrenInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(ChildrenInfo(childs))
        }
    }
    
    func append(list: [ChildrenInfo]){
        self.objectlist = list + self.objectlist
    }
}
// MARK: -Partner
class ChildrenInfo: JSONJoy{
    var childrenid: String?
    var appellation:String?
    var bind_status:String?
    var preferred:String?
    init() {
        
    }
    required init(_ decoder: JSONDecoder){
        childrenid = decoder["studentid"].string
        appellation = decoder["appellation"].string
        bind_status = decoder["bind_status"].string
        preferred = decoder["preferred"].string
    }
    
}