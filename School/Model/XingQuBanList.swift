//
//  XingQuBanList.swift
//  WXT_Parents
//
//  Created by zhang on 16/6/15.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation

class XingQuBanList: JSONJoy {
    var xiangquBanlist: [XingQuBanInfo]
    var count: Int{
        return self.xiangquBanlist.count
    }
    
    init(){
        xiangquBanlist = Array<XingQuBanInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        xiangquBanlist = Array<XingQuBanInfo>()
        for useids: JSONDecoder in decoder.array!{
            xiangquBanlist.append(XingQuBanInfo(useids))
        }
    }
    
    func append(list: [XingQuBanInfo]){
        self.xiangquBanlist = list + self.xiangquBanlist
    }
}

class XingQuBanInfo: JSONJoy{
    var status:String?
    var post_date:String?
    var post_excerpt:String?
    var post_keywords:String?
    var description:String?
    var post_title:String?
    var id:String?
    var thumb:String?
    var schoolid:String?
    var smeta:String?

    init() {
        
    }
    required init(_ decoder: JSONDecoder){

        id = decoder["id"].string
        thumb = decoder["thumb"].string
        schoolid = decoder["schoolid"].string
        smeta = decoder["smeta"].string
        post_title = decoder["post_title"].string
        print(post_title)
        description = decoder["description"].string
        post_keywords = decoder["post_keywords"].string
        post_date = decoder["post_date"].string
        post_excerpt = decoder["post_excerpt"].string
        status = decoder["status"].string
    }
    
}