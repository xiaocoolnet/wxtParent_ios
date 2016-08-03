//
//  QCClassCoursewareDetails.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/20.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation
class CoursewareDetailsList: JSONJoy {
    var objectlist: [CoursewareDetailsInfo]
    var count: Int{
        return self.objectlist.count
    }
    
    init(){
        objectlist = Array<CoursewareDetailsInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<CoursewareDetailsInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(CoursewareDetailsInfo(childs))
        }
    }
    
    func append(list: [CoursewareDetailsInfo]){
        self.objectlist = list + self.objectlist
    }
}

class CoursewareDetailsInfo: JSONJoy{
    
    
    var classid:String?
    var id:String?
    var istop:String?
    var post_content:String?
    var post_date:String?
    var post_excerpt:String?
    var post_status:String?
    var post_title:String?
    var schoolid:String?
//    var smeta:String?
    var subjectid:String?
    
    
    
    init() {
        
    }
    required init(_ decoder: JSONDecoder){
        
        
        classid = decoder["classid"].string
        id = decoder["id"].string
        istop = decoder["istop"].string
        post_content = decoder["post_content"].string
        post_date = decoder["post_date"].string
        post_excerpt = decoder["post_excerpt"].string
        post_status = decoder["post_status"].string
        post_title = decoder["post_title"].string
        schoolid = decoder["schoolid"].string
        classid = decoder["classid"].string
//        smeta = decoder["smeta"].string
        subjectid = decoder["subjectid"].string
        
        
    }
    
}