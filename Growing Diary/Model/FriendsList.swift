//
//  FriendsList.swift
//  WXT_Parents
//
//  Created by 牛尧 on 16/2/25.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//
import Foundation

class FriendsList: JSONJoy {
    var objectlist: [FriendsInfo]
    var count: Int{
        return self.objectlist.count
    }
    
    init(){
        objectlist = Array<FriendsInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<FriendsInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(FriendsInfo(childs))
        }
    }
    
    func append(list: [FriendsInfo]){
        self.objectlist = list + self.objectlist
    }
}
class FriendsInfo: JSONJoy{
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
