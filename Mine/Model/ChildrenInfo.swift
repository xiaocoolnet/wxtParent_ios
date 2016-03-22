//
//  ChildrenInfo.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/1/21.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation
class ChildrenList: JSONJoy {
    var objectlist: [ChildrenInfo]
    var count: Int{
        return self.objectlist.count
    }
    
    init(){
        objectlist = Array<ChildrenInfo>()
    }
    required init(_ decoder: JSONDecoder) {
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
    var time: String?
    var appellation:String?
    var userid:String?
    var preferred:String?
    var id:String?
    var relation_rank:String?
    var studentid:String?
    var studentname:String?
    var studentavatar:String?
    
    init() {
    }
    required init(_ decoder: JSONDecoder){
        time = decoder["time"].string
        appellation = decoder["appellation"].string
        userid = decoder["userid"].string
        preferred = decoder["preferred"].string
        id = decoder["id"].string
        relation_rank = decoder["relation_rank"].string
        studentid = decoder["studentid"].string
        studentname = decoder["studentname"].string
        studentavatar = decoder["studentavatar"].string
    }
    
}