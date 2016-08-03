//
//  JobList.swift
//  WXT_Parents
//
//  Created by zhang on 16/6/3.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation

class JobList: JSONJoy {
    var joblist: [JobInfo]
    var count: Int{
        return self.joblist.count
    }
    
    init(){
        joblist = Array<JobInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        joblist = Array<JobInfo>()
        for useids: JSONDecoder in decoder.array!{
            joblist.append(JobInfo(useids))
        }
    }
    
    func append(list: [JobInfo]){
        self.joblist = list + self.joblist
    }
}
//  需要进行修改
class JobInfo: JSONJoy{
    var id:String?
    var introduce:String?
    var istop:String?
    var post_content:String?
    var post_date:String?
    var post_excerpt:String?
    var post_status:String?
    var post_title:String?
    var school_name:String?
    var schoolid:String?
    var smeta:String?

    init() {
        
    }
    required init(_ decoder: JSONDecoder){
        id = decoder["id"].string
        introduce = decoder["introduce"].string
        istop = decoder["istop"].string
        post_content = decoder["post_content"].string
        post_date = decoder["post_date"].string
        post_excerpt = decoder["post_excerpt"].string
        post_status = decoder["post_status"].string
        post_title = decoder["post_title"].string
        school_name = decoder["school_name"].string
        schoolid = decoder["schoolid"].string
        smeta = decoder["smeta"].string
    }
    
}