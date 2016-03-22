//
//  CommentList.swift
//  WXT_Parents
//
//  Created by 牛尧 on 16/3/12.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

class CommentList: JSONJoy {
    var objectlist: [CommentInfo]
    var count: Int{
        return self.objectlist.count
    }
    
    init(){
        objectlist = Array<CommentInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<CommentInfo>()
        for useids: JSONDecoder in decoder.array!{
            objectlist.append(CommentInfo(useids))
        }
    }
    
    func append(list: [CommentInfo]){
        self.objectlist = list + self.objectlist
    }
}

class CommentInfo: JSONJoy{
    var name:String?
    var comment_content:String?
    var comment_time:String?
    
    init() {
        
    }
    required init(_ decoder: JSONDecoder){
        name = decoder["name"].string
        comment_time = decoder["comment_time"].string
        comment_content = decoder["comment_content"].string
    }
    
}
